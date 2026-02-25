namespace Babel.EscuelaIdiomas.Data.Entities;

public class Modulo
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public DateOnly FechaInicio { get; set; }
    public DateOnly FechaFin { get; set; }
    public string Estado { get; set; } = string.Empty;

    public ICollection<Horario> Horarios { get; set; } = new List<Horario>();
}
