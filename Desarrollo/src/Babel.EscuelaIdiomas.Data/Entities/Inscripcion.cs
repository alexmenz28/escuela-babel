namespace Babel.EscuelaIdiomas.Data.Entities;

public class Inscripcion
{
    public int Id { get; set; }
    public int IdAlumno { get; set; }
    public int IdHorario { get; set; }
    public int? IdGrupo { get; set; }
    public DateTime FechaInscripcion { get; set; }
    public string Estado { get; set; } = string.Empty;

    public Alumno Alumno { get; set; } = null!;
    public Horario Horario { get; set; } = null!;
    public Grupo? Grupo { get; set; }
}
