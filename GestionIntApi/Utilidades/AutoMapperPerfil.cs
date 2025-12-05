using AutoMapper;
using GestionIntApi.DTO;
using GestionIntApi.Models;

namespace GestionIntApi.Utilidades
{
    public class AutoMapperPerfil : Profile
    {


        public AutoMapperPerfil()
        {
            #region Rol
            CreateMap<Rol, RolDTO>().ReverseMap();
            #endregion Rol

            #region Menu
            CreateMap<Menu, MenuDTO>().ReverseMap();
            #endregion Menu

            #region Usuario
            CreateMap<Usuario, UsuarioDTO>()
                 .ForMember(dest => dest.Cliente, opt => opt.Ignore())
                .ForMember(destino =>
                    destino.RolDescripcion,
                    opt => opt.MapFrom(origen => origen.Rol.Descripcion)
                )

                .ForMember(destino =>
                destino.EsActivo,
                opt => opt.MapFrom(origen => origen.EsActivo == true ? 1 : 0)
            );


            CreateMap<Usuario, SesionDTO>()
                .ForMember(destino =>
                    destino.RolDescripcion,
                    opt => opt.MapFrom(origen => origen.Rol.Descripcion)
                );

            CreateMap<UsuarioDTO, Usuario>()
                  .ForMember(dest => dest.Cliente, opt => opt.Ignore())
                 .ForMember(destino =>
                    destino.Rol,
                    opt => opt.Ignore()
                   )
                 .ForMember(destino =>
                    destino.EsActivo,
                    opt => opt.MapFrom(origen => origen.EsActivo == 1 ? true : false)
                   );

            #endregion Usuario
            #region DetalleCliente
            CreateMap<DetalleCliente, DetalleClienteDTO>().ReverseMap();
            CreateMap<ClienteDTO, Cliente>()
    .ForMember(dest => dest.Usuario, opt => opt.Ignore())
    .ReverseMap();


            #endregion DetalleCliente
            #region Credito
            CreateMap<Credito, CreditoDTO>()
                .ForMember(dest => dest.ProximaCuotaStr,
               opt => opt.MapFrom(src => src.ProximaCuota.ToString("dd/MM/yyyy")));
            CreateMap<CreditoDTO, Credito>()
    .ForMember(dest => dest.ProximaCuota, opt => opt.Ignore()); //

            #endregion Credito
            #region Tienda
            CreateMap<Tienda, TiendaDTO>().ReverseMap();


            #endregion Tienda


            #region Notificacion

            CreateMap<Notificacion, NotificacionDTO>().ReverseMap();
            #endregion Notificacion







        }





    }
}
