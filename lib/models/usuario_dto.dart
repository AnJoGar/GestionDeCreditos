import 'cliente_dto.dart';

class UsuarioDTO {
  int id;
  String? nombreApellidos;
  String? correo;
  int? rolId;
  String? rolDescripcion;
  String? clave;
  int? esActivo;
  ClienteDTO? cliente;

  UsuarioDTO({
    this.id = 0,
    this.nombreApellidos,
    this.correo,
    this.rolId,
    this.rolDescripcion,
    this.clave,
    this.esActivo,
    this.cliente,
  });

  // 1. Método para enviar datos a la API (Serialización)
  Map<String, dynamic> toJson() => {
    'Id': id,
    'NombreApellidos': nombreApellidos,
    'Correo': correo,
    'RolId': rolId,
    'RolDescripcion': rolDescripcion,
    'Clave': clave,
    'EsActivo': esActivo,
    'Cliente': cliente?.toJson(),
  };

  // 2. Método para recibir datos de la API (Deserialización) <--- ESTO FALTABA
  factory UsuarioDTO.fromJson(Map<String, dynamic> json) {
    return UsuarioDTO(
      id: json['Id'] ?? 0,
      nombreApellidos: json['NombreApellidos'],
      correo: json['Correo'],
      rolId: json['RolId'],
      rolDescripcion: json['RolDescripcion'],
      // La clave usualmente no viene de regreso por seguridad, pero la dejamos por si acaso
      clave: json['Clave'],
      esActivo: json['EsActivo'],
      // Importante: Si viene un objeto 'Cliente', lo convertimos también
      cliente: json['Cliente'] != null
          ? ClienteDTO.fromJson(json['Cliente'])
          : null,
    );
  }
}