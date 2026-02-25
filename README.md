# Escuela de Idiomas Babel – Caso #8 (UTEPSA)

Sistema administrativo para la Escuela de Idiomas Babel: gestión de cursos, inscripciones, asignación automática de grupos y reportes académicos.

## Contenido del repositorio

| Carpeta | Descripción |
|---------|-------------|
| **Desarrollo** | Aplicación web Blazor Server + EF Core (.NET 10). Ver [Desarrollo/README.md](Desarrollo/README.md) para arquitectura, stack, ejecución y uso. |
| **Base de datos** | Scripts T-SQL (DDL, datos iniciales, triggers, SP de asignación, datos de prueba) y documentación del modelo. |

## Ejecución rápida

1. Ejecutar los scripts en **Base de datos/Scripts/** en orden (01 → 05; el 05 es opcional para datos de prueba). Opcional: **06** para vaciar alumnos/asignaciones y reiniciar IDs.
2. En **Desarrollo**: `dotnet run --project src/Babel.EscuelaIdiomas.Web` (desde la carpeta `Desarrollo`).
3. Entrar con **admin** / **admin123**.

Proyecto académico – UTEPSA.
