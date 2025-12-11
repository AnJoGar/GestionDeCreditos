import 'cliente_dto.dart';

class UsuarioDTO {
  int id;
  String? nombreApellidos;
  String? correo;
  int? rolId;
  String? rolDescripcion;
  String? clave;
  int? esActivo;
  String? fotoUrl; // <--- NUEVO CAMPO
  ClienteDTO? cliente;

  UsuarioDTO({
    this.id = 0,
    this.nombreApellidos,
    this.correo,
    this.rolId,
    this.rolDescripcion,
    this.clave,
    this.esActivo,
    this.fotoUrl, // <--- Agregar al constructor
    this.cliente,
  });

  Map<String, dynamic> toJson() => {
    'Id': id,
    'NombreApellidos': nombreApellidos,
    'Correo': correo,
    'RolId': rolId,
    'RolDescripcion': rolDescripcion,
    'Clave': clave,
    'EsActivo': esActivo,
    'FotoUrl': fotoUrl, // <--- Agregar al JSON
    'Cliente': cliente?.toJson(),
  };
}