namespace GestionIntApi.DTO
{
    public class CrearClienteDTO
    {
        // Datos del cliente
        public string NumeroCedula { get; set; }
        public string NombreApellidos { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }

        public string? FotoClienteUrl { get; set; }
        public string? FotoCelularEntregadoUrl { get; set; }

        public int TiendaId { get; set; }

        // Datos del crédito
        public decimal Monto { get; set; }
        public int PlazoCuotas { get; set; }
        public string FrecuenciaPago { get; set; }
        public DateTime DiaPago { get; set; }


    }
}
