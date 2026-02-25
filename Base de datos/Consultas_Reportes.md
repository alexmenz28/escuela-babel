# Consultas complejas y reportes – Escuela de Idiomas Babel

**Caso #8 – PUDS – Modelo de diseño**

Consultas SQL (o vistas) para reportes y listados. Detalle de reportes en `Diseno/Diseno_Reportes.md`.

---

## Consultas por reporte

### 1. Lista de alumnos por curso (imprimir)

*(Incluir curso, horario, grupo, aula; listado de alumnos con nombre, documento, email.)*

```sql
-- Ejemplo: alumnos por curso/horario/grupo para un módulo
SELECT c.codigo AS curso, h.dia_semana, h.hora_inicio, g.nombre_grupo, a.nombre, a.apellidos, a.documento, a.email
FROM Inscripcion i
JOIN Grupo g ON i.id_grupo = g.id
JOIN Horario h ON g.id_horario = h.id
JOIN Curso c ON h.id_curso = c.id
JOIN Alumno a ON i.id_alumno = a.id
WHERE h.id_modulo = @id_modulo
  AND i.estado = 'activo'
ORDER BY c.codigo, h.dia_semana, g.nombre_grupo, a.apellidos;
```

### 2. Cantidad de alumnos por curso (reporte)

```sql
-- Conteo de inscritos por curso en un módulo
SELECT c.codigo, COUNT(i.id) AS cantidad_alumnos
FROM Curso c
LEFT JOIN Horario h ON h.id_curso = c.id AND h.id_modulo = @id_modulo
LEFT JOIN Inscripcion i ON i.id_horario = h.id AND i.estado = 'activo'
WHERE h.id IS NOT NULL
GROUP BY c.id, c.codigo
ORDER BY c.codigo;
```

### 3. Historial por estudiante (cursos y notas)

```sql
-- Cursos y notas de un alumno
SELECT c.codigo, m.nombre AS modulo, n.valor AS nota, n.fecha_registro
FROM Inscripcion i
JOIN Grupo g ON i.id_grupo = g.id
JOIN Horario h ON g.id_horario = h.id
JOIN Curso c ON h.id_curso = c.id
JOIN Modulo m ON h.id_modulo = m.id
LEFT JOIN Nota n ON n.id_alumno = i.id_alumno AND n.id_grupo = g.id
WHERE i.id_alumno = @id_alumno
ORDER BY m.fecha_inicio, c.codigo;
```

*(Ajustar nombres de columnas y parámetros al modelo real en `Modelo_Relacional.md`.)*

---

## Otras consultas complejas

- Inscripciones por horario con cupo disponible (para pantalla de inscripción).
- Grupos con profesor asignado vs sin asignar (para administración).
