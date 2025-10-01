import 'package:flutter/material.dart';
import '../data/cliente_repository.dart';
import '../../../core/network/api_service.dart';

class ClienteRegisterScreen extends StatefulWidget {
  const ClienteRegisterScreen({Key? key}) : super(key: key);

  @override
  State<ClienteRegisterScreen> createState() => _ClienteRegisterScreenState();
}

class _ClienteRegisterScreenState extends State<ClienteRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String tipoIdentificacion = '';
  String identificacion = '';
  String nombres = '';
  String apellidos = '';
  String direccion = '';
  String telefono = '';
  String edad = '';
  bool isLoading = false;
  String? errorMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { isLoading = true; errorMessage = null; });
    final apiService = ApiService(baseUrl: 'https://prestamos-bk.onrender.com');
    final clienteRepo = ClienteRepository(apiService);
    final error = await clienteRepo.createCliente(
      ClienteModel(
        tipoIdentificacion: tipoIdentificacion,
        identificacion: identificacion,
        nombres: nombres,
        apellidos: apellidos,
        direccion: direccion,
        telefono: telefono,
        edad: int.tryParse(edad) ?? 0,
      ),
    );
    setState(() { isLoading = false; });
    if (error == null) {
      Navigator.pushReplacementNamed(context, '/cliente_list');
    } else {
      setState(() { errorMessage = error; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cliente'),
        backgroundColor: const Color(0xFF00C853),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/cliente_list');
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
                        'Crear Cliente',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF00C853),
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 32),
                      FractionallySizedBox(
                        widthFactor: 0.95,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DropdownButtonFormField<String>(
                              value: tipoIdentificacion.isEmpty ? null : tipoIdentificacion,
                              decoration: InputDecoration(
                                labelText: 'Tipo de Identificación',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: Color(0xFF00C853)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF00C853)),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'CC', child: Text('Cédula de Ciudadanía')),
                                DropdownMenuItem(value: 'TI', child: Text('Tarjeta de Identidad')),
                                DropdownMenuItem(value: 'CE', child: Text('Cédula de Extranjería')),
                                DropdownMenuItem(value: 'NIT', child: Text('NIT')),
                              ],
                              validator: (v) => v != null && v.isNotEmpty ? null : 'Campo requerido',
                              onChanged: (v) => setState(() { tipoIdentificacion = v ?? ''; }),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Identificación',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: Color(0xFF00C853)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF00C853)),
                                ),
                              ),
                              validator: (v) => v != null && v.isNotEmpty ? null : 'Campo requerido',
                              onChanged: (v) => identificacion = v,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Nombres',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: Color(0xFF00C853)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF00C853)),
                                ),
                              ),
                              validator: (v) => v != null && v.isNotEmpty ? null : 'Campo requerido',
                              onChanged: (v) => nombres = v,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Apellidos',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: Color(0xFF00C853)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF00C853)),
                                ),
                              ),
                              validator: (v) => v != null && v.isNotEmpty ? null : 'Campo requerido',
                              onChanged: (v) => apellidos = v,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Dirección',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: Color(0xFF00C853)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF00C853)),
                                ),
                              ),
                              validator: (v) => v != null && v.isNotEmpty ? null : 'Campo requerido',
                              onChanged: (v) => direccion = v,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Teléfono',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: Color(0xFF00C853)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF00C853)),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (v) => v != null && v.length >= 7 && int.tryParse(v) != null ? null : 'Teléfono inválido',
                              onChanged: (v) => telefono = v,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Edad',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: Color(0xFF00C853)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF00C853)),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) => v != null && int.tryParse(v) != null ? null : 'Solo números',
                              onChanged: (v) => edad = v,
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
