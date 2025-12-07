class LoginDTO {
  String? correo;
  String? clave;

  LoginDTO({this.correo, this.clave});

  Map<String, dynamic> toJson() => {
    'Correo': correo,
    'Clave': clave,
  };
}