import '../../../core/network/api_service.dart';
import '../../../core/models/user_model.dart';

class UserRepositoryImpl {
  final ApiService apiService;
  UserRepositoryImpl(this.apiService);

  Future<String?> createUser(UserModel userModel) async {
    try {
      // Construir el JSON sin el campo 'id' para creación
      final Map<String, dynamic> json = {
        'nombre': userModel.nombre,
        'email': userModel.email,
        'password': userModel.password,
        'role': userModel.role,
      };
      final response = await apiService.post('/users', json);
      if (response.statusCode == 201) {
        return null; // null = éxito
      } else if (response.statusCode == 400) {
        return 'Datos inválidos o usuario ya existe';
      } else if (response.statusCode == 404) {
        return 'Servicio no disponible (404)';
      } else {
        return 'Error inesperado: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error de red o CORS: ${e.toString()}';
    }
  }
}
