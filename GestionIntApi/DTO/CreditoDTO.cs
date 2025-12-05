namespace GestionIntApi.DTO
{
    public class CreditoDTO
    {

        public int Id { get; set; }

        public decimal Monto { get; set; }
        public int PlazoCuotas { get; set; }
        public string FrecuenciaPago { get; set; }
        public DateTime DiaPago { get; set; }

        public decimal ValorPorCuota { get; set; }
        public decimal TotalPagar { get; set; }
        public DateTime ProximaCuota { get; set; }
        public string ProximaCuotaStr { get; set; }
        public string Estado { get; set; }

       // public DateTime FechaCreacion { get; set; }
        public int ClienteId { get; set; }
    }
}
