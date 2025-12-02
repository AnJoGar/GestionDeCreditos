namespace GestionIntApi.DTO
{
    public class ClienteDTO
    {
        public int Id { get; set; }

        public string NumeroCedula { get; set; }
        public string NombreApellidos { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }

        public string? FotoClienteUrl { get; set; }
        public string? FotoCelularEntregadoUrl { get; set; }

        public string NombreTienda { get; set; }
        public string CodigoTienda { get; set; }

        public CreditoDTO Credito { get; set; }
    }
}
