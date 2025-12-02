namespace GestionIntApi.DTO
{
    public class CreditoDTO
    {

        public decimal Monto { get; set; }
        public int PlazoCuotas { get; set; }
        public string FrecuenciaPago { get; set; }
        public DateTime DiaPago { get; set; }

        public decimal ValorPorCuota { get; set; }
        public decimal TotalPagar { get; set; }
        public DateTime ProximaCuota { get; set; }
    }
}
