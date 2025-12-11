using GestionIntApi.DTO;
using GestionIntApi.Models;
using GestionIntApi.Repositorios.Implementacion;
using GestionIntApi.Repositorios.Interfaces;
using GestionIntApi.Utilidades;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Win32;
using System.IO;
using System.Net.Sockets;
using System.Security.Cryptography;
using System.Threading.Tasks;

namespace GestionIntApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmailValidationController : ControllerBase
    {
        private readonly IEmailService _emailService;
        private readonly ICodigoVerificacionService _codigoService;
        private readonly IUsuarioRepository _UsuarioServicios;
        private readonly IRegistroTemporalService _registroTemporal;
        public EmailValidationController(IEmailService emailService, ICodigoVerificacionService codigoService, IUsuarioRepository usuarioServicios, IRegistroTemporalService iRegistroTemporalService)
        {
            _emailService = emailService;
            _codigoService = codigoService;
            _UsuarioServicios = usuarioServicios;
            _registroTemporal = iRegistroTemporalService;
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

      /*  [HttpPost("ValidarCodigo")]
        public async Task<IActionResult> ValidarCodigo([FromBody] VerificationCode req)
        {
            var valido = _codigoService.ValidarCodigo(req.Correo, req.Codigo);

            if (!valido)
                return BadRequest(new { status = false, msg = "Código incorrecto o expirado" });

            return Ok(new { status = true, msg = "Correo verificado correctamente" });



            // Guardar usuario en la base de datos
            var nuevoUsuario = await _UsuarioServicios.crearUsuario(req.Usuario);

            // Eliminar registro temporal
            _registroTemporal.EliminarRegistro(req.Correo);

            rsp.status = true;
            rsp.value = nuevoUsuario;
            rsp.msg = "Usuario registrado correctamente.";

            return Ok(rsp);
        }
      */
        [HttpPost("ValidarCodigo")]
        public async Task<IActionResult> ValidarCodigo([FromBody] VerificationCode req)
        {
            var rsp = new Response<UsuarioDTO>();

            var registro = _registroTemporal.ObtenerRegistro(req.Correo);

            if (registro == null || registro.Codigo != req.Codigo)
            {
                rsp.status = false;
                rsp.msg = "Código incorrecto o expirado.";
                return BadRequest(rsp);
            }

            // Guardar usuario en la base de datos
            var nuevoUsuario = await _UsuarioServicios.crearUsuario(registro.Usuario);

            // Eliminar registro temporal
            _registroTemporal.EliminarRegistro(req.Correo);

            rsp.status = true;
            rsp.value = nuevoUsuario;
            rsp.msg = "Usuario registrado correctamente.";

            return Ok(rsp);
        }
    }

}
