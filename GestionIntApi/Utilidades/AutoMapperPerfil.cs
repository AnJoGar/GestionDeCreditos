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

                 .ForMember(destino =>
                    destino.Rol,
                    opt => opt.Ignore()
                   )
                 .ForMember(destino =>
                    destino.EsActivo,
                    opt => opt.MapFrom(origen => origen.EsActivo == 1 ? true : false)
                   );

            #endregion Usuario

       
        
        
        
        
        
        
        
        
        
        
        
        
        }





    }
}
