# Diagramas de secuencia – Escuela de Idiomas Babel

Este documento recoge los diagramas de secuencia de los casos de uso principales del sistema, en código Mermaid.

---

## Índice de diagramas

1. [CU-01 – Inscribir alumno a curso](#cu-01--inscribir-alumno-a-curso)
2. [CU-02 – Ejecutar organización automática de cursos](#cu-02--ejecutar-organización-automática-de-cursos)
3. [CU-03 – Registrar notas](#cu-03--registrar-notas)
4. [CU-04 – Generar reportes académicos](#cu-04--generar-reportes-académicos)
5. [FA-01 – CU-01](#fa-01--cu-01)
6. [FA-02 – CU-01](#fa-02--cu-01)
7. [FA-03 – CU-02](#fa-03--cu-02)
8. [FA-04 – CU-02](#fa-04--cu-02)
9. [FA-05 – CU-02](#fa-05--cu-02)
10. [FA-06 – CU-02](#fa-06--cu-02)
11. [FA-07 – CU-03](#fa-07--cu-03)
12. [FA-08 – CU-03](#fa-08--cu-03)
13. [FA-09 – CU-04](#fa-09--cu-04)

---

## CU-01 – Inscribir alumno a curso

```mermaid
sequenceDiagram
    actor Usuario
    participant Web as Inscripciones.razor
    participant InscSvc as BabelDbContext
    participant DB as BabelEscuelaIdiomas (SQL Server)

    Usuario->>Web: Abrir pantalla "Inscripciones"
    Web->>DB: Obtener módulos, horarios, alumnos
    DB-->>Web: Datos
    Web-->>Usuario: Muestra formulario (módulo, horario, alumno)

    Usuario->>Web: Selecciona módulo, horario y alumno / Confirma
    Web->>InscSvc: Crear inscripción(alumnoId, idHorario, idModulo)

    InscSvc->>DB: Verificar alumno y horario válidos
    DB-->>InscSvc: OK
    InscSvc->>DB: Insertar Inscripción
    DB-->>InscSvc: Inscripción creada

    InscSvc-->>Web: Resultado OK
    Web-->>Usuario: Mensaje "Inscripción realizada"
```

---

## CU-02 – Ejecutar organización automática de cursos

```mermaid
sequenceDiagram
    actor Admin as Administrador
    participant Web as OrganizarCursos.razor
    participant DB as BabelEscuelaIdiomas (SQL Server)

    Admin->>Web: Abrir "Organizar cursos"
    Web->>DB: Obtener módulos
    DB-->>Web: Lista de módulos
    Web-->>Admin: Muestra selector de módulo y botón "Ejecutar asignación"

    Admin->>Web: Selecciona módulo y pulsa "Ejecutar asignación"
    Web->>DB: EXEC sp_AsignacionAutomatica(idModulo)

    Note over DB: SP crea grupos, asigna aulas (máx. 12),<br/>asigna profesores, reparte alumnos<br/>(≥16 → 2 grupos de 8, 4-15 → 1 grupo)

    DB-->>Web: Ejecución correcta
    Web-->>Admin: Mensaje "Asignación automática completada."
```

---

## CU-03 – Registrar notas

```mermaid
sequenceDiagram
    actor Profesor
    participant Web as MisGrupos.razor
    participant DB as BabelEscuelaIdiomas (SQL Server)

    Profesor->>Web: Abrir "Mis grupos"
    Web->>DB: Cargar grupos del profesor e inscripciones
    Web->>DB: Cargar notas ya registradas
    DB-->>Web: Grupos, alumnos, notas
    Web-->>Profesor: Lista de grupos con alumnos y notas

    Profesor->>Web: Pulsar "Editar" en nota de un alumno
    Web-->>Profesor: Muestra campo valor y "Guardar"

    Profesor->>Web: Ingresa valor y pulsa "Guardar"
    Web->>DB: Insertar o actualizar Nota(idAlumno, idGrupo, idProfesor, valor)
    DB-->>Web: OK
    Web->>DB: Recargar datos
    DB-->>Web: Datos actualizados
    Web-->>Profesor: Lista actualizada con la nueva nota
```

---

## CU-04 – Generar reportes académicos

```mermaid
sequenceDiagram
    actor Usuario
    participant Web as Reportes.razor
    participant DB as BabelEscuelaIdiomas (SQL Server)

    Usuario->>Web: Abrir "Reportes"
    Web->>DB: Obtener módulos
    DB-->>Web: Lista de módulos
    Web-->>Usuario: Selector de módulo

    Usuario->>Web: Selecciona módulo
    Web->>DB: Alumnos por curso (por módulo)
    Web->>DB: Alumnos del módulo (para historial)
    Web->>DB: Grupos con profesor y alumnos (listas por grupo)
    DB-->>Web: Datos de reportes
    Web-->>Usuario: Tabla "Alumnos por curso", selector alumno, listas por grupo

    Usuario->>Web: Selecciona alumno (opcional)
    Web->>DB: Historial del alumno (cursos, módulos, notas)
    DB-->>Web: Historial
    Web-->>Usuario: Tabla historial por estudiante

    Usuario->>Web: Pulsar "Imprimir listas"
    Web-->>Usuario: Ventana de impresión (listas por grupo con profesor)
```

---

## FA-01 – CU-01

*Alumno ya inscrito en ese horario: el sistema detecta la duplicidad y cancela el registro.*

```mermaid
sequenceDiagram
    actor Admin as Administrador
    participant Web as Inscripciones.razor
    participant DB as BabelEscuelaIdiomas (SQL Server)

    Admin->>Web: Selecciona módulo, horario y alumno / Confirma inscripción
    Web->>DB: Verificar si ya existe inscripción (alumno + horario + módulo)
    DB-->>Web: Ya existe inscripción

    Web-->>Admin: Mensaje: "No puede inscribirse dos veces en el mismo horario"
    Note over Web: No se registra nueva inscripción.<br/>Proceso finaliza.
```

---

## FA-02 – CU-01

*Curso o horario inactivo: el sistema no permite seleccionarlo.*

```mermaid
sequenceDiagram
    actor Admin as Administrador
    participant Web as Inscripciones.razor
    participant DB as BabelEscuelaIdiomas (SQL Server)

    Admin->>Web: Abrir "Inscripciones"
    Web->>DB: Obtener cursos y horarios (solo activos)
    DB-->>Web: Lista de cursos/horarios activos
    Web-->>Admin: Muestra solo opciones activas

    Note over Web: Si el curso/horario está inactivo<br/>no aparece en la lista o no es seleccionable.
    Admin->>Web: Intenta elegir curso/horario no disponible
    Web-->>Admin: No permite selección, debe elegir otro curso disponible
```

---

## FA-03 – CU-02

*No existen inscripciones en el módulo: el sistema informa y finaliza sin cambios.*

```mermaid
sequenceDiagram
    actor Admin as Administrador
    participant Web as OrganizarCursos.razor
    participant DB as BabelEscuelaIdiomas (SQL Server)

    Admin->>Web: Selecciona módulo y pulsa "Ejecutar asignación"
    Web->>DB: EXEC sp_AsignacionAutomatica(idModulo)
    DB->>DB: Verificar inscripciones en el módulo
    DB-->>Web: No hay inscripciones

    Web-->>Admin: Mensaje: "No hay cursos que organizar"
    Note over Web: Proceso finaliza sin realizar cambios.
```

---

## FA-04 – CU-02

*Más cursos activos que aulas: el sistema cierra cursos con menos alumnos hasta 12.*

```mermaid
sequenceDiagram
    actor Admin as Administrador
    participant Web as OrganizarCursos.razor
    participant DB as BabelEscuelaIdiomas (SQL Server)

    Admin->>Web: Ejecutar asignación (módulo)
    Web->>DB: EXEC sp_AsignacionAutomatica(idModulo)

    Note over DB: Sistema detecta más de 12 cursos activos<br/>que aulas disponibles (12)
    DB->>DB: Cerrar cursos con menor cantidad de alumnos
    DB->>DB: Repetir hasta que cursos activos = 12
    DB->>DB: Asignar aulas a los 12 cursos restantes
    DB-->>Web: OK
    Web-->>Admin: Resumen: cursos cancelados y aulas asignadas
```

---

## FA-05 – CU-02

*Más de 12 cursos con 16 alumnos: prioridad por nivel (Alto > Medio > Básico).*

```mermaid
sequenceDiagram
    actor Admin as Administrador
    participant Web as OrganizarCursos.razor
    participant DB as BabelEscuelaIdiomas (SQL Server)

    Admin->>Web: Ejecutar asignación (módulo)
    Web->>DB: EXEC sp_AsignacionAutomatica(idModulo)

    Note over DB: Más de 12 cursos con 16 alumnos.<br/>Aplicar prioridad: mantener nivel Alto.
    DB->>DB: Cerrar primero cursos nivel Básico
    DB->>DB: Cerrar luego cursos nivel Medio
    DB->>DB: Mantener hasta 12 cursos activos (prioridad Alto)
    DB-->>Web: OK
    Web-->>Admin: Resumen con cursos cerrados y asignaciones
```

---

## FA-06 – CU-02

*Más de 12 cursos con 16 alumnos y todos son nivel Alto: cierre al azar hasta 12.*

```mermaid
sequenceDiagram
    actor Admin as Administrador
    participant Web as OrganizarCursos.razor
    participant DB as BabelEscuelaIdiomas (SQL Server)

    Admin->>Web: Ejecutar asignación (módulo)
    Web->>DB: EXEC sp_AsignacionAutomatica(idModulo)

    Note over DB: Más de 12 cursos con 16 alumnos<br/>y todos de nivel Alto.
    DB->>DB: Cerrar cursos de manera aleatoria
    DB->>DB: Hasta quedar únicamente 12 cursos activos
    DB-->>Web: OK
    Web-->>Admin: Resumen con cursos cerrados y asignaciones
```

---

## FA-07 – CU-03

*Nota fuera del rango permitido: mensaje de error y no se guarda hasta corregir.*

```mermaid
sequenceDiagram
    actor Profesor
    participant Web as MisGrupos.razor
    participant DB as BabelEscuelaIdiomas (SQL Server)

    Profesor->>Web: Ingresa nota y pulsa "Guardar"
    Web->>Web: Validar rango (ej. 0–100)
    Note over Web: Nota fuera de rango

    Web-->>Profesor: Mensaje de error: "Rango válido: 0–100"
    Note over Web: No se guarda la nota.<br/>El profesor debe corregir el valor.
```

---

## FA-08 – CU-03

*El grupo no tiene alumnos registrados: mensaje informativo y finaliza.*

```mermaid
sequenceDiagram
    actor Profesor
    participant Web as MisGrupos.razor
    participant DB as BabelEscuelaIdiomas (SQL Server)

    Profesor->>Web: Abrir "Mis grupos" / Seleccionar grupo
    Web->>DB: Cargar inscripciones activas del grupo
    DB-->>Web: Lista vacía (sin alumnos)

    Web-->>Profesor: Mensaje: "No existen alumnos en el grupo"
    Note over Web: Proceso finaliza sin modificaciones.
```

---

## FA-09 – CU-04

*No hay datos para los parámetros del reporte: mensaje informativo y sin resultados.*

```mermaid
sequenceDiagram
    actor Admin as Administrador
    participant Web as Reportes.razor
    participant DB as BabelEscuelaIdiomas (SQL Server)

    Admin->>Web: Selecciona módulo (y/o tipo de reporte)
    Web->>DB: Consultar datos según parámetros (módulo, curso, etc.)
    DB-->>Web: Sin datos que coincidan

    Web-->>Admin: Mensaje: "No hay información disponible para el reporte solicitado"
    Note over Web: No se genera reporte.<br/>Proceso finaliza.
```
