namespace Babel.EscuelaIdiomas.Data.Entities;

public class Profesor
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string Apellidos { get; set; } = string.Empty;
    public string? Email { get; set; }

    public ICollection<Grupo> Grupos { get; set; } = new List<Grupo>();
    public ICollection<Nota> Notas { get; set; } = new List<Nota>();
    public ICollection<Usuario> Usuarios { get; set; } = new List<Usuario>();
}
