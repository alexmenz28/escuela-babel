namespace Babel.EscuelaIdiomas.Data.Entities;

public class Curso
{
    public int Id { get; set; }
    public string Codigo { get; set; } = string.Empty;
    public int IdIdioma { get; set; }
    public int IdNivel { get; set; }

    public Idioma Idioma { get; set; } = null!;
    public Nivel Nivel { get; set; } = null!;
    public ICollection<Horario> Horarios { get; set; } = new List<Horario>();
}
