using GestionIntApi.DTO;

namespace GestionIntApi.Repositorios.Interfaces
{
    public interface ICreditoService
    {
        Task<List<CreditoDTO>> GetAllTiendas();
        Task<CreditoDTO> GetTiendaById(int id);
        Task<CreditoDTO> CreateCredito(CreditoDTO tiendaDto);
        Task<bool> UpdateCredito(CreditoDTO tiendaDto);
        Task<bool> DeleteCredito(int id);

    }
}
