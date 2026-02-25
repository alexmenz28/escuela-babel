namespace Babel.EscuelaIdiomas.Data.Entities;

public class Grupo
{
    public int Id { get; set; }
    public int IdHorario { get; set; }
    public int IdAula { get; set; }
    public int? IdProfesor { get; set; }
    public string NombreGrupo { get; set; } = string.Empty;
    public int CupoMaximo { get; set; }
    public string Estado { get; set; } = string.Empty;

    public Horario Horario { get; set; } = null!;
    public Aula Aula { get; set; } = null!;
    public Profesor? Profesor { get; set; }
    public ICollection<Inscripcion> Inscripciones { get; set; } = new List<Inscripcion>();
    public ICollection<Nota> Notas { get; set; } = new List<Nota>();
}
