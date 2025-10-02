import 'dart:convert';
import '../../../core/network/api_service.dart';
import 'prestamo_model.dart';

class PrestamoRepository {
  final ApiService apiService;
  PrestamoRepository(this.apiService);

  Future<List<PrestamoModel>> getPrestamos() async {
    final response = await apiService.get('/prestamos');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.body.isNotEmpty ? jsonDecode(response.body) : [];
      return data.map((e) => PrestamoModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<String?> createPrestamo(PrestamoModel prestamo) async {
    final response = await apiService.post('/prestamos', prestamo.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return null;
    }
    return response.body.isNotEmpty ? response.body : 'Error al crear préstamo';
  }
}
