namespace GestionIntApi.DTO
{
    public class DetalleClienteDTO
    {
        public int Id { get; set; }

        public string NumeroCedula { get; set; }
        public string NombreApellidos { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }

        public string FotoClienteUrl { get; set; }

        public string FotoContrato { get; set; }
        public string FotoCelularEntregadoUrl { get; set; }
    }
}
