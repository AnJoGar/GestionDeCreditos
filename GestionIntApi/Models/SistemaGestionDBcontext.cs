using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace GestionIntApi.Models
{
    public class SistemaGestionDBcontext: DbContext
    {


        public SistemaGestionDBcontext(DbContextOptions<SistemaGestionDBcontext> options)
            : base(options)
        {
        }


        public DbSet<Usuario> Usuarios { get; set; }
//        public virtual DbSet<Rol> Rol { get; set; } = null!;
  //      public virtual DbSet<MenuRol> MenuRols { get; set; } = null!;
    //    public virtual DbSet<Menu> Menus { get; set; } = null!;
      //  public DbSet<EmailSettings> EmailSettings { get; set; }

        public DbSet<VerificationCode> VerificationCodes { get; set; }

        public DbSet<VerificationCode> CodigosVerificacion { get; set; }

    }
}
