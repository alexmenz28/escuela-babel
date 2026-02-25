namespace Babel.EscuelaIdiomas.Data.Entities;

public class Horario
{
    public int Id { get; set; }
    public int IdCurso { get; set; }
    public int IdModulo { get; set; }
    public string DiaSemana { get; set; } = string.Empty;
    public TimeOnly HoraInicio { get; set; }
    public TimeOnly HoraFin { get; set; }
    public string Estado { get; set; } = string.Empty;

    public Curso Curso { get; set; } = null!;
    public Modulo Modulo { get; set; } = null!;
    public ICollection<Grupo> Grupos { get; set; } = new List<Grupo>();
    public ICollection<Inscripcion> Inscripciones { get; set; } = new List<Inscripcion>();
}
