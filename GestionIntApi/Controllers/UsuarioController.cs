using AutoMapper;
using AutoMapper;
using GestionIntApi.DTO;
using GestionIntApi.DTO;
using GestionIntApi.Models;
using GestionIntApi.Repositorios.Contrato;
using GestionIntApi.Repositorios.Contrato;
using GestionIntApi.Repositorios.Implementacion;
using GestionIntApi.Repositorios.Implementacion;
using GestionIntApi.Repositorios.Interfaces;
using GestionIntApi.Repositorios.Interfaces;
using GestionIntApi.Utilidades;
using GestionIntApi.Utilidades;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc;



namespace GestionIntApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsuarioController : ControllerBase
    {
        private readonly IUsuarioRepository _UsuarioServicios;
        private readonly ICodigoVerificacionService _codigoService;
        private readonly IEmailService _emailService;
        private readonly IRegistroTemporalService _registroTemporal;

        public UsuarioController(IUsuarioRepository usuarioServicios, ICodigoVerificacionService codigoService, IEmailService emailService, IRegistroTemporalService registroTemporal)
        {
            _UsuarioServicios = usuarioServicios;
            _codigoService = codigoService;
            _emailService = emailService;
            _registroTemporal = registroTemporal;
        }

        [HttpPost]
        [Route("IniciarSesion")]
        public async Task<IActionResult> IniciarSesion([FromBody] LoginDTO login)
        {
            var rsp = new Response<SesionDTO>();
            try
            {
                rsp.status = true;
                rsp.value = await _UsuarioServicios.ValidarCredenciales(login.Correo, login.Clave);
            }
            catch (Exception ex)
            {
                rsp.status = false;
                rsp.msg = ex.Message;
            }
            return Ok(rsp);
        }

        [HttpGet]
        [Route("Lista")]
        public async Task<IActionResult> Lista()
        {
            var rsp = new Response<List<UsuarioDTO>>();
            try
            {
                rsp.status = true;
                rsp.value = await _UsuarioServicios.listaUsuarios();
            }
            catch (Exception ex)
            {
                rsp.status = false;
                rsp.msg = ex.Message;
            }
            return Ok(rsp);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<UsuarioDTO>> GetById(int id)
        {
            try
            {
                var odontologo = await _UsuarioServicios.obtenerPorIdUsuario(id);
                if (odontologo == null)
                    return NotFound();
                return Ok(odontologo);
            }
            catch
            {
                return StatusCode(500, "Error al obtener el Odontólogo por ID");
            }
        }

        [HttpPost]
        [Route("Guardar")]
        public async Task<IActionResult> Guardar([FromBody] UsuarioDTO usuario)
        {
            var rsp = new Response<UsuarioDTO>();
            try
            {
                var existe = await _UsuarioServicios.ExisteCorreo(usuario.Correo);
                if (existe)
                {
                    rsp.status = false;
                    rsp.msg = "El correo ya está registrado.";
                    return BadRequest(rsp);
                }

                //  var newUser = await _UsuarioServicios.crearUsuario(usuario);

                // 2. Generar Código
                var codigo = new Random().Next(100000, 999999).ToString();

                var datos = new RegistroTemporal
                {
                    Usuario = usuario,
                    Codigo = codigo
                };

                // 3. Guardar el código temporal asociado al correo del usuario
                //  _codigoService.GuardarCodigo(usuario.Correo, codigo);
                _registroTemporal.GuardarRegistro(usuario.Correo, datos);
                // 4. Enviar correo
                await _emailService.SendEmailAsync(
                    usuario.Correo,
                    "Código de verificación",
                    $"<h3>Tu código es: <b>{codigo}</b></h3>"
                );
                rsp.status = true;
                rsp.msg = "Código enviado. Verifique su correo.";
               // rsp.value = await _UsuarioServicios.crearUsuario(usuario);
            }
            catch (Exception ex)
            {
                rsp.status = false;
                rsp.msg = ex.Message;
            }
            return Ok(rsp);
        }

        [HttpPut]
        [Route("Editar")]
        public async Task<IActionResult> Editar([FromBody] UsuarioDTO Usuario)
        {
            var rsp = new Response<bool>();
            try
            {
                rsp.status = true;
                rsp.value = await _UsuarioServicios.editarUsuario(Usuario);
            }
            catch (Exception ex)
            {
                rsp.status = false;
                rsp.msg = ex.Message;
            }
            return Ok(rsp);
        }

        [HttpDelete]
        [Route("Eliminar/{id:int}")]
        public async Task<IActionResult> Eliminar(int id)
        {
            var rsp = new Response<bool>();
            try
            {
                rsp.status = true;
                rsp.value = await _UsuarioServicios.eliminarUsuario(id);
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
