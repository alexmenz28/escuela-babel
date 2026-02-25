-- ============================================================
-- Escuela de Idiomas Babel - Datos de prueba (T-SQL)
-- Caso #8 - Ejecutar DESPUÉS de 01, 02, 03, 04
-- Inserta: 1 módulo, 9 horarios, N alumnos, M profesores, inscripciones
-- Organizar cursos se ejecuta desde la aplicación.
-- ============================================================
-- Modificar las variables siguientes para la cantidad deseada:
-- ============================================================

USE BabelEscuelaIdiomas;

DECLARE @cantidad_alumnos     INT  = 40;   -- Cambiar: total de estudiantes a insertar
DECLARE @cantidad_profesores   INT  = 12;   -- Cambiar: total de profesores (suficientes para grupos)
DECLARE @insertar_inscripciones BIT = 1;   -- 1 = sí insertar inscripciones, 0 = no (inscribir desde la app)

-- Solo insertar si no existe ya el módulo de prueba
IF NOT EXISTS (SELECT 1 FROM Modulo WHERE nombre = N'Módulo Prueba 2025-1')
BEGIN
    -- ------------------------------------------------------------
    -- 1. Módulo de prueba (abierto)
    -- ------------------------------------------------------------
    INSERT INTO Modulo (nombre, fecha_inicio, fecha_fin, estado)
    VALUES (N'Módulo Prueba 2025-1', DATEADD(day, 7, GETDATE()), DATEADD(month, 3, GETDATE()), N'abierto');

    DECLARE @id_modulo INT = SCOPE_IDENTITY();

    -- ------------------------------------------------------------
    -- 2. Horarios (uno por curso: Lunes a Viernes)
    -- ------------------------------------------------------------
    INSERT INTO Horario (id_curso, id_modulo, dia_semana, hora_inicio, hora_fin, estado)
    VALUES
        (1, @id_modulo, N'Lunes',     '08:00', '10:00', N'activo'),
        (2, @id_modulo, N'Lunes',     '10:30', '12:30', N'activo'),
        (3, @id_modulo, N'Martes',    '08:00', '10:00', N'activo'),
        (4, @id_modulo, N'Martes',    '10:30', '12:30', N'activo'),
        (5, @id_modulo, N'Miércoles', '08:00', '10:00', N'activo'),
        (6, @id_modulo, N'Miércoles', '10:30', '12:30', N'activo'),
        (7, @id_modulo, N'Jueves',    '08:00', '10:00', N'activo'),
        (8, @id_modulo, N'Jueves',    '10:30', '12:30', N'activo'),
        (9, @id_modulo, N'Viernes',   '08:00', '10:00', N'activo');

    -- ------------------------------------------------------------
    -- 3. Alumnos de prueba (cantidad = @cantidad_alumnos)
    -- ------------------------------------------------------------
    DECLARE @i INT = 1;
    WHILE @i <= @cantidad_alumnos
    BEGIN
        INSERT INTO Alumno (nombre, apellidos, documento, email, fecha_registro)
        VALUES (
            N'Alumno ' + CAST(@i AS NVARCHAR(10)),
            N'Apellido ' + CAST(@i AS NVARCHAR(10)),
            CAST(100 + @i AS VARCHAR(20)),
            N'alumno' + CAST(@i AS NVARCHAR(10)) + N'@test.com',
            GETDATE()
        );
        SET @i = @i + 1;
    END;

    -- ------------------------------------------------------------
    -- 4. Profesores (cantidad = @cantidad_profesores)
    -- ------------------------------------------------------------
    DECLARE @j INT = 1;
    WHILE @j <= @cantidad_profesores
    BEGIN
        INSERT INTO Profesor (nombre, apellidos, email)
        VALUES (
            N'Prof. ' + CAST(@j AS NVARCHAR(10)),
            N'Apellido',
            N'prof' + CAST(@j AS NVARCHAR(10)) + N'@babel.edu'
        );
        SET @j = @j + 1;
    END;

    -- ------------------------------------------------------------
    -- 5. Inscripciones (opcional): reparte alumnos en los primeros horarios
    --    (hasta 16 por horario). Si @insertar_inscripciones = 0, inscribir desde la app.
    -- ------------------------------------------------------------
    IF @insertar_inscripciones = 1
    BEGIN
        ;WITH HorariosOrdenados AS (
            SELECT id, id_curso, ROW_NUMBER() OVER (ORDER BY id_curso) AS rn
            FROM Horario
            WHERE id_modulo = @id_modulo
        ),
        AlumnosRecienInsertados AS (
            SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS rn
            FROM Alumno
            ORDER BY id DESC
            OFFSET 0 ROWS FETCH NEXT @cantidad_alumnos ROWS ONLY
        )
        INSERT INTO Inscripcion (id_alumno, id_horario, id_grupo, fecha_inscripcion, estado)
        SELECT a.id, h.id, NULL, GETDATE(), N'activo'
        FROM AlumnosRecienInsertados a
        INNER JOIN HorariosOrdenados h
            ON a.rn > (h.rn - 1) * 16
           AND a.rn <= h.rn * 16
           AND a.rn <= @cantidad_alumnos;
    END

    PRINT N'Datos de prueba insertados: 1 módulo, 9 horarios, ' + CAST(@cantidad_alumnos AS NVARCHAR(10)) + N' alumnos, ' + CAST(@cantidad_profesores AS NVARCHAR(10)) + N' profesores' + CASE WHEN @insertar_inscripciones = 1 THEN N', inscripciones repartidas en los horarios.' ELSE N'. Inscriba alumnos desde la aplicación.' END;
    PRINT N'Ejecute en la aplicación «Organizar cursos» para el módulo «Módulo Prueba 2025-1».';
END
ELSE
    PRINT N'El módulo de prueba ya existe. No se insertan datos duplicados.';
GO
