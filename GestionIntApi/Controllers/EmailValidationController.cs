using GestionIntApi.Models;
using GestionIntApi.Repositorios.Implementacion;
using GestionIntApi.Repositorios.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc;
using System.IO;
using System.Net.Sockets;
using System.Threading.Tasks;

namespace GestionIntApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmailValidationController : ControllerBase
    {
        private readonly IEmailService _emailService;
        private readonly ICodigoVerificacionService _codigoService;

        public EmailValidationController(IEmailService emailService, ICodigoVerificacionService codigoService)
        {
            _emailService = emailService;
            _codigoService = codigoService;
        }

        [HttpPost("EnviarCodigo")]
        public async Task<IActionResult> EnviarCodigo([FromBody] string correo)
        {
            var codigo = new Random().Next(100000, 999999).ToString();

            _codigoService.GuardarCodigo(correo, codigo);

            await _emailService.SendEmailAsync(
                correo,
                "Código de verificación",
                $"<h3>Tu código es: <b>{codigo}</b></h3>"
            );

            return Ok(new { status = true, msg = "Código enviado" });
        }

        [HttpPost("ValidarCodigo")]
        public IActionResult ValidarCodigo([FromBody] VerificationCode req)
        {
            var valido = _codigoService.ValidarCodigo(req.Correo, req.Codigo);

            if (!valido)
                return BadRequest(new { status = false, msg = "Código incorrecto o expirado" });

            return Ok(new { status = true, msg = "Correo verificado correctamente" });
        }
    }

}
