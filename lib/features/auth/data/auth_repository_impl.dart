import 'dart:convert';
import '../../../core/network/api_service.dart';
import '../../../core/models/login_model.dart';
import '../../../core/utils/token_storage.dart';

class AuthRepositoryImpl {
  final ApiService apiService;
  AuthRepositoryImpl(this.apiService);

  Future<String?> login(LoginModel loginModel) async {
    try {

      final response = await apiService.post('/auth/login', loginModel.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {

        final body = response.body;
        final data = body.isNotEmpty ? jsonDecode(body) : null;
        final token = data != null && data['access_token'] != null ? data['access_token'] as String : null;
        String role = 'USER';
        
        if (token != null) {
          // Extraer payload del JWT
          final parts = token.split('.');
          if (parts.length == 3) {
            final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
            final payloadMap = jsonDecode(payload);
            role = payloadMap['roles'] ?? 'USER';
          }
          await TokenStorage.saveToken(token, role);
        }
        return null; // null = éxito
      } else if (response.statusCode == 401) {
        return 'Credenciales incorrectas';
      } else if (response.statusCode == 404) {
        return 'Servicio no disponible (404)';
      } else {
        return 'Error inesperado: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error de red o CORS: ${e.toString()}';
    }
  }

  String? _extractToken(String body) {
    try {
      final data = body.isNotEmpty ? jsonDecode(body) : null;
      if (data != null && data['access_token'] != null) {
        return data['access_token'] as String;
      }
    } catch (_) {}
    return null;
  }
}
