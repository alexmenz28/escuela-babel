using Babel.EscuelaIdiomas.Web.Components;
using Babel.EscuelaIdiomas.Data;
using Babel.EscuelaIdiomas.Web.Services;
using Microsoft.EntityFrameworkCore;
using EFCore.NamingConventions;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

var conn = builder.Configuration.GetConnectionString("DefaultConnection")
    ?? "Server=(localdb)\\mssqllocaldb;Database=BabelEscuelaIdiomas;Trusted_Connection=True;TrustServerCertificate=True;";
builder.Services.AddDbContext<BabelDbContext>(options =>
    options.UseSqlServer(conn).UseSnakeCaseNamingConvention());

builder.Services.AddSingleton<AuthService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}
app.UseStatusCodePagesWithReExecute("/not-found", createScopeForStatusCodePages: true);
app.UseHttpsRedirection();

app.UseAntiforgery();

// Crear usuario admin si no existe (clave: admin123)
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<BabelDbContext>();
    if (!db.Usuarios.Any())
    {
        db.Usuarios.Add(new Babel.EscuelaIdiomas.Data.Entities.Usuario
        {
            NombreUsuario = "admin",
            ClaveHash = Babel.EscuelaIdiomas.Web.Services.PasswordHelper.Hash("admin123"),
            IdRol = 1,
            Activo = true,
            FechaCreacion = DateTime.UtcNow
        });
        db.SaveChanges();
    }
}

app.MapStaticAssets();
app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();
