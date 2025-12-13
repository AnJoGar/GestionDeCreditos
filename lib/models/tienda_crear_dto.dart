class TiendaCrearDTO {
  String nombreTienda;
  String nombreEncargado;
  String telefono;
  String direccion;
  String codigoTienda;

  TiendaCrearDTO({
    required this.nombreTienda,
    required this.nombreEncargado,
    required this.telefono,
    required this.direccion,
    required this.codigoTienda,
  });

  Map<String, dynamic> toJson() => {
    'NombreTienda': nombreTienda,
    'NombreEncargado': nombreEncargado,
    'Telefono': telefono,
    'Direccion': direccion,
    'CodigoTienda': codigoTienda,
  };
}