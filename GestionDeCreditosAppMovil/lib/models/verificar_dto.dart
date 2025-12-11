class VerificarDTO {
  String correo;
  String codigo;

  VerificarDTO({required this.correo, required this.codigo});

  Map<String, dynamic> toJson() => {
    'Correo': correo,
    'Codigo': codigo,
  };
}