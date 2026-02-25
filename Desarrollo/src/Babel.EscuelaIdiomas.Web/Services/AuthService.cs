using Babel.EscuelaIdiomas.Data.Entities;

namespace Babel.EscuelaIdiomas.Web.Services;

public class AuthService
{
    public Usuario? CurrentUser { get; private set; }
    public string RolNombre => CurrentUser?.Rol?.Nombre ?? "";

    public bool IsAuthenticated => CurrentUser != null;
    public bool IsAdministrador => string.Equals(RolNombre, "Administrador", StringComparison.OrdinalIgnoreCase);
    public bool IsProfesor => string.Equals(RolNombre, "Profesor", StringComparison.OrdinalIgnoreCase);

    public void SignIn(Usuario user)
    {
        CurrentUser = user;
    }

    public void SignOut()
    {
        CurrentUser = null;
    }
}
