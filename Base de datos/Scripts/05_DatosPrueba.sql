-- ============================================================
-- Escuela de Idiomas Babel - Datos de prueba (T-SQL)
-- Caso #8 - Ejecutar DESPUÉS de 01, 02, 03, 04
-- Inserta: 1 módulo, 9 horarios, alumnos, profesores, inscripciones
-- ============================================================

USE BabelEscuelaIdiomas;
GO

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
    -- 2. Horarios (uno por curso: Lunes a Viernes 08:00-10:00)
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
    -- 3. Alumnos de prueba (40)
    -- ------------------------------------------------------------
    INSERT INTO Alumno (nombre, apellidos, documento, email, fecha_registro)
    VALUES
        (N'Ana', N'García López', N'111', N'ana@test.com', GETDATE()),
        (N'Bruno', N'Martínez Soto', N'112', N'bruno@test.com', GETDATE()),
        (N'Carmen', N'Rodríguez Paz', N'113', N'carmen@test.com', GETDATE()),
        (N'Diego', N'Fernández Río', N'114', N'diego@test.com', GETDATE()),
        (N'Elena', N'López Vega', N'115', N'elena@test.com', GETDATE()),
        (N'Francisco', N'Sánchez Mora', N'116', N'fran@test.com', GETDATE()),
        (N'Gabriela', N'Pérez Luna', N'117', N'gabriela@test.com', GETDATE()),
        (N'Héctor', N'González Sol', N'118', N'hector@test.com', GETDATE()),
        (N'Isabel', N'Díaz Cruz', N'119', N'isabel@test.com', GETDATE()),
        (N'Javier', N'Torres Nieve', N'120', N'javier@test.com', GETDATE()),
        (N'Laura', N'Ramírez Flor', N'121', N'laura@test.com', GETDATE()),
        (N'Miguel', N'Flores Campo', N'122', N'miguel@test.com', GETDATE()),
        (N'Nuria', N'Serrano Monte', N'123', N'nuria@test.com', GETDATE()),
        (N'Óscar', N'Ruiz Valle', N'124', N'oscar@test.com', GETDATE()),
        (N'Patricia', N'Hernández Costa', N'125', N'patricia@test.com', GETDATE()),
        (N'Quique', N'Jiménez Pino', N'126', N'quique@test.com', GETDATE()),
        (N'Rosa', N'Moreno Lago', N'127', N'rosa@test.com', GETDATE()),
        (N'Sergio', N'Álvarez Cielo', N'128', N'sergio@test.com', GETDATE()),
        (N'Teresa', N'Romero Isla', N'129', N'teresa@test.com', GETDATE()),
        (N'Ulises', N'Navarro Bosque', N'130', N'ulises@test.com', GETDATE()),
        (N'Valeria', N'Molina Río', N'131', N'valeria@test.com', GETDATE()),
        (N'Walter', N'Delgado Mar', N'132', N'walter@test.com', GETDATE()),
        (N'Ximena', N'Ortiz Sierra', N'133', N'ximena@test.com', GETDATE()),
        (N'Yago', N'Rubio Playa', N'134', N'yago@test.com', GETDATE()),
        (N'Zoe', N'Marín Ola', N'135', N'zoe@test.com', GETDATE()),
        (N'Antonio', N'Gil Nube', N'136', N'antonio@test.com', GETDATE()),
        (N'Beatriz', N'Vargas Viento', N'137', N'beatriz@test.com', GETDATE()),
        (N'Carlos', N'Castro Lluvia', N'138', N'carlos@test.com', GETDATE()),
        (N'Diana', N'Iglesias Arco', N'139', N'diana@test.com', GETDATE()),
        (N'Ernesto', N'Ortega Hoja', N'140', N'ernesto@test.com', GETDATE()),
        (N'Fátima', N'Santos Nido', N'141', N'fatima@test.com', GETDATE()),
        (N'Gerardo', N'Cortés Pan', N'142', N'gerardo@test.com', GETDATE()),
        (N'Hortensia', N'Guerrero Sal', N'143', N'hortensia@test.com', GETDATE()),
        (N'Iván', N'Prieto Miel', N'144', N'ivan@test.com', GETDATE()),
        (N'Julia', N'Méndez Trigo', N'145', N'julia@test.com', GETDATE()),
        (N'Kevin', N'Reyes Lana', N'146', N'kevin@test.com', GETDATE()),
        (N'Luciana', N'Aguilar Barro', N'147', N'luciana@test.com', GETDATE()),
        (N'Mateo', N'Cabrera Tiza', N'148', N'mateo@test.com', GETDATE()),
        (N'Nadia', N'Giménez Cera', N'149', N'nadia@test.com', GETDATE()),
        (N'Omar', N'Domínguez Cobre', N'150', N'omar@test.com', GETDATE());

    -- ------------------------------------------------------------
    -- 4. Profesores (12, para asignar a grupos)
    -- ------------------------------------------------------------
    INSERT INTO Profesor (nombre, apellidos, email)
    VALUES
        (N'Prof. Alicia', N'Vega', N'alicia.vega@babel.edu'),
        (N'Prof. Bernardo', N'Reyes', N'bernardo@babel.edu'),
        (N'Prof. Claudia', N'Núñez', N'claudia@babel.edu'),
        (N'Prof. Daniel', N'Medina', N'daniel@babel.edu'),
        (N'Prof. Estela', N'Caballero', N'estela@babel.edu'),
        (N'Prof. Felipe', N'Herrera', N'felipe@babel.edu'),
        (N'Prof. Gloria', N'Lara', N'gloria@babel.edu'),
        (N'Prof. Hugo', N'Silva', N'hugo@babel.edu'),
        (N'Prof. Inés', N'Maldonado', N'ines@babel.edu'),
        (N'Prof. Julio', N'Ríos', N'julio@babel.edu'),
        (N'Prof. Karina', N'Acosta', N'karina@babel.edu'),
        (N'Prof. Leonardo', N'Benítez', N'leonardo@babel.edu');

    -- ------------------------------------------------------------
    -- 5. Inscripciones: 16 en I-B (Lunes 08), 16 en I-M (Lunes 10), 8 en I-A (Martes 08)
    --    Así el SP creará 2+2+1 = 5 grupos y asignará profesores
    -- ------------------------------------------------------------
    ;WITH HorariosOrdenados AS (
        SELECT id, id_curso, ROW_NUMBER() OVER (ORDER BY id_curso) AS rn
        FROM Horario
        WHERE id_modulo = @id_modulo
    ),
    AlumnosOrdenados AS (
        SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS rn
        FROM Alumno
    )
    INSERT INTO Inscripcion (id_alumno, id_horario, id_grupo, fecha_inscripcion, estado)
    SELECT a.id, h.id, NULL, GETDATE(), N'activo'
    FROM AlumnosOrdenados a
    INNER JOIN HorariosOrdenados h ON (
        (h.rn = 1 AND a.rn <= 16) OR   -- I-B: 16 alumnos (se parte en 2 grupos)
        (h.rn = 2 AND a.rn > 16 AND a.rn <= 32) OR  -- I-M: 16 alumnos (se parte en 2 grupos)
        (h.rn = 3 AND a.rn > 32 AND a.rn <= 40)     -- I-A: 8 alumnos (1 grupo)
    );

    PRINT N'Datos de prueba insertados: 1 módulo, 9 horarios, 40 alumnos, 12 profesores, 40 inscripciones (I-B:16, I-M:16, I-A:8).';
    PRINT N'Puede ejecutar en la app «Organizar cursos» para el módulo «Módulo Prueba 2025-1».';
END
ELSE
    PRINT N'El módulo de prueba ya existe. No se insertan datos duplicados.';
GO
