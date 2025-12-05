namespace GestionIntApi.DTO
{
    public class TiendaDTO
    {


        public int Id { get; set; }
        public string NombreTienda { get; set; }
        public string NombreEncargado { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }

        public DateTime FechaRegistro { get; set; }

        public int ClienteId { get; set; }
    }
}
