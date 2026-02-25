# Normalización – Escuela de Idiomas Babel

**Caso #8 – PUDS – Modelo de diseño**

---

## Objetivo

El modelo relacional está en **Tercera Forma Normal (3NF)** para evitar redundancia y anomalías de actualización, manteniendo cada hecho en un solo lugar.

---

## Primera Forma Normal (1NF)

- Todas las tablas tienen **clave primaria** (atributo o conjunto de atributos que identifica cada fila).
- No hay **grupos repetitivos**: cada celda contiene un valor atómico (no listas ni estructuras anidadas).

**Ejemplo:** En lugar de guardar "idiomas" como una lista en una sola columna, se tiene la tabla **Idioma** con una fila por idioma, y **Curso** referencia **id_idioma**. Cumple 1NF.

---

## Segunda Forma Normal (2NF)

- Se cumple 1NF.
- Todos los atributos no clave dependen de **toda** la clave primaria (no solo de parte de ella).

**Ejemplo:** En **Curso** la PK es `id`. Los atributos `codigo`, `id_idioma`, `id_nivel` dependen del curso completo. No hay claves compuestas con dependencias parciales. En **Inscripcion** la PK es `id`; `id_alumno`, `id_horario`, `id_grupo` dependen de la inscripción completa. En **Grupo** la PK es `id`; todos los atributos dependen del grupo. Cumple 2NF.

---

## Tercera Forma Normal (3NF)

- Se cumple 2NF.
- Ningún atributo no clave depende de **otro atributo no clave** (se eliminan dependencias transitivas).

**Ejemplo:** En **Curso** no guardamos el nombre del idioma ni del nivel; solo `id_idioma` e `id_nivel`. Los nombres están en **Idioma** y **Nivel**. Las tablas **Alumno**, **Profesor**, **Modulo**, **Horario**, **Nota** e **Inscripcion** guardan solo identificadores (FK) y atributos propios. **Grupo** tiene `id_aula` (FK) y `cupo_maximo`: este último no es una copia de `Aula.capacidad`, sino el límite *asignado a ese grupo* en el momento de la creación (8 o 16 según si el horario se partió en dos grupos o no); ver sección siguiente. Cumple 3NF.

---

## ¿Por qué «capacidad» (Aula) y «cupo_maximo» (Grupo)?

Son dos hechos distintos:

| Atributo | Tabla | Significado |
|----------|--------|-------------|
| **capacidad** | Aula | Capacidad *física* del aula (cuántos alumnos caben). Es una propiedad del recurso. En el caso, las 12 aulas tienen capacidad 16. |
| **cupo_maximo** | Grupo | Límite *operativo* de ese grupo concreto en esa asignación. Vale 16 si el horario tiene un solo grupo, o 8 si se partió en dos grupos (RN06). |

- **No es redundancia 3NF:** `cupo_maximo` no es “el valor de capacidad del aula”; es una decisión de negocio al crear el grupo (¿uno o dos grupos para este horario?). Depende del **grupo** y de la regla aplicada en el SP, no de leer solo la tabla Aula.
- **Ventaja de guardarlo en Grupo:** consultas y reglas (triggers, SP) pueden usar “este grupo acepta hasta cupo_maximo” sin recalcular a partir del horario y del aula. Si en el futuro una aula cambiara de capacidad, los grupos ya creados seguirían con su cupo_maximo histórico.
- **Alternativa estricta:** se podría eliminar `cupo_maximo` de Grupo y derivarlo cuando haga falta (según si el horario tiene 1 o 2 grupos y la capacidad del aula). En este modelo se prefiere almacenarlo para claridad y para no introducir dependencia transitiva Grupo → Aula → capacidad.

Con esta interpretación, el modelo **sigue cumpliendo las tres formas normales**.

---

## Resumen para el informe PUDS

| Forma normal | Criterio | Aplicación en el modelo |
|--------------|----------|--------------------------|
| **1NF** | Clave primaria; valores atómicos | Todas las tablas tienen PK; no hay grupos repetitivos. |
| **2NF** | Dependencia total de la clave | Atributos no clave dependen de la PK completa. |
| **3NF** | Sin dependencias transitivas | No se repiten datos de otras tablas; capacidad (Aula) y cupo_maximo (Grupo) son hechos distintos (físico vs límite del grupo). |

El modelo está en **3NF**, adecuado para procedimientos almacenados, triggers y consultas sobre SQL Server.
