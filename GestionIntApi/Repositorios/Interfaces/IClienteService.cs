using GestionIntApi.DTO;
using GestionIntApi.Models;

namespace GestionIntApi.Repositorios.Interfaces
{
    public interface IClienteService
    {

        Task<IEnumerable<ClienteDTO>> GetClientes();
        Task<ClienteDTO> GetClienteById(int id);
        Task<ClienteDTO> CreateCliente(ClienteDTO clienteDto);
      
        Task<bool> UpdateCliente(int id, ClienteDTO clienteDto);
        Task<bool> DeleteCliente(int id);

        // Métodos adicionales opcionales
        Task<IEnumerable<ClienteDTO>> GetClientesPorTienda(int tiendaId);
        Task<IEnumerable<ClienteDTO>> GetClientesPorUsuario(int usuarioId);
    }
}
