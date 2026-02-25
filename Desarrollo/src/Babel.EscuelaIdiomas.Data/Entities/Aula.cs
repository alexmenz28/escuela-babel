namespace Babel.EscuelaIdiomas.Data.Entities;

public class Aula
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public int Capacidad { get; set; }

    public ICollection<Grupo> Grupos { get; set; } = new List<Grupo>();
}
