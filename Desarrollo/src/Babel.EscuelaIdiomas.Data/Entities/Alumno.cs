namespace Babel.EscuelaIdiomas.Data.Entities;

public class Alumno
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string Apellidos { get; set; } = string.Empty;
    public string? Documento { get; set; }
    public string? Email { get; set; }
    public DateTime FechaRegistro { get; set; }

    public ICollection<Inscripcion> Inscripciones { get; set; } = new List<Inscripcion>();
    public ICollection<Nota> Notas { get; set; } = new List<Nota>();
}
