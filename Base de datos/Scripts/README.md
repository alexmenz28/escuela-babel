# Scripts T-SQL – Escuela de Idiomas Babel

Ejecutar en **SQL Server** (Management Studio o `sqlcmd`) en este orden:

| Orden | Archivo | Descripción |
|-------|---------|-------------|
| 1 | `01_DDL_CrearTablas.sql` | Crea la base de datos `BabelEscuelaIdiomas` y todas las tablas |
| 2 | `02_DatosIniciales.sql` | Inserta idiomas (3), niveles (3), cursos (9), aulas (12), roles (2) |
| 3 | `03_Triggers.sql` | Crea triggers de cupo y de profesor del grupo |
| 4 | `04_sp_AsignacionAutomatica.sql` | Crea el procedimiento de asignación automática |
| 5 | `05_DatosPrueba.sql` | Datos de prueba: 1 módulo, 9 horarios, 40 alumnos, 12 profesores, 40 inscripciones |

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
   ```

## Nota

- El DDL hace `DROP DATABASE` si existe; no ejecutar en producción sin respaldo.
- El usuario administrador se crea desde la aplicación (registro + hash de clave).
- **Script 05 (opcional):** inserta datos de prueba (módulo, horarios, alumnos, profesores, inscripciones). Tras ejecutarlo puede usar en la app «Organizar cursos» para el módulo «Módulo Prueba 2025-1» y probar reportes/notas.
- Para probar el SP manualmente: `EXEC sp_AsignacionAutomatica @id_modulo = 1;` (o el id del módulo de prueba).
