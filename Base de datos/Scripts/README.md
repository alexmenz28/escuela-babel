# Scripts T-SQL – Escuela de Idiomas Babel

Ejecutar en **SQL Server** (Management Studio o `sqlcmd`) en este orden:

| Orden | Archivo | Descripción |
|-------|---------|-------------|
| 1 | `01_DDL_CrearTablas.sql` | Crea la base de datos `BabelEscuelaIdiomas` y todas las tablas |
| 2 | `02_DatosIniciales.sql` | Inserta idiomas (3), niveles (3), cursos (9), aulas (12), roles (2) |
| 3 | `03_Triggers.sql` | Crea triggers de cupo y de profesor del grupo |
| 4 | `04_sp_AsignacionAutomatica.sql` | Crea el procedimiento de asignación automática |
| 5 | `05_DatosPrueba.sql` | (Opcional) 1 módulo, 9 horarios; N alumnos y M profesores (variables al inicio); opción de insertar inscripciones |
| 6 | `06_LimpiarEstudiantesYAsignaciones.sql` | (Opcional) Vacía Nota, Inscripcion, Grupo, Alumno, Horario, Modulo, Profesor; reinicia IDENTITY; deja idiomas, niveles, cursos, aulas, roles, usuarios |

## Cómo ejecutar

1. Abrir **SQL Server Management Studio** y conectar al servidor.
2. Abrir cada archivo y ejecutar (F5) en el orden indicado.
3. O desde línea de comandos:
   ```bash
   sqlcmd -S localhost -d master -i 01_DDL_CrearTablas.sql
   sqlcmd -S localhost -d BabelEscuelaIdiomas -i 02_DatosIniciales.sql
   sqlcmd -S localhost -d BabelEscuelaIdiomas -i 03_Triggers.sql
   sqlcmd -S localhost -d BabelEscuelaIdiomas -i 04_sp_AsignacionAutomatica.sql
   sqlcmd -S localhost -d BabelEscuelaIdiomas -i 05_DatosPrueba.sql
   # Opcional, para vaciar y reiniciar IDs:
   sqlcmd -S localhost -d BabelEscuelaIdiomas -i 06_LimpiarEstudiantesYAsignaciones.sql
   ```

## Nota

- El DDL hace `DROP DATABASE` si existe; no ejecutar en producción sin respaldo.
- El usuario administrador se crea desde la aplicación (registro + hash de clave).
- **Script 05 (opcional):** al inicio del script se definen `@cantidad_alumnos`, `@cantidad_profesores` y `@insertar_inscripciones`; inserta 1 módulo, 9 horarios, N alumnos, M profesores y (opcional) inscripciones. Luego en la app: «Organizar cursos» para «Módulo Prueba 2025-1».
- Para probar el SP manualmente: `EXEC sp_AsignacionAutomatica @id_modulo = 1;` (o el id del módulo de prueba).
- **Script 06 (opcional):** vacía Nota, Inscripcion, Grupo, Alumno, Horario, Modulo, Profesor y reinicia los IDENTITY; deja intactos idiomas, niveles, cursos, aulas, roles y usuarios. Útil para probar de cero sin volver a ejecutar 01–04.
