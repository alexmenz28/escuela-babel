-- ============================================================
-- Escuela de Idiomas Babel - Datos iniciales (T-SQL)
-- Caso #8 - Idiomas, niveles, cursos, aulas, roles
-- ============================================================

USE BabelEscuelaIdiomas;
GO

-- ------------------------------------------------------------
-- Idiomas (3)
-- ------------------------------------------------------------
SET IDENTITY_INSERT Idioma ON;
INSERT INTO Idioma (id, nombre) VALUES
    (1, 'Inglés'),
    (2, 'Alemán'),
    (3, 'Francés');
SET IDENTITY_INSERT Idioma OFF;

-- ------------------------------------------------------------
-- Niveles (Básico=1, Medio=2, Alto=3; orden define prioridad)
-- ------------------------------------------------------------
SET IDENTITY_INSERT Nivel ON;
INSERT INTO Nivel (id, nombre, orden) VALUES
    (1, 'Básico', 1),
    (2, 'Medio',  2),
    (3, 'Alto',   3);
SET IDENTITY_INSERT Nivel OFF;

-- ------------------------------------------------------------
-- Cursos (9: I-B, I-M, I-A, A-B, A-M, A-A, F-B, F-M, F-A)
-- ------------------------------------------------------------
SET IDENTITY_INSERT Curso ON;
INSERT INTO Curso (id, codigo, id_idioma, id_nivel) VALUES
    (1, 'I-B', 1, 1), (2, 'I-M', 1, 2), (3, 'I-A', 1, 3),
    (4, 'A-B', 2, 1), (5, 'A-M', 2, 2), (6, 'A-A', 2, 3),
    (7, 'F-B', 3, 1), (8, 'F-M', 3, 2), (9, 'F-A', 3, 3);
SET IDENTITY_INSERT Curso OFF;

-- ------------------------------------------------------------
-- Aulas (12, capacidad 16 cada una)
-- ------------------------------------------------------------
SET IDENTITY_INSERT Aula ON;
INSERT INTO Aula (id, nombre, capacidad) VALUES
    (1, 'Aula 01', 16), (2, 'Aula 02', 16), (3, 'Aula 03', 16), (4, 'Aula 04', 16),
    (5, 'Aula 05', 16), (6, 'Aula 06', 16), (7, 'Aula 07', 16), (8, 'Aula 08', 16),
    (9, 'Aula 09', 16), (10, 'Aula 10', 16), (11, 'Aula 11', 16), (12, 'Aula 12', 16);
SET IDENTITY_INSERT Aula OFF;

-- ------------------------------------------------------------
-- Roles (Administrador, Profesor)
-- ------------------------------------------------------------
SET IDENTITY_INSERT Rol ON;
INSERT INTO Rol (id, nombre) VALUES
    (1, 'Administrador'),
    (2, 'Profesor');
SET IDENTITY_INSERT Rol OFF;

-- ------------------------------------------------------------
-- Usuario administrador inicial (cambiar clave en la aplicación)
-- clave_hash ejemplo: debe reemplazarse por hash real desde la app
-- ------------------------------------------------------------
-- INSERT INTO Usuario (nombre_usuario, clave_hash, id_rol, id_profesor, activo)
-- VALUES ('admin', N'<hash generado por la app>', 1, NULL, 1);
-- GO

PRINT 'Datos iniciales insertados: Idioma(3), Nivel(3), Curso(9), Aula(12), Rol(2).';
GO
