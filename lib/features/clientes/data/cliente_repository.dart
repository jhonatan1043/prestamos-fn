import 'dart:convert';
import '../../../core/network/api_service.dart';

class ClienteModel {
  final String tipoIdentificacion;
  final String identificacion;
  final String nombres;
  final String apellidos;
  final String direccion;
  final String telefono;
  final int edad;

  ClienteModel({
    required this.tipoIdentificacion,
    required this.identificacion,
    required this.nombres,
    required this.apellidos,
    required this.direccion,
    required this.telefono,
    required this.edad,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      tipoIdentificacion: json['tipoIdentificacion'] ?? '',
      identificacion: json['identificacion'] ?? '',
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      direccion: json['direccion'] ?? '',
      telefono: json['telefono'] ?? '',
      edad: int.tryParse(json['edad'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'tipoIdentificacion': tipoIdentificacion,
    'identificacion': identificacion,
    'nombres': nombres,
    'apellidos': apellidos,
    'direccion': direccion,
    'telefono': telefono,
    'edad': edad,
  };

  static List<ClienteModel> listFromJson(String body) {
    final List<dynamic> data = body.isNotEmpty ? jsonDecode(body) : [];
    return data.map((e) => ClienteModel.fromJson(e)).toList();
  }
}

class ClienteRepository {
  final ApiService apiService;
  ClienteRepository(this.apiService);

  Future<List<ClienteModel>> getClientes() async {
    final response = await apiService.get('/clientes');
    if (response.statusCode == 200) {
      return ClienteModel.listFromJson(response.body);
    }
    return [];
  }

  Future<String?> createCliente(ClienteModel cliente) async {
    final response = await apiService.post('/clientes', cliente.toJson());
    if (response.statusCode == 201) {
      return null;
    }
    return 'Error al crear cliente';
  }

  Future<String?> updateCliente(String id, ClienteModel cliente) async {
    final response = await apiService.post('/clientes/$id', cliente.toJson());
    if (response.statusCode == 200) {
      return null;
    }
    return 'Error al actualizar cliente';
  }

  Future<String?> deleteCliente(String id) async {
    final response = await apiService.post('/clientes/$id/delete', {});
    if (response.statusCode == 200) {
      return null;
    }
    return 'Error al eliminar cliente';
  }
}
