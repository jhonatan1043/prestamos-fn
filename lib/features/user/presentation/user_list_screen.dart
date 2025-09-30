import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../../core/models/user_model.dart';
// import '../../../core/utils/token_storage.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];
  bool isLoading = true;
  String? errorMessage;
  String searchText = '';

  void _filterUsers() {
    setState(() {
      if (searchText.isEmpty) {
        filteredUsers = users;
      } else {
        filteredUsers = users.where((u) =>
          u.nombre.toLowerCase().contains(searchText.toLowerCase()) ||
          u.email.toLowerCase().contains(searchText.toLowerCase())
        ).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() { isLoading = true; errorMessage = null; });
    final apiService = ApiService(baseUrl: 'https://prestamos-bk.onrender.com');
    try {
      final response = await apiService.get('/users');
      if (response.statusCode == 200) {
        users = UserModel.listFromJson(response.body);
        _filterUsers();
      } else {
        errorMessage = 'Error al obtener usuarios (${response.statusCode})';
      }
    } catch (e) {
      errorMessage = 'Error de red: $e';
    }
    setState(() { isLoading = false; });
  }

  Future<void> _deleteUser(String id) async {
    final apiService = ApiService(baseUrl: 'https://prestamos-bk.onrender.com');
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar usuario?'),
        content: const Text('¿Estás seguro que deseas eliminar este usuario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final response = await apiService.delete('/users/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario eliminado')));
  await _fetchUsers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar (${response.statusCode})')));
      }
    }
  }

  void _editUser(UserModel user) async {
    final nombreController = TextEditingController(text: user.nombre);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Actualizar usuario'),
        content: TextField(
          controller: nombreController,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final apiService = ApiService(baseUrl: 'https://prestamos-bk.onrender.com');
      final response = await apiService.put('/users/${user.id}', {
        'nombre': nombreController.text,
        'email': user.email,
        'role': user.role,
      });
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario actualizado')));
        await _fetchUsers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar (${response.statusCode})')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        backgroundColor: const Color(0xFF00C853),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2FFDC), Color(0xFFE8F5E9), Color(0xFFF7F9FB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Buscar por nombre o correo',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              searchText = value;
                              _filterUsers();
                            },
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: ListTile(
                                  leading: const Icon(Icons.account_circle, color: Color(0xFF00C853)),
                                  title: Text(user.nombre),
                                  subtitle: Text(user.email),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.orange),
                                        onPressed: () => _editUser(user),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _deleteUser(user.id),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00C853),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, '/register');
        },
        tooltip: 'Crear usuario',
      ),
    );
  }
}
