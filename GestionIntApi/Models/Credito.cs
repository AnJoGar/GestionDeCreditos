namespace GestionIntApi.Models
{
    public class Credito
    {

        public int Id { get; set; }

        public decimal Monto { get; set; }
        public int PlazoCuotas { get; set; }
        public string FrecuenciaPago { get; set; } // semanal, quincenal, mensual
        public DateTime DiaPago { get; set; }

        public decimal ValorPorCuota { get; set; }
        public decimal TotalPagar { get; set; }
        public DateTime ProximaCuota { get; set; }

        // Relación con cliente
        // public int ClienteId { get; set; }
        // public Cliente Cliente { get; set; }

        public ICollection<Cliente> Clientes { get; set; }
    }
}
