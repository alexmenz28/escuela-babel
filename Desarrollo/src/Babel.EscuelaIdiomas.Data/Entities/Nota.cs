namespace Babel.EscuelaIdiomas.Data.Entities;

public class Nota
{
    public int Id { get; set; }
    public int IdAlumno { get; set; }
    public int IdGrupo { get; set; }
    public int IdProfesor { get; set; }
    public decimal Valor { get; set; }
    public DateTime FechaRegistro { get; set; }

    public Alumno Alumno { get; set; } = null!;
    public Grupo Grupo { get; set; } = null!;
    public Profesor Profesor { get; set; } = null!;
}
