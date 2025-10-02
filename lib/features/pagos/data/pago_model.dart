class PagoModel {
  final int prestamoId;
  final DateTime fecha;
  final double monto;

  PagoModel({
    required this.prestamoId,
    required this.fecha,
    required this.monto,
  });

  factory PagoModel.fromJson(Map<String, dynamic> json) {
    return PagoModel(
      prestamoId: json['prestamoId'],
      fecha: DateTime.parse(json['fecha']),
      monto: (json['monto'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'prestamoId': prestamoId,
    'fecha': fecha.toIso8601String(),
    'monto': monto,
  };
}
