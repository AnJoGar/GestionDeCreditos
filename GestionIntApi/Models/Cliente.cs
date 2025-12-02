namespace GestionIntApi.Models
{
    public class Cliente
    {
        public int Id { get; set; }
        // FK -> Usuario
        public int UsuarioId { get; set; }
        public Usuario Usuario { get; set; }
        // Relación con DetallCliente
        public int DetalleClienteID { get; set; }
        public DetalleCliente DetalleCliente { get; set; }
        // Relación con tienda
        public int TiendaId { get; set; }
        public Tienda Tienda { get; set; }

        // Relación uno a uno con crédito
        public Credito Credito { get; set; }
    }
}
