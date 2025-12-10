import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trabajo1/models/verificar_dto.dart';
import '../models/enviar_codigo_dto.dart';

class ValidarCuenta {
  final String baseUrl = "https://localhost:7067/api";
Future<VerificarDTO?> verificarCuenta(VerificarDTO dto) async {
  final url = Uri.parse('$baseUrl/EmailValidation/ValidarCodigo');
  print('--- FORGOT PASSWORD ---');
  print('URL: $url');
  print('Datos enviados: ${dto.toJson()}');

  try {
    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dto.toJson()),
        )
        .timeout(const Duration(seconds: 20));

    print('Código de respuesta: ${response.statusCode}');
    print('Cuerpo de respuesta: ${response.body}');

    if (response.statusCode == 200) {
      // Respuesta exitosa como string
      print('✅ Solicitud de recuperación exitosa: ${response.body}');
      return dto; // simplemente retornamos el DTO enviado
    } else {
      print('❌ Error al enviar correo: ${response.body}');
      return null;
    }
  } catch (e) {
    print('⚠️ Excepción en forgotPassword: $e');
    return null;
  }
}

  // =============== RESET PASSWORD ===============
Future<EnviarCodigoDTO?> enviarCodigo(EnviarCodigoDTO dto) async {
    final url = Uri.parse('$baseUrl/EmailValidation/EnviarCodigo');
    print('--- FORGOT PASSWORD ---');
    print('URL: $url');
    print('Datos enviados: ${dto.correo}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dto.correo), 
      ).timeout(const Duration(seconds: 10));

      print('Código de respuesta: ${response.statusCode}');
      print('Cuerpo de respuest:a ${response.body}');

  if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  if (data['status'] == true) {
    print('Solicitud de recuperación exitosa: ${data['msg']}');
    // Retorna un DTO con el correo que enviaste
    return EnviarCodigoDTO(correo: dto.correo);
  } else {
    print('Error al enviar correo: ${data['msg']}');
    return null;
  }
}
    } catch (e) {
      print('Excepción en forgotPassword: $e');
      return null;
    }
  }


}
