import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../../core/utils/token_storage.dart';
import '../data/auth_repository_impl.dart';
import '../../../core/models/login_model.dart';
// ...existing code...

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;
  String? errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { isLoading = true; errorMessage = null; });
    final apiService = ApiService(baseUrl: 'https://prestamos-bk.onrender.com');
    final authRepo = AuthRepositoryImpl(apiService);
    final error = await authRepo.login(LoginModel(email: email, password: password));
    await TokenStorage.saveEmail(email);
    setState(() { isLoading = false; });
    if (error == null) {
      // El nombre solo se guarda si lo tienes en el backend, aquí solo el email
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      setState(() { errorMessage = error; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFF7F9FB),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.account_balance_wallet_rounded, size: 64, color: Color(0xFF388E3C)),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Préstamos Rápidos',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF388E3C),
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sistema Integral de Préstamos',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 32),
                      FractionallySizedBox(
                        widthFactor: 0.98,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF388E3C)),
                                labelText: 'Correo electrónico',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: Color(0xFF388E3C)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFF388E3C)),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v != null && v.contains('@') ? null : 'Email inválido',
                              onChanged: (v) => setState(() { email = v; }),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF388E3C)),
                                labelText: 'Contraseña',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: Color(0xFF388E3C)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFF388E3C)),
                                ),
                              ),
                              obscureText: true,
                              validator: (v) => v != null && v.length >= 8 ? null : 'Mínimo 8 caracteres',
                              onChanged: (v) => setState(() { password = v; }),
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
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF388E3C),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          onPressed: isLoading ? null : _login,
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Iniciar Sesión'),
                        ),
                      ),
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
