import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_storage.dart';
import '../utils/session_manager.dart';

class ApiService {
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await TokenStorage.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 401) {
      await TokenStorage.clearToken();
      SessionManager().redirectToLogin();
    }
    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await TokenStorage.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 401) {
      await TokenStorage.clearToken();
      SessionManager().redirectToLogin();
    }
    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await TokenStorage.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.delete(url, headers: headers);
    if (response.statusCode == 401) {
      await TokenStorage.clearToken();
      SessionManager().redirectToLogin();
    }
    return response;
  }
  final String baseUrl;
  ApiService({required this.baseUrl});

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await TokenStorage.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
    // Interceptor: Si el token está vencido (401), limpiar y redirigir
    if (response.statusCode == 401) {
      await TokenStorage.clearToken();
      SessionManager().redirectToLogin();
    }
    return response;
  }
}
