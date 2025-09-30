import 'dart:convert';

class UserModel {
  final String id;
  final String nombre;
  final String email;
  final String password;
  final String role;

  UserModel({
    required this.id,
    required this.nombre,
    required this.email,
    required this.password,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 'USER',
    );
  }

  static List<UserModel> listFromJson(String body) {
    final List<dynamic> data = body.isNotEmpty ? jsonDecode(body) : [];
    return data.map((e) => UserModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'email': email,
        'password': password,
        'role': role,
      };
}
