class TiendaDTO {
  int id;
  String nombreTienda;
  String nombreEncargado;
  String telefono;
  String direccion;
  DateTime fechaRegistro;
  int clienteId;

  TiendaDTO({
    this.id = 0,
    required this.nombreTienda,
    required this.nombreEncargado,
    required this.telefono,
    required this.direccion,
    required this.fechaRegistro,
    this.clienteId = 0,
  });

  Map<String, dynamic> toJson() => {
    'Id': id,
    'NombreTienda': nombreTienda,
    'NombreEncargado': nombreEncargado,
    'Telefono': telefono,
    'Direccion': direccion,
    'FechaRegistro': fechaRegistro.toIso8601String(),
    'ClienteId': clienteId,
  };
}