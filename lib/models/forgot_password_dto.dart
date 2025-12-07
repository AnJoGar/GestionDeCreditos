class ForgotPasswordDTO {
  String correo;

  ForgotPasswordDTO({required this.correo});

  Map<String, dynamic> toJson() => {
    'Correo': correo,
  };
}