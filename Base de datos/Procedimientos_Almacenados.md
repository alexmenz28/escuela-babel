# Procedimientos almacenados – Escuela de Idiomas Babel

**Caso #8 – PUDS – Modelo de diseño**

---

## SP – Asignación automática

**Nombre sugerido:** `sp_AsignacionAutomatica` (o similar)  
**Parámetros:** `@id_modulo INT`  
**Descripción:** Ejecuta la asignación de alumnos a grupos y aulas un día antes del inicio del módulo.

### Pasos (pseudocódigo / algoritmo)

1. Obtener horarios del módulo con cantidad de inscritos (sin grupo asignado).
2. Para cada horario:
   - Si inscritos >= 16: crear 2 grupos (cupo_maximo = 8 cada uno); si no, crear 1 grupo (cupo_maximo = 16).
   - Asignar aula disponible a cada grupo (12 aulas).
3. Si hay más de 12 “slots” de grupo (horarios × cantidad de grupos), aplicar reglas de cierre:
   - Cerrar cursos con < 4 alumnos.
   - Si aún hay más de 12: prioridad por nivel (Alto > Medio > Básico); cerrar de menor prioridad.
   - Si todos son nivel Alto y aún > 12: cerrar al azar hasta 12.
4. Asignar profesores a grupos por orden (uno por grupo); grupos sin profesor → estado = 'cerrado'.
5. Asignar cada inscripción a un grupo (actualizar Inscripcion.id_grupo) respetando cupo_maximo.

*(Implementar en T-SQL según modelo en `Modelo_Relacional.md`.)*

---

## Otros procedimientos (opcional)

- Procedimientos para alta/baja de inscripciones, cierre de módulo, etc., si se definen en el diseño.
