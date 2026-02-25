-- ============================================================
-- Escuela de Idiomas Babel - SP Asignación automática (T-SQL)
-- Caso #8 - Organización de cursos y asignación de aulas/profesores
-- ============================================================

USE BabelEscuelaIdiomas;
GO

CREATE OR ALTER PROCEDURE sp_AsignacionAutomatica
    @id_modulo INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el módulo exista
    IF NOT EXISTS (SELECT 1 FROM Modulo WHERE id = @id_modulo)
    BEGIN
        RAISERROR('El módulo especificado no existe.', 16, 1);
        RETURN;
    END

    -- No ejecutar si ya hay grupos creados para este módulo (evitar duplicados)
    IF EXISTS (SELECT 1 FROM Grupo g INNER JOIN Horario h ON h.id = g.id_horario WHERE h.id_modulo = @id_modulo)
    BEGIN
        RAISERROR('La asignación automática ya fue ejecutada para este módulo.', 16, 1);
        RETURN;
    END

    -- Inscripciones deben estar por horario con id_grupo NULL (aún no asignadas)
    -- Paso 1: Obtener horarios del módulo con cantidad de inscritos (activos, sin grupo)
    -- y datos para prioridad (nivel). Crear "slots" de grupo (1 o 2 por horario según cupo).

    DECLARE @MaxAulas INT = 12;

    -- Tabla de candidatos: cada fila = un grupo a crear (slot)
    CREATE TABLE #Slots (
        id_horario    INT NOT NULL,
        id_curso      INT NOT NULL,
        nivel_orden   INT NOT NULL,
        inscritos     INT NOT NULL,
        cupo_grupo    INT NOT NULL,   -- 8 o 16
        num_grupo     INT NOT NULL,   -- 1 o 2 cuando se parten
        orden_prioridad INT NOT NULL  -- para desempate (menos alumnos = cerrar primero)
    );

    INSERT INTO #Slots (id_horario, id_curso, nivel_orden, inscritos, cupo_grupo, num_grupo, orden_prioridad)
    SELECT
        h.id,
        h.id_curso,
        n.orden,
        (SELECT COUNT(*) FROM Inscripcion i WHERE i.id_horario = h.id AND i.estado = 'activo'),
        CASE WHEN (SELECT COUNT(*) FROM Inscripcion i WHERE i.id_horario = h.id AND i.estado = 'activo') >= 16 THEN 8 ELSE 16 END,
        1,
        0
    FROM Horario h
    INNER JOIN Curso c ON c.id = h.id_curso
    INNER JOIN Nivel n ON n.id = c.id_nivel
    WHERE h.id_modulo = @id_modulo
      AND h.estado = 'activo'
      AND (SELECT COUNT(*) FROM Inscripcion i WHERE i.id_horario = h.id AND i.estado = 'activo') >= 4;

    -- Horarios con 16+ alumnos: añadir segundo slot (segundo grupo de 8)
    INSERT INTO #Slots (id_horario, id_curso, nivel_orden, inscritos, cupo_grupo, num_grupo, orden_prioridad)
    SELECT id_horario, id_curso, nivel_orden, inscritos, 8, 2, orden_prioridad
    FROM #Slots
    WHERE cupo_grupo = 8 AND num_grupo = 1;

    -- Orden para prioridad: primero por nivel (Alto=3 primero), luego por inscritos (más alumnos primero)
    ;WITH Ord AS (
        SELECT *,
               ROW_NUMBER() OVER (ORDER BY nivel_orden DESC, inscritos DESC, id_horario, num_grupo) AS rn
        FROM #Slots
    )
    UPDATE Ord SET orden_prioridad = rn;

    -- Si hay más de 12 slots, quedarnos solo con los 12 de mayor prioridad
    DELETE FROM #Slots
    WHERE orden_prioridad > @MaxAulas;

    -- Asignar número de aula (1..12) por orden
    ;WITH AulaAsig AS (
        SELECT *, ROW_NUMBER() OVER (ORDER BY orden_prioridad) AS num_aula
        FROM #Slots
    )
    SELECT id_horario, id_curso, cupo_grupo, num_grupo, orden_prioridad, num_aula
    INTO #SlotsConAula
    FROM AulaAsig;

    -- Obtener IDs de aulas (orden 1..12)
    DECLARE @Aulas TABLE (num INT, id_aula INT);
    INSERT INTO @Aulas (num, id_aula)
    SELECT ROW_NUMBER() OVER (ORDER BY id), id FROM Aula;

    -- Crear grupos e insertar en Grupo
    DECLARE @id_horario INT, @cupo_grupo INT, @num_grupo INT, @num_aula INT, @id_aula INT;
    DECLARE @id_grupo INT;
    DECLARE @nombre_grupo VARCHAR(50);
    DECLARE @id_profesor INT;
    DECLARE @Profesores TABLE (rn INT, id_profesor INT);
    INSERT INTO @Profesores (rn, id_profesor)
    SELECT ROW_NUMBER() OVER (ORDER BY id), id FROM Profesor;

    DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
        SELECT s.id_horario, s.cupo_grupo, s.num_grupo, s.num_aula
        FROM #SlotsConAula s
        ORDER BY s.orden_prioridad;

    OPEN cur;
    DECLARE @slot_num INT = 0;

    WHILE 1 = 1
    BEGIN
        FETCH NEXT FROM cur INTO @id_horario, @cupo_grupo, @num_grupo, @num_aula;
        IF @@FETCH_STATUS <> 0 BREAK;

        SELECT @id_aula = id_aula FROM @Aulas WHERE num = @num_aula;

        SET @nombre_grupo = (SELECT CONCAT(c.codigo, '-G', @num_grupo)
                             FROM Horario h JOIN Curso c ON c.id = h.id_curso
                             WHERE h.id = @id_horario);

        -- Profesor: asignar por orden (slot 1 -> profesor 1, etc.)
        SET @slot_num = @slot_num + 1;
        SELECT @id_profesor = id_profesor FROM @Profesores WHERE rn = @slot_num;

        INSERT INTO Grupo (id_horario, id_aula, id_profesor, nombre_grupo, cupo_maximo, estado)
        VALUES (@id_horario, @id_aula, @id_profesor, @nombre_grupo, @cupo_grupo,
                CASE WHEN @id_profesor IS NOT NULL THEN N'activo' ELSE N'cerrado' END);

        SET @id_grupo = SCOPE_IDENTITY();

        -- Asignar inscripciones a este grupo (por orden de fecha_inscripcion), hasta cupo_grupo
        ;WITH Inscritos AS (
            SELECT i.id, ROW_NUMBER() OVER (ORDER BY i.fecha_inscripcion) AS rn
            FROM Inscripcion i
            WHERE i.id_horario = @id_horario AND i.estado = 'activo' AND i.id_grupo IS NULL
        )
        UPDATE i
        SET id_grupo = @id_grupo
        FROM Inscripcion i
        INNER JOIN Inscritos ins ON ins.id = i.id
        WHERE ins.rn <= @cupo_grupo;
    END;

    CLOSE cur;
    DEALLOCATE cur;

    -- Cerrar horarios que no tuvieron grupos (inscritos < 4 o quedaron fuera por límite 12)
    UPDATE Horario
    SET estado = 'cerrado'
    WHERE id_modulo = @id_modulo
      AND id NOT IN (SELECT id_horario FROM #SlotsConAula)
      AND estado = 'activo';

    DROP TABLE #Slots;
    DROP TABLE #SlotsConAula;

    PRINT 'Asignación automática completada para el módulo.';
END;
GO

PRINT 'Procedimiento sp_AsignacionAutomatica creado.';
GO
