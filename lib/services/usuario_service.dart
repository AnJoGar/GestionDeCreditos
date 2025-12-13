import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trabajo1/models/usuario_dto.dart';

class UsuarioService {
  final String baseUrl = "https://10.0.2.2:7067/api";

  Future<dynamic> iniciarSesion(String correo, String clave) async {
    final url = Uri.parse("$baseUrl/Usuario//IniciarSesion");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"correo": correo, "clave": clave}),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> guardarUsuario(UsuarioDTO usuario) async {
    final url = Uri.parse("$baseUrl/Guardar");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(usuario.toJson()),
    );

    return jsonDecode(response.body);
  }

   Future<UsuarioDTO?> crearUsuario(UsuarioDTO dto) async {
    final url = Uri.parse("$baseUrl/Crear");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Devuelve el Usuario creado desde el backend
        return UsuarioDTO.fromJson(jsonDecode(response.body));
      } else {
        print("Error en el servidor: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error en la conexión: $e");
      return null;
    }
  }

  Future<List<UsuarioDTO>> listarUsuarios() async {
    final url = Uri.parse("$baseUrl/Lista");

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    List<UsuarioDTO> lista = (data["value"] as List)
        .map((e) => UsuarioDTO.fromJson(e))
        .toList();

    return lista;
  }
}
