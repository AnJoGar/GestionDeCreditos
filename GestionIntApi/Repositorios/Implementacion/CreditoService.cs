using AutoMapper;
using GestionIntApi.DTO;
using GestionIntApi.Models;
using GestionIntApi.Repositorios.Contrato;
using GestionIntApi.Repositorios.Interfaces;
namespace GestionIntApi.Repositorios.Implementacion
{
    public class CreditoService: ICreditoService
    {


        private readonly IGenericRepository<Credito> _creditoRepository;

        private readonly IMapper _mapper;
        private readonly SistemaGestionDBcontext _context;


        public CreditoService(IGenericRepository<Credito> creditoRepository, IMapper mapper, SistemaGestionDBcontext context)
        {

            _creditoRepository = creditoRepository;
            _mapper = mapper;
            _context = context;


        }



        public async Task<List<CreditoDTO>> GetAllTiendas()
        {
            try
            {
                var queryCredito = await _creditoRepository.Consultar();

                var CreditoCliente = queryCredito.ToList();
                // Recorremos la lista de usuarios y reemplazamos el hash de la contraseña por el texto plano
                return _mapper.Map<List<CreditoDTO>>(CreditoCliente);
            }
            catch
            {

                throw;
            }



        }
        public async Task<CreditoDTO> GetTiendaById(int id)
        {
            try
            {
                var creditoEncontrado = await _creditoRepository.Obtenerid(u => u.Id == id);


                if (creditoEncontrado == null)
                    throw new TaskCanceledException("Credito de cliente no encontrado");
                return _mapper.Map<CreditoDTO>(creditoEncontrado);
            }
            catch
            {
                throw;
            }
        }



        public async Task<CreditoDTO> CreateCredito(CreditoDTO modelo)
        {
            try
            {
                // Cálculo del TotalPagar (sin intereses)
                modelo.TotalPagar = modelo.Monto;

                // Cálculo de ValorPorCuota
                modelo.ValorPorCuota = modelo.TotalPagar / modelo.PlazoCuotas;

                // Cálculo de PróximaCuota según frecuencia
                modelo.ProximaCuota = modelo.FrecuenciaPago.ToLower() switch
                {
                    "semanal" => modelo.DiaPago.AddDays(7),
                    "quincenal" => modelo.DiaPago.AddDays(15),
                    "mensual" => modelo.DiaPago.AddMonths(1),
                    _ => modelo.DiaPago
                };




                var UsuarioCreado = await _creditoRepository.Crear(_mapper.Map<Credito>(modelo));

                if (UsuarioCreado.Id == 0)
                    throw new TaskCanceledException("No se pudo crear la tienda");

                return _mapper.Map<CreditoDTO>(UsuarioCreado);
            }
            catch
            {
                throw;
            }
        }

        public async Task<bool> UpdateCredito(CreditoDTO modelo)
        {
            try
            {


                var TiendaModelo = _mapper.Map<CreditoDTO>(modelo);

                var TiendaEncontrado = await _creditoRepository.Obtener(u => u.Id == TiendaModelo.Id);
                if (TiendaEncontrado == null)
                    throw new TaskCanceledException("El credito no existe");

                // Recalcular todo antes de actualizar
                modelo.TotalPagar = modelo.Monto;
                modelo.ValorPorCuota = modelo.TotalPagar / modelo.PlazoCuotas;

                modelo.ProximaCuota = modelo.FrecuenciaPago.ToLower() switch
                {
                    "semanal" => modelo.DiaPago.AddDays(7),
                    "quincenal" => modelo.DiaPago.AddDays(15),
                    "mensual" => modelo.DiaPago.AddMonths(1),
                    _ => modelo.DiaPago
                };

                TiendaEncontrado.Monto = TiendaModelo.Monto;
                TiendaEncontrado.PlazoCuotas = TiendaModelo.PlazoCuotas;
                TiendaEncontrado.FrecuenciaPago = TiendaModelo.FrecuenciaPago;
                TiendaEncontrado.DiaPago = TiendaModelo.DiaPago;
                TiendaEncontrado.ValorPorCuota = TiendaModelo.ValorPorCuota;
                TiendaEncontrado.TotalPagar = TiendaModelo.TotalPagar;
                TiendaEncontrado.ProximaCuota = TiendaModelo.ProximaCuota;

                bool respuesta = await _creditoRepository.Editar(TiendaEncontrado);
                return respuesta;
            }
            catch
            {
                throw;
            }
        }

        public async Task<bool> DeleteCredito(int id)
        {
            try
            {
                var tiendaEncontrado = await _creditoRepository.Obtener(u => u.Id == id);
                if (tiendaEncontrado == null)
                    throw new TaskCanceledException("Tienda no existe");
                bool respuesta = await _creditoRepository.Eliminar(tiendaEncontrado);
                return respuesta;
            }
            catch
            {
                throw;
            }



        }



    }
}
