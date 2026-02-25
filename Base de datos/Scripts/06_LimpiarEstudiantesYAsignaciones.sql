-- ============================================================
-- Escuela de Idiomas Babel - Limpiar estudiantes y asignaciones
-- Caso #8 - Deja catálogos, módulos, horarios y profesores intactos
-- ============================================================
-- Elimina: Nota, Inscripcion, Grupo, Alumno
-- Mantiene: Idioma, Nivel, Curso, Aula, Rol, Usuario, Modulo, Horario, Profesor
-- ============================================================

USE BabelEscuelaIdiomas;
GO

SET NOCOUNT ON;

-- Orden según dependencias (FK): Nota → Inscripcion → Grupo → Alumno

DELETE FROM Nota;
PRINT 'Notas eliminadas.';

DELETE FROM Inscripcion;
PRINT 'Inscripciones eliminadas.';

DELETE FROM Grupo;
PRINT 'Grupos eliminados.';

DELETE FROM Alumno;
PRINT 'Alumnos eliminados.';

DELETE FROM Horario;
PRINT 'Horarios eliminados.';

DELETE FROM Modulo;
PRINT 'Módulos eliminados.';

DELETE FROM Profesor;
PRINT 'Profesores eliminados.';

-- Reiniciar IDENTITY para que el próximo insert use id = 1
DBCC CHECKIDENT ('Nota',         RESEED, 0);
DBCC CHECKIDENT ('Inscripcion',  RESEED, 0);
DBCC CHECKIDENT ('Grupo',        RESEED, 0);
DBCC CHECKIDENT ('Alumno',       RESEED, 0);
DBCC CHECKIDENT ('Horario',      RESEED, 0);
DBCC CHECKIDENT ('Modulo',       RESEED, 0);
DBCC CHECKIDENT ('Profesor',     RESEED, 0);
PRINT 'Identidades reiniciadas (próximo id = 1 en cada tabla).';

PRINT 'Listo. Quedan intactos: idiomas, niveles, cursos, aulas, roles, usuarios.';
PRINT 'Puede volver a dar de alta alumnos, inscribirlos y ejecutar Organizar cursos.';
GO
