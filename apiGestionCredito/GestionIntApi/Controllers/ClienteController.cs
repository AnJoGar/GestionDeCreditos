using GestionIntApi.DTO;
using GestionIntApi.Repositorios.Interfaces;
using GestionIntApi.Utilidades;
using Microsoft.AspNetCore.Mvc;

namespace GestionIntApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ClienteController : Controller
    {

        private readonly IClienteService _ClienteServicios;
        private readonly ICodigoVerificacionService _codigoService;
        private readonly IEmailService _emailService;
        private readonly IRegistroTemporalService _registroTemporal;


        public ClienteController(IClienteService ClienteServicios)
        {
            _ClienteServicios = ClienteServicios;

        }

        [HttpPost("CrearDesdeAdmin")]
        public async Task<IActionResult> CrearDesdeAdmin([FromBody] ClienteDTO modelo)
        {
            var respuesta = await _ClienteServicios.CrearClienteDesdeAdmin(modelo);
            return Ok(respuesta);
        }

        [HttpGet]
        [Route("Lista")]
        public async Task<IActionResult> Lista()
        {
            var rsp = new Response<List<ClienteDTO>>();
            try
            {
                rsp.status = true;
                rsp.value = await _ClienteServicios.GetClientes();
            }
            catch (Exception ex)
            {
                rsp.status = false;
                rsp.msg = ex.Message;
            }
            return Ok(rsp);
        }

        [HttpGet]
        [Route("Reporte")]
        public async Task<IActionResult> Reporte(string? fechaInicio, string? fechaFin)
        {
            var rsp = new Response<List<ReporteDTO>>();
            try
            {
                rsp.status = true;
                rsp.value = await _ClienteServicios.Reporte(fechaInicio, fechaFin);
            }
            catch (Exception ex)
            {
                rsp.status = false;
                rsp.msg = ex.Message;
            }
            return Ok(rsp);
        }






    }
}
