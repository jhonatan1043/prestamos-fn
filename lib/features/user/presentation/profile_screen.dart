import 'package:flutter/material.dart';
import '../../../core/utils/token_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String nombre = '';
  String email = '';
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    // Simulación: normalmente se obtendría desde backend o storage
    final storedEmail = await TokenStorage.getEmail();
    final storedNombre = await TokenStorage.getNombre();
    setState(() {
      email = storedEmail ?? '';
      nombre = storedNombre ?? '';
    });
  }

  Future<void> _updateNombre() async {
    if (nombre.isEmpty) {
      setState(() { errorMessage = 'El nombre no puede estar vacío.'; });
      return;
    }
    setState(() { isLoading = true; errorMessage = null; });
    // Aquí iría la lógica real de actualización en backend
    await TokenStorage.saveNombre(nombre);
    setState(() { isLoading = false; });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nombre actualizado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
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
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    const Icon(Icons.account_circle, size: 80, color: Color(0xFF00C853)),
                    const SizedBox(height: 24),
                    TextFormField(
                      initialValue: nombre,
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
                      onChanged: (v) => setState(() { nombre = v; }),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      initialValue: email,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Correo',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: const TextStyle(color: Color(0xFF00C853)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF00C853)),
                        ),
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
                        onPressed: isLoading ? null : _updateNombre,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Actualizar nombre'),
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
    );
  }
}
