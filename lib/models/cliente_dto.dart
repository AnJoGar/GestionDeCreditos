import 'tienda_dto.dart';
import 'credito_dto.dart';
import 'detalle_cliente_dto.dart';

class ClienteDTO {
  int id;
  int? usuarioId;
  int detalleClienteID;
  DetalleClienteDTO? detalleCliente;
  List<TiendaDTO>? tiendas;
  List<CreditoDTO>? creditos;

  ClienteDTO({
    this.id = 0,
    this.usuarioId,
    this.detalleClienteID = 0,
    this.detalleCliente,
    this.tiendas,
    this.creditos,
  });

  Map<String, dynamic> toJson() => {
    'Id': id,
    'UsuarioId': usuarioId,
    'DetalleClienteID': detalleClienteID,
    'DetalleCliente': detalleCliente?.toJson(),
    'Tiendas': tiendas?.map((e) => e.toJson()).toList(),
    'Creditos': creditos?.map((e) => e.toJson()).toList(),
  };
}