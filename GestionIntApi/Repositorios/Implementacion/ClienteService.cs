using AutoMapper;
using GestionIntApi.DTO;
using GestionIntApi.Models;
using GestionIntApi.Repositorios.Contrato;
using GestionIntApi.Repositorios.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;


namespace GestionIntApi.Repositorios.Implementacion
{
    public class ClienteService:IClienteService
    {
        private readonly IGenericRepository<Cliente> _DetalleRepositorio;
        private readonly IClienteService _clienteRepository;
       
        private readonly SistemaGestionDBcontext _context;
        private readonly IMapper _mapper;

        public ClienteService(SistemaGestionDBcontext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        public async Task<IEnumerable<ClienteDTO>> GetClientes()
        {
            var clientes = await _context.Clientes
                .Include(c => c.Usuario)
                .Include(c => c.DetalleCliente)
                .Include(c => c.Tiendas)
                .Include(c => c.Creditos)
                .ToListAsync();

            return _mapper.Map<IEnumerable<ClienteDTO>>(clientes);
        }

        public async Task<ClienteDTO> GetClienteById(int id)
        {
            var cliente = await _context.Clientes
                .Include(c => c.Usuario)
                .Include(c => c.DetalleCliente)
                .Include(c => c.Tiendas)
                .Include(c => c.Creditos)
                .FirstOrDefaultAsync(c => c.Id == id);

            return _mapper.Map<ClienteDTO>(cliente);
        }

        public async Task<ClienteDTO> CreateCliente(ClienteDTO clienteDto)
        {
            try
            {
                var clienteGenerado = await _DetalleRepositorio.Crear(_mapper.Map<Cliente>(clienteDto));

                if (clienteGenerado.Id == 0)
                    throw new TaskCanceledException("No se pudo crear la cita");
                return _mapper.Map<ClienteDTO>(clienteGenerado);
            }
            catch
            {
                throw;
            }
        }

        public async Task<bool> UpdateCliente(int id, ClienteDTO clienteDto)
        {
            var cliente = await _context.Clientes.FindAsync(id);
            if (cliente == null)
                return false;

            _mapper.Map(clienteDto, cliente);


            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeleteCliente(int id)
        {
            var cliente = await _context.Clientes.FindAsync(id);
            if (cliente == null)
                return false;

            _context.Clientes.Remove(cliente);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<IEnumerable<ClienteDTO>> GetClientesPorTienda(int tiendaId)
        {
            var clientes = await _context.Clientes
                .Where(c => c.Tiendas.Any(t => t.Id == tiendaId))
                .Include(c => c.Usuario)
                .Include(c => c.DetalleCliente)
                 .Include(c => c.Tiendas)
                .Include(c => c.Creditos)
                .ToListAsync();

            return _mapper.Map<IEnumerable<ClienteDTO>>(clientes);
        }

        public async Task<IEnumerable<ClienteDTO>> GetClientesPorUsuario(int usuarioId)
        {
            var clientes = await _context.Clientes
                .Where(c => c.UsuarioId == usuarioId)
                .Include(c => c.Tiendas)
                .Include(c => c.Creditos)
                .ToListAsync();

            return _mapper.Map<IEnumerable<ClienteDTO>>(clientes);
        }
    }
}
