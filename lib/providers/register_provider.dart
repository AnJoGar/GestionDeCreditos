import 'package:flutter/material.dart';
import '../models/usuario_dto.dart';
import '../models/cliente_dto.dart';
import '../models/detalle_cliente_dto.dart';
import '../models/tienda_crear_dto.dart';
import '../models/credito_dto.dart';

class RegisterProvider extends ChangeNotifier {
  final UsuarioDTO _usuarioData = UsuarioDTO(rolId: 2, esActivo: 1);
  DetalleClienteDTO? _detalleClienteData;
  TiendaCrearDTO? _tiendaData;
  CreditoDTO? _creditoData;

  UsuarioDTO get usuario => _usuarioData;
  DetalleClienteDTO? get detalleCliente => _detalleClienteData;

  // MODIFICADO: Ya no recibe fotoUrl
  void setUsuarioBasico(String nombre, String correo, String clave) {
    _usuarioData.nombreApellidos = nombre;
    _usuarioData.correo = correo;
    _usuarioData.clave = clave;
    notifyListeners();
  }

  void setDetalleCliente(DetalleClienteDTO detalle) {
    _detalleClienteData = detalle;
    notifyListeners();
  }

  void setTienda(TiendaCrearDTO tienda) {
    _tiendaData = tienda;
    notifyListeners();
  }

  void setCredito(CreditoDTO credito) {
    _creditoData = credito;
    notifyListeners();
  }

  Map<String, dynamic> armarJsonRegistroCompleto() {
    // Armamos la estructura final (Usuario -> Cliente -> [Tiendas, Creditos, Detalle])
    // Nota: Dependiendo de tu API, la estructura puede variar ligeramente.
    // Asumimos que ClienteDTO agrupa todo.

    final clienteFinal = ClienteDTO(
      detalleCliente: _detalleClienteData,
      // Convertimos la tienda de creación a la estructura que espera el cliente si es necesario,
      // o dejamos que la API maneje la creación de tienda por separado si así está diseñada.
      // Si el UsuarioDTO espera lista de tiendas:
      // tiendas: _tiendaData != null ? [ ... ] : [],
      // *Como TiendaCrearDTO es distinto a TiendaDTO, aquí enviamos lo que la API espere.
      // Por simplicidad, asumimos que el backend procesa los datos en cascada o que
      // enviaremos los objetos por separado si fuera necesario.

      creditos: _creditoData != null ? [_creditoData!] : [],
    );

    _usuarioData.cliente = clienteFinal;

    // IMPORTANTE: Si tu API necesita recibir los datos de la tienda dentro del JSON de registro
    // (y no solo dentro de Cliente), deberías agregarlos aquí o en el DTO correspondiente.
    // Por ahora enviamos el usuario con su cliente anidado.

    return _usuarioData.toJson();
  }

  // Helper para obtener el objeto DTO listo para enviar
  UsuarioDTO getUsuarioFinal() {
    armarJsonRegistroCompleto();
    return _usuarioData;
  }

  void printSummary() {
    print("--- DTO READY ---");
    print("User: ${_usuarioData.nombreApellidos}");
  }
}