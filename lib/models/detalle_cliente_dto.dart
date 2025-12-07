class DetalleClienteDTO {
  int id;
  String numeroCedula;
  String nombreApellidos;
  String telefono;
  String direccion;
  String? fotoClienteUrl;
  String? fotoContrato;
  String? fotoCelularEntregadoUrl;

  DetalleClienteDTO({
    this.id = 0,
    required this.numeroCedula,
    required this.nombreApellidos,
    required this.telefono,
    required this.direccion,
    this.fotoClienteUrl,
    this.fotoContrato,
    this.fotoCelularEntregadoUrl,
  });

  Map<String, dynamic> toJson() => {
    'Id': id,
    'NumeroCedula': numeroCedula,
    'NombreApellidos': nombreApellidos,
    'Telefono': telefono,
    'Direccion': direccion,
    'FotoClienteUrl': fotoClienteUrl,
    'FotoContrato': fotoContrato,
    'FotoCelularEntregadoUrl': fotoCelularEntregadoUrl,
  };
}