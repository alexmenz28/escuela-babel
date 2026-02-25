using Microsoft.EntityFrameworkCore;
using Babel.EscuelaIdiomas.Data.Entities;

namespace Babel.EscuelaIdiomas.Data;

public class BabelDbContext : DbContext
{
    public BabelDbContext(DbContextOptions<BabelDbContext> options) : base(options) { }

    public DbSet<Idioma> Idiomas => Set<Idioma>();
    public DbSet<Nivel> Niveles => Set<Nivel>();
    public DbSet<Curso> Cursos => Set<Curso>();
    public DbSet<Aula> Aulas => Set<Aula>();
    public DbSet<Alumno> Alumnos => Set<Alumno>();
    public DbSet<Profesor> Profesores => Set<Profesor>();
    public DbSet<Rol> Roles => Set<Rol>();
    public DbSet<Usuario> Usuarios => Set<Usuario>();
    public DbSet<Modulo> Modulos => Set<Modulo>();
    public DbSet<Horario> Horarios => Set<Horario>();
    public DbSet<Grupo> Grupos => Set<Grupo>();
    public DbSet<Inscripcion> Inscripciones => Set<Inscripcion>();
    public DbSet<Nota> Notas => Set<Nota>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Nombres de tabla exactos como en el DDL (PascalCase), para que coincidan con la BD
        modelBuilder.Entity<Idioma>().ToTable("Idioma");
        modelBuilder.Entity<Nivel>().ToTable("Nivel");
        modelBuilder.Entity<Curso>().ToTable("Curso");
        modelBuilder.Entity<Aula>().ToTable("Aula");
        modelBuilder.Entity<Alumno>().ToTable("Alumno");
        modelBuilder.Entity<Profesor>().ToTable("Profesor");
        modelBuilder.Entity<Rol>().ToTable("Rol");
        modelBuilder.Entity<Usuario>().ToTable("Usuario");
        modelBuilder.Entity<Modulo>().ToTable("Modulo");
        modelBuilder.Entity<Horario>().ToTable("Horario");
        modelBuilder.Entity<Grupo>().ToTable("Grupo");
        modelBuilder.Entity<Inscripcion>().ToTable("Inscripcion");
        modelBuilder.Entity<Nota>().ToTable("Nota");

        modelBuilder.Entity<Curso>(e =>
        {
            e.HasOne(c => c.Idioma).WithMany(i => i.Cursos).HasForeignKey(c => c.IdIdioma);
            e.HasOne(c => c.Nivel).WithMany(n => n.Cursos).HasForeignKey(c => c.IdNivel);
        });

        modelBuilder.Entity<Usuario>(e =>
        {
            e.HasOne(u => u.Rol).WithMany(r => r.Usuarios).HasForeignKey(u => u.IdRol);
            e.HasOne(u => u.Profesor).WithMany(p => p.Usuarios).HasForeignKey(u => u.IdProfesor);
        });

        modelBuilder.Entity<Horario>(e =>
        {
            e.HasOne(h => h.Curso).WithMany(c => c.Horarios).HasForeignKey(h => h.IdCurso);
            e.HasOne(h => h.Modulo).WithMany(m => m.Horarios).HasForeignKey(h => h.IdModulo);
        });

        modelBuilder.Entity<Grupo>(e =>
        {
            e.HasOne(g => g.Horario).WithMany(h => h.Grupos).HasForeignKey(g => g.IdHorario);
            e.HasOne(g => g.Aula).WithMany(a => a.Grupos).HasForeignKey(g => g.IdAula);
            e.HasOne(g => g.Profesor).WithMany(p => p.Grupos).HasForeignKey(g => g.IdProfesor);
        });

        modelBuilder.Entity<Inscripcion>(e =>
        {
            e.HasOne(i => i.Alumno).WithMany(a => a.Inscripciones).HasForeignKey(i => i.IdAlumno);
            e.HasOne(i => i.Horario).WithMany(h => h.Inscripciones).HasForeignKey(i => i.IdHorario);
            e.HasOne(i => i.Grupo).WithMany(g => g.Inscripciones).HasForeignKey(i => i.IdGrupo);
        });

        modelBuilder.Entity<Nota>(e =>
        {
            e.Property(n => n.Valor).HasPrecision(5, 2);
            e.HasOne(n => n.Alumno).WithMany(a => a.Notas).HasForeignKey(n => n.IdAlumno);
            e.HasOne(n => n.Grupo).WithMany(g => g.Notas).HasForeignKey(n => n.IdGrupo);
            e.HasOne(n => n.Profesor).WithMany(p => p.Notas).HasForeignKey(n => n.IdProfesor);
        });
    }
}
