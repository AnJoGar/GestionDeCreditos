namespace GestionIntApi.Models
{
    public class Tienda
    {
        public int Id { get; set; }
        public string NombreTienda { get; set; }
        public string NombreEncargado { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }
        public string CodigoTienda { get; set; }
        public string? LogoUrl { get; set; }

        public DateTime FechaRegistro { get; set; } = DateTime.Now;

        public ICollection<Cliente> Clientes { get; set; }
    }
}
