namespace Babel.EscuelaIdiomas.Data.Entities;

public class Nivel
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public int Orden { get; set; }

    public ICollection<Curso> Cursos { get; set; } = new List<Curso>();
}
