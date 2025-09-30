import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../data/user_repository_impl.dart';
import '../../../core/network/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String email = '';
  String password = '';
  String role = 'USER';
  bool isLoading = false;
  String? errorMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { isLoading = true; errorMessage = null; });
    final apiService = ApiService(baseUrl: 'https://prestamos-bk.onrender.com');
    final userRepo = UserRepositoryImpl(apiService);
    final error = await userRepo.createUser(UserModel(
      nombre: nombre,
      email: email,
      password: password,
      role: role, id: '',
    ));
    setState(() { isLoading = false; });
    if (error == null) {
      Navigator.pushReplacementNamed(context, '/user_list');
    } else {
      setState(() { errorMessage = error; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Usuario'),
        backgroundColor: Color(0xFF00C853),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
        ),
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
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        'Crear Usuario',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF00C853),
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 32),
                      FractionallySizedBox(
                        widthFactor: 0.95,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Nombre',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: Color(0xFF00C853)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF00C853)),
                                ),
                              ),
                              validator: (v) => v != null && v.isNotEmpty ? null : 'Campo requerido',
                              onChanged: (v) => nombre = v,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: Color(0xFF00C853)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF00C853)),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v != null && v.contains('@') ? null : 'Email inválido',
                              onChanged: (v) => email = v,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: Color(0xFF00C853)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF00C853)),
                                ),
                              ),
                              obscureText: true,
                              validator: (v) => v != null && v.length >= 8 ? null : 'Mínimo 8 caracteres',
                              onChanged: (v) => password = v,
                            ),
                            const SizedBox(height: 18),
                            DropdownButtonFormField<String>(
                              value: role,
                              decoration: InputDecoration(
                                labelText: 'Rol',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: Color(0xFF00C853)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF00C853)),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'USER', child: Text('Usuario')),
                                DropdownMenuItem(value: 'ADMIN', child: Text('Administrador')),
                              ],
                              onChanged: (v) => setState(() { role = v ?? 'USER'; }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C853),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          onPressed: isLoading ? null : _register,
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Registrar'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
