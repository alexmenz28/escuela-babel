-- ============================================================
-- Escuela de Idiomas Babel - Triggers (T-SQL)
-- Caso #8 - Validación cupo, profesor del grupo
-- (UNIQUE Alumno+Horario ya está en CONSTRAINT en Inscripcion)
-- ============================================================

USE BabelEscuelaIdiomas;
GO

-- ------------------------------------------------------------
-- TR_Inscripcion_Cupo: no superar cupo_maximo del grupo
-- Se dispara al INSERT o UPDATE cuando id_grupo está asignado.
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER TR_Inscripcion_Cupo ON Inscripcion
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE(id_grupo) AND NOT EXISTS (SELECT 1 FROM inserted WHERE id_grupo IS NOT NULL)
        RETURN;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Grupo g ON g.id = i.id_grupo
        WHERE i.estado = 'activo'
          AND (SELECT COUNT(*) FROM Inscripcion WHERE id_grupo = i.id_grupo AND estado = 'activo') > g.cupo_maximo
    )
    BEGIN
        RAISERROR('El grupo ha alcanzado su cupo máximo. No se puede inscribir más alumnos.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- ------------------------------------------------------------
-- TR_Nota_SoloProfesorDelGrupo: solo el profesor del grupo
-- puede registrar la nota.
-- ------------------------------------------------------------
CREATE OR ALTER TRIGGER TR_Nota_SoloProfesorDelGrupo ON Nota
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Grupo g ON g.id = i.id_grupo
        WHERE i.id_profesor <> g.id_profesor OR g.id_profesor IS NULL
    )
    BEGIN
        RAISERROR('Solo el profesor asignado al grupo puede registrar notas para ese grupo.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- Nota: La restricción UNIQUE(id_alumno, id_horario) en Inscripcion
-- ya evita inscripción duplicada por horario; no hace falta trigger adicional.

PRINT 'Triggers creados: TR_Inscripcion_Cupo, TR_Nota_SoloProfesorDelGrupo.';
GO
