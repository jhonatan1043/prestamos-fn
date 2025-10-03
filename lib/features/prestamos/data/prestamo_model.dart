class PrestamoModel {
  final int id;
  final String codigo;
  final double monto;
  final double tasa;
  final int plazoDias;
  final DateTime fechaInicio;
  final String estado;
  final int clienteId;
  final int usuarioId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PrestamoModel({
    required this.id,
    required this.codigo,
    required this.monto,
    required this.tasa,
    required this.plazoDias,
    required this.fechaInicio,
    required this.estado,
    required this.clienteId,
    required this.usuarioId,
    this.createdAt,
    this.updatedAt,
  });

  factory PrestamoModel.fromJson(Map<String, dynamic> json) {
    return PrestamoModel(
      id: json['id'] ?? 0,
      codigo: json['codigo'] ?? '',
      monto: (json['monto'] ?? 0).toDouble(),
      tasa: (json['tasa'] ?? 0).toDouble(),
      plazoDias: json['plazoDias'] ?? 0,
      fechaInicio: DateTime.parse(json['fechaInicio'] ?? DateTime.now().toIso8601String()),
      estado: json['estado'] ?? '',
      clienteId: json['clienteId'] ?? 0,
      usuarioId: json['usuarioId'] ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson({bool includeId = false}) => {
    if (includeId) 'id': id,
    'codigo': codigo,
    'monto': monto,
    'tasa': tasa,
    'plazoDias': plazoDias,
    'fechaInicio': fechaInicio.toIso8601String(),
    'estado': estado,
    'clienteId': int.tryParse(clienteId.toString()) ?? 0,
    'usuarioId': int.tryParse(usuarioId.toString()) ?? 0,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
  };
}
