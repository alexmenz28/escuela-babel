# Triggers – Escuela de Idiomas Babel

**Caso #8 – PUDS – Modelo de diseño**

---

## Triggers propuestos

| Trigger | Tabla | Evento | Propósito |
|---------|-------|--------|-----------|
| TR_Nota_SoloProfesorDelGrupo | Nota | BEFORE INSERT (o INSTEAD OF) | Verificar que `id_profesor` de la fila insertada coincida con el `id_profesor` del Grupo indicado por `id_grupo`. Si no, rechazar inserción. |
| TR_Inscripcion_Cupo | Inscripcion | BEFORE INSERT | Verificar que el grupo no haya superado su `cupo_maximo` (contar inscripciones activas con ese id_grupo). Si está lleno, rechazar. |
| TR_Inscripcion_UnicaPorHorario | Inscripcion | BEFORE INSERT / UPDATE | Verificar UNIQUE(Alumno, Horario): que no exista otra inscripción del mismo id_alumno e id_horario. |

*(Implementar en T-SQL; las restricciones UNIQUE también pueden cubrirse con UNIQUE CONSTRAINT en la tabla.)*

---

## Notas

- La restricción UNIQUE(Alumno, Horario) puede ser un **UNIQUE CONSTRAINT** en lugar de trigger; el trigger añade un mensaje de error claro si se desea.
- Solo el profesor del grupo puede cargar notas: puede validarse en trigger (BD) o en la capa de aplicación.
