import 'dart:convert';
import '../../../core/network/api_service.dart';
import 'pago_model.dart';

class PagoRepository {
  final ApiService apiService;
  PagoRepository(this.apiService);

  Future<List<PagoModel>> getAllPagos() async {
    final response = await apiService.get('/pagos');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.body.isNotEmpty ? jsonDecode(response.body) : [];
      return data.map((e) => PagoModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<PagoModel?> getPagoById(int id) async {
    final response = await apiService.get('/pagos/$id');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      return PagoModel.fromJson(data);
    }
    return null;
  }

  Future<String?> reportarPago(PagoModel pago) async {
    final response = await apiService.post('/pagos', pago.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return null;
    }
    return response.body.isNotEmpty ? response.body : 'Error al reportar pago';
  }

  Future<String?> actualizarPago(int id, PagoModel pago) async {
    final response = await apiService.put('/pagos/$id', pago.toJson());
    if (response.statusCode == 200) {
      return null;
    }
    return response.body.isNotEmpty ? response.body : 'Error al actualizar pago';
  }

  Future<String?> eliminarPago(int id) async {
    final response = await apiService.delete('/pagos/$id');
    if (response.statusCode == 200) {
      return null;
    }
    return response.body.isNotEmpty ? response.body : 'Error al eliminar pago';
  }
}
