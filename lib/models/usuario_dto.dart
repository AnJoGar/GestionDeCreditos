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

   // ---- FROM JSON ----
  factory UsuarioDTO.fromJson(Map<String, dynamic> json) {
    return UsuarioDTO(
      id: json["id"] ?? 0,
      nombreApellidos: json["nombreApellidos"],
      correo: json["correo"],
      rolId: json["rolId"],
      rolDescripcion: json["rolDescripcion"],
      clave: json["clave"],
      esActivo: json["esActivo"],
      cliente: json["cliente"] != null
          ? ClienteDTO.fromJson(json["cliente"])
          : null,
    );
  }

  // ---- TO JSON ----
  Map<String, dynamic> toJson() => {
<<<<<<< HEAD
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
=======
        'Id': id,
        'NombreApellidos': nombreApellidos,
        'Correo': correo,
        'RolId': rolId,
        'RolDescripcion': rolDescripcion,
        'Clave': clave,
        'EsActivo': esActivo,
        'Cliente': cliente?.toJson(),
      };
>>>>>>> 416748d793b36000680975f7e27775fbe2bccb44
}