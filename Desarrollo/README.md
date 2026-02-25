# Escuela de Idiomas Babel – Desarrollo

Sistema administrativo para la gestión de cursos, inscripciones, asignación automática de grupos y reportes académicos. Proyecto correspondiente al **Caso #8** (examen UTEPSA, metodología PUDS).

---

## Descripción

Aplicación web que permite:

- Gestionar **módulos** (periodos lectivos), **horarios**, **profesores** y **alumnos**.
- **Inscribir** alumnos a horarios por módulo (sin duplicar por horario).
- **Organizar cursos** mediante un procedimiento almacenado que crea grupos, asigna aulas (máx. 12) y profesores, y reparte alumnos (≥16 → 2 grupos de 8; 4–15 → 1 grupo de 16).
- **Reportes**: alumnos por curso, historial por estudiante, lista de alumnos por grupo (imprimible).
- **Rol profesor**: ver grupos asignados y cargar **notas** por alumno.

---

## Arquitectura

Arquitectura en dos capas: presentación (Blazor Server) y acceso a datos (EF Core + SQL Server).

```
┌─────────────────────────────────────────────────────────────┐
│                    Babel.EscuelaIdiomas.Web                  │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────────────┐ │
│  │   Blazor    │  │   Servicios   │  │   Componentes       │ │
│  │   Server    │  │  AuthService  │  │   Pages / Layout     │ │
│  │ (Razor)     │  │ PasswordHelper│  │   (Razor)            │ │
│  └─────────────┘  └──────────────┘  └─────────────────────┘ │
└────────────────────────────┬────────────────────────────────┘
                             │ DbContext
┌────────────────────────────▼────────────────────────────────┐
│                 Babel.EscuelaIdiomas.Data                    │
│  ┌─────────────────────┐  ┌──────────────────────────────┐  │
│  │  BabelDbContext     │  │  Entidades (Idioma, Curso,     │  │
│  │  EF Core + SQL      │  │  Horario, Grupo, Inscripcion,  │  │
│  │  snake_case columns │  │  Alumno, Profesor, Nota, …)    │  │
│  └─────────────────────┘  └──────────────────────────────┘  │
└────────────────────────────┬────────────────────────────────┘
                             │ T-SQL
┌────────────────────────────▼────────────────────────────────┐
│                   SQL Server                                 │
│  BabelEscuelaIdiomas – Tablas, triggers, sp_AsignacionAutomatica │
└─────────────────────────────────────────────────────────────┘
```

- **Web**: interfaz Blazor Server (InteractiveServer), rutas por rol (Administrador / Profesor), layout con menú lateral.
- **Data**: entidades y `BabelDbContext` con convención **snake_case** para columnas (EFCore.NamingConventions), alineado con el DDL de la base de datos.
- **Base de datos**: scripts en `../Base de datos/Scripts/` (DDL, datos iniciales, triggers, SP de asignación, datos de prueba).

---

## Stack tecnológico

| Área           | Tecnología |
|----------------|------------|
| Runtime        | .NET 10    |
| Frontend / UI  | Blazor Server (Razor Components) |
| ORM            | Entity Framework Core 10 |
| Base de datos  | SQL Server (LocalDB o instancia) |
| Convención BD  | EFCore.NamingConventions (snake_case) |
| Estilos        | Bootstrap 5 (incluido en plantilla) |
| Autenticación  | Sesión in-app (AuthService singleton, hash de contraseña) |

---

## Estructura del proyecto

```
Desarrollo/
├── src/
│   ├── Babel.EscuelaIdiomas.Data/           # Capa de datos
│   │   ├── Entities/                        # Entidades EF
│   │   │   ├── Alumno.cs
│   │   │   ├── Aula.cs
│   │   │   ├── Curso.cs
│   │   │   ├── Grupo.cs
│   │   │   ├── Horario.cs
│   │   │   ├── Idioma.cs
│   │   │   ├── Inscripcion.cs
│   │   │   ├── Modulo.cs
│   │   │   ├── Nivel.cs
│   │   │   ├── Nota.cs
│   │   │   ├── Profesor.cs
│   │   │   ├── Rol.cs
│   │   │   └── Usuario.cs
│   │   └── BabelDbContext.cs
│   │
│   └── Babel.EscuelaIdiomas.Web/           # Aplicación web
│       ├── Components/
│       │   ├── Layout/
│       │   │   ├── MainLayout.razor
│       │   │   ├── LoginLayout.razor
│       │   │   └── NavMenu.razor
│       │   ├── Pages/
│       │   │   ├── Home.razor
│       │   │   ├── Login.razor
│       │   │   ├── Modulos.razor
│       │   │   ├── Horarios.razor
│       │   │   ├── Profesores.razor
│       │   │   ├── Alumnos.razor
│       │   │   ├── Inscripciones.razor
│       │   │   ├── OrganizarCursos.razor
│       │   │   ├── Reportes.razor
│       │   │   └── MisGrupos.razor          # Profesor: grupos y notas
│       │   ├── App.razor
│       │   ├── Routes.razor
│       │   └── _Imports.razor
│       ├── Services/
│       │   ├── AuthService.cs
│       │   └── PasswordHelper.cs
│       ├── wwwroot/
│       │   ├── app.css
│       │   └── ...
│       ├── Program.cs
│       ├── appsettings.json
│       └── Babel.EscuelaIdiomas.Web.csproj
│
└── README.md
```

---

## Requisitos

- **.NET 10 SDK**
- **SQL Server** (LocalDB, Express o instancia completa)
- Ejecutar los scripts de la carpeta **`../Base de datos/Scripts/`** en orden (**01 → 05**) para crear la base de datos, tablas, datos iniciales, triggers, SP y (opcional) datos de prueba.

---

## Base de datos

Los scripts se ejecutan en este orden:

| Orden | Script | Descripción |
|-------|--------|-------------|
| 1 | `01_DDL_CrearTablas.sql` | Crea BD y tablas |
| 2 | `02_DatosIniciales.sql` | Idiomas, niveles, cursos, aulas, roles |
| 3 | `03_Triggers.sql` | Cupo por grupo, validación profesor en notas |
| 4 | `04_sp_AsignacionAutomatica.sql` | Asignación automática de grupos |
| 5 | `05_DatosPrueba.sql` | (Opcional) Módulo, horarios, alumnos, profesores, inscripciones de prueba |

Detalle y comandos `sqlcmd` en **`../Base de datos/Scripts/README.md`**.

---

## Configuración

En `src/Babel.EscuelaIdiomas.Web/appsettings.json` (o `appsettings.Development.json`) ajustar la conexión si no usas LocalDB:

```json
"ConnectionStrings": {
  "DefaultConnection": "Server=.;Database=BabelEscuelaIdiomas;Trusted_Connection=True;TrustServerCertificate=True;"
}
```

---

## Ejecución

### 1. Clonar el repositorio

```bash
git clone https://github.com/<tu-usuario>/<repositorio>.git
cd <repositorio>
```

### 2. Crear la base de datos

Ejecutar los scripts SQL en **Base de datos/Scripts/** en orden (01 → 05). Desde SQL Server Management Studio o con `sqlcmd`:

```bash
cd "Base de datos/Scripts"
sqlcmd -S localhost -d master -i 01_DDL_CrearTablas.sql
sqlcmd -S localhost -d BabelEscuelaIdiomas -i 02_DatosIniciales.sql
sqlcmd -S localhost -d BabelEscuelaIdiomas -i 03_Triggers.sql
sqlcmd -S localhost -d BabelEscuelaIdiomas -i 04_sp_AsignacionAutomatica.sql
sqlcmd -S localhost -d BabelEscuelaIdiomas -i 05_DatosPrueba.sql
```

(Ajustar `-S` si usas otra instancia; el script 05 es opcional para datos de prueba.)

### 3. Configurar la conexión (opcional)

Si no usas LocalDB, editar `Desarrollo/src/Babel.EscuelaIdiomas.Web/appsettings.json` y ajustar `ConnectionStrings:DefaultConnection`.

### 4. Ejecutar la aplicación

```bash
cd Desarrollo
dotnet run --project src/Babel.EscuelaIdiomas.Web
```

Abrir en el navegador la URL que indique la consola (por ejemplo `https://localhost:5001` o `http://localhost:5209`). Iniciar sesión con **admin** / **admin123**.

---

## Usuario por defecto

Tras la primera ejecución se crea un usuario administrador si no existe ninguno:

| Campo        | Valor      |
|-------------|------------|
| **Usuario** | `admin`    |
| **Contraseña** | `admin123` |

---

## Menú y funcionalidades

### Administrador

| Opción | Descripción |
|--------|-------------|
| **Home** | Inicio |
| **Módulos** | Crear y listar periodos lectivos (abierto / cerrado / en curso) |
| **Horarios** | Por módulo: crear horarios (curso, día, hora inicio/fin) |
| **Profesores** | Alta y listado; botón «Crear usuario» para rol Profesor |
| **Alumnos** | Alta y listado |
| **Inscribir alumno** | Módulo + alumno + horario (evita doble inscripción en el mismo horario) |
| **Organizar cursos** | Ejecuta `sp_AsignacionAutomatica` para el módulo elegido |
| **Reportes** | Alumnos por curso, historial por estudiante, lista por grupo (imprimible) |
| **Cerrar sesión** | Cierra la sesión |

### Profesor

- **Home**, **Mis grupos / Notas** (ver grupos asignados y cargar notas), **Cerrar sesión**.

---

## Flujo recomendado para probar

1. Iniciar sesión con **admin** / **admin123**.
2. **Módulos** – Crear un módulo (ej. «2025-1», fechas, estado «abierto»).
3. **Horarios** – Elegir ese módulo y crear horarios (curso, día, hora).
4. **Profesores** – Dar de alta al menos un profesor.
5. **Alumnos** – Dar de alta varios alumnos.
6. **Inscribir alumno** – Inscribir alumnos en horarios del módulo (mín. 4 por curso para que no se cierre; 16 para que se parta en dos grupos).
7. **Organizar cursos** – Elegir el módulo y ejecutar; se crean grupos, aulas y asignación de profesores.
8. **Reportes** – Ver alumnos por curso, historial por alumno y listas por grupo; **Imprimir listas** (el menú se oculta al imprimir).

Si ejecutaste **05_DatosPrueba.sql**, puedes usar el módulo «Módulo Prueba 2025-1» y ejecutar directamente **Organizar cursos** para probar reportes.

---

## Usuario profesor (pruebas)

1. En **Profesores** crear un profesor (ej. Juan Pérez).
2. En la fila del profesor, pulsar **Crear usuario**: nombre (ej. `jperez`) y contraseña (ej. `admin123`). Se crea un usuario con rol Profesor vinculado a ese profesor.
3. Cerrar sesión y entrar con ese usuario. Tras **Organizar cursos**, en **Mis grupos / Notas** podrá ver sus grupos y cargar notas.

---

## Casos de uso implementados

1. **Inscribir alumno a curso** – `/inscripciones` (módulo, alumno, horario; sin duplicar por horario).
2. **Organizar cursos** – `/organizar-cursos` – ejecuta `sp_AsignacionAutomatica`.
3. **Registrar notas** – `/mis-grupos` – el profesor ve sus grupos y carga/edita notas.
4. **Reportes** – `/reportes` – alumnos por curso, historial por estudiante, lista por grupo (imprimible).

---

## Licencia

Proyecto académico – UTEPSA.
