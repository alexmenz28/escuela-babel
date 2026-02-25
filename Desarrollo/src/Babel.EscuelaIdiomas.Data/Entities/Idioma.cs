namespace Babel.EscuelaIdiomas.Data.Entities;

public class Idioma
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;

    public ICollection<Curso> Cursos { get; set; } = new List<Curso>();
}
