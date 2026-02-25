-- ============================================================
-- Escuela de Idiomas Babel - DDL (T-SQL)
-- Caso #8 - Creación de base de datos y tablas
-- ============================================================

USE master;
GO

IF DB_ID('BabelEscuelaIdiomas') IS NOT NULL
    DROP DATABASE BabelEscuelaIdiomas;
GO

CREATE DATABASE BabelEscuelaIdiomas;
GO

USE BabelEscuelaIdiomas;
GO

-- ------------------------------------------------------------
-- Catálogos (sin FK)
-- ------------------------------------------------------------

CREATE TABLE Idioma (
    id   INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Nivel (
    id    INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    orden  INT NOT NULL
);

CREATE TABLE Aula (
    id        INT IDENTITY(1,1) PRIMARY KEY,
    nombre    VARCHAR(100) NOT NULL,
    capacidad INT NOT NULL,
    CONSTRAINT CK_Aula_capacidad CHECK (capacidad = 16)
);

-- ------------------------------------------------------------
-- Curso (depende de Idioma, Nivel)
-- ------------------------------------------------------------

CREATE TABLE Curso (
    id         INT IDENTITY(1,1) PRIMARY KEY,
    codigo     VARCHAR(20) NOT NULL UNIQUE,
    id_idioma  INT NOT NULL,
    id_nivel   INT NOT NULL,
    CONSTRAINT FK_Curso_Idioma FOREIGN KEY (id_idioma) REFERENCES Idioma(id),
    CONSTRAINT FK_Curso_Nivel  FOREIGN KEY (id_nivel)  REFERENCES Nivel(id)
);

-- ------------------------------------------------------------
-- Personas
-- ------------------------------------------------------------

CREATE TABLE Alumno (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    apellidos      VARCHAR(100) NOT NULL,
    documento      VARCHAR(30)  NULL,
    email          VARCHAR(100) NULL,
    fecha_registro DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Profesor (
    id        INT IDENTITY(1,1) PRIMARY KEY,
    nombre    VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email     VARCHAR(100) NULL
);

-- ------------------------------------------------------------
-- Autenticación
-- ------------------------------------------------------------

CREATE TABLE Rol (
    id     INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Usuario (
    id            INT IDENTITY(1,1) PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    clave_hash    NVARCHAR(256) NOT NULL,
    id_rol        INT NOT NULL,
    id_profesor   INT NULL,
    activo        BIT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Usuario_Rol      FOREIGN KEY (id_rol)      REFERENCES Rol(id),
    CONSTRAINT FK_Usuario_Profesor FOREIGN KEY (id_profesor) REFERENCES Profesor(id)
);

-- ------------------------------------------------------------
-- Organización temporal
-- ------------------------------------------------------------

CREATE TABLE Modulo (
    id           INT IDENTITY(1,1) PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin    DATE NOT NULL,
    estado       VARCHAR(20) NOT NULL,
    CONSTRAINT CK_Modulo_estado CHECK (estado IN ('abierto', 'cerrado', 'en_curso'))
);

CREATE TABLE Horario (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    id_curso    INT NOT NULL,
    id_modulo   INT NOT NULL,
    dia_semana  VARCHAR(20) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin    TIME NOT NULL,
    estado      VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Horario_Curso  FOREIGN KEY (id_curso)  REFERENCES Curso(id),
    CONSTRAINT FK_Horario_Modulo FOREIGN KEY (id_modulo) REFERENCES Modulo(id),
    CONSTRAINT CK_Horario_estado CHECK (estado IN ('activo', 'cerrado', 'cancelado'))
);

-- ------------------------------------------------------------
-- Grupos (depende de Horario, Aula, Profesor opcional)
-- ------------------------------------------------------------

CREATE TABLE Grupo (
    id           INT IDENTITY(1,1) PRIMARY KEY,
    id_horario   INT NOT NULL,
    id_aula      INT NOT NULL,
    id_profesor  INT NULL,
    nombre_grupo VARCHAR(50) NOT NULL,
    cupo_maximo  INT NOT NULL,
    estado       VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Grupo_Horario  FOREIGN KEY (id_horario) REFERENCES Horario(id),
    CONSTRAINT FK_Grupo_Aula     FOREIGN KEY (id_aula)    REFERENCES Aula(id),
    CONSTRAINT FK_Grupo_Profesor FOREIGN KEY (id_profesor) REFERENCES Profesor(id),
    CONSTRAINT CK_Grupo_cupo    CHECK (cupo_maximo > 0 AND cupo_maximo <= 16),
    CONSTRAINT CK_Grupo_estado  CHECK (estado IN ('activo', 'cerrado'))
);

-- ------------------------------------------------------------
-- Inscripción (id_grupo NULL hasta asignación automática)
-- ------------------------------------------------------------

CREATE TABLE Inscripcion (
    id               INT IDENTITY(1,1) PRIMARY KEY,
    id_alumno        INT NOT NULL,
    id_horario       INT NOT NULL,
    id_grupo         INT NULL,
    fecha_inscripcion DATETIME2 NOT NULL DEFAULT GETDATE(),
    estado           VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Inscripcion_Alumno  FOREIGN KEY (id_alumno)  REFERENCES Alumno(id),
    CONSTRAINT FK_Inscripcion_Horario FOREIGN KEY (id_horario) REFERENCES Horario(id),
    CONSTRAINT FK_Inscripcion_Grupo   FOREIGN KEY (id_grupo)   REFERENCES Grupo(id),
    CONSTRAINT CK_Inscripcion_estado  CHECK (estado IN ('activo', 'cancelado')),
    -- Un alumno no se inscribe dos veces al mismo horario (RN)
    CONSTRAINT UQ_Inscripcion_AlumnoHorario UNIQUE (id_alumno, id_horario)
);

-- ------------------------------------------------------------
-- Nota (una por alumno por grupo)
-- ------------------------------------------------------------

CREATE TABLE Nota (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    id_alumno      INT NOT NULL,
    id_grupo       INT NOT NULL,
    id_profesor    INT NOT NULL,
    valor          DECIMAL(5,2) NOT NULL,
    fecha_registro DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Nota_Alumno   FOREIGN KEY (id_alumno)   REFERENCES Alumno(id),
    CONSTRAINT FK_Nota_Grupo    FOREIGN KEY (id_grupo)    REFERENCES Grupo(id),
    CONSTRAINT FK_Nota_Profesor FOREIGN KEY (id_profesor) REFERENCES Profesor(id),
    CONSTRAINT CK_Nota_valor   CHECK (valor >= 0 AND valor <= 100),
    CONSTRAINT UQ_Nota_AlumnoGrupo UNIQUE (id_alumno, id_grupo)
);

GO
