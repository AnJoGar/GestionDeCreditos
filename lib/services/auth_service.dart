import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_dto.dart';

class AuthService {
  // URL de la API: usa HTTP y el puerto correcto
  final String baseUrl = "http://192.168.100.13:7166/api";

  Future<bool> login(LoginDTO loginDTO) async {
    final url = Uri.parse('$baseUrl/Usuario/IniciarSesion');

    print('Intentando conectarse a la API: $url');
    print('Datos enviados: ${loginDTO.toJson()}');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(loginDTO.toJson()),
          )
          .timeout(const Duration(seconds: 5)); // timeout de 5 segundos

      print('Código de respuesta: ${response.statusCode}');
      print('Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Datos decodificados: $data');

        if (data['status'] == true) {
          print('Login exitoso: ${data['value']}');
          return true;
        } else {
          print('Error en login: ${data['msg']}');
          return false;
        }
      } else {
        print('Error en la conexión: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Excepción al conectarse a la API: $e');
      return false;
    }
  }
}
