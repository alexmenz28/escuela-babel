namespace Babel.EscuelaIdiomas.Data.Entities;

public class Usuario
{
    public int Id { get; set; }
    public string NombreUsuario { get; set; } = string.Empty;
    public string ClaveHash { get; set; } = string.Empty;
    public int IdRol { get; set; }
    public int? IdProfesor { get; set; }
    public bool Activo { get; set; }
    public DateTime FechaCreacion { get; set; }

    public Rol Rol { get; set; } = null!;
    public Profesor? Profesor { get; set; }
}
