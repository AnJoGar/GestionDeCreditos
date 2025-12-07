class ResetPasswordDTO {
  String token;
  String nuevaClave;

  ResetPasswordDTO({
    required this.token,
    required this.nuevaClave
  });

  Map<String, dynamic> toJson() => {
    'Token': token,
    'NuevaClave': nuevaClave,
  };
}