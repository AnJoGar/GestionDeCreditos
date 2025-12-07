class CreditoDTO {
  int id;
  double monto;
  double entrada; // <--- Agregado
  int plazoCuotas;
  String frecuenciaPago;
  DateTime diaPago;
  double valorPorCuota;
  double totalPagar;
  DateTime proximaCuota;
  String? proximaCuotaStr;
  String? estado;
  int clienteId;

  CreditoDTO({
    this.id = 0,
    required this.monto,
    this.entrada = 0.0,
    required this.plazoCuotas,
    required this.frecuenciaPago,
    required this.diaPago,
    required this.valorPorCuota,
    required this.totalPagar,
    required this.proximaCuota,
    this.proximaCuotaStr,
    this.estado,
    this.clienteId = 0,
  });

  Map<String, dynamic> toJson() => {
    'Id': id,
    'Monto': monto,
    'Entrada': entrada, // Nuevo campo
    'PlazoCuotas': plazoCuotas,
    'FrecuenciaPago': frecuenciaPago,
    'DiaPago': diaPago.toIso8601String(),
    'ValorPorCuota': valorPorCuota,
    'TotalPagar': totalPagar,
    'ProximaCuota': proximaCuota.toIso8601String(),
    'ProximaCuotaStr': proximaCuotaStr,
    'Estado': estado,
    'ClienteId': clienteId,
  };
}