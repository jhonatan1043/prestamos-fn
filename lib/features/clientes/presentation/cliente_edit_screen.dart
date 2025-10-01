import 'package:flutter/material.dart';
import '../data/cliente_repository.dart';
import '../../../core/network/api_service.dart';

class ClienteEditScreen extends StatefulWidget {
  final ClienteModel cliente;
  const ClienteEditScreen({Key? key, required this.cliente}) : super(key: key);

  @override
  State<ClienteEditScreen> createState() => _ClienteEditScreenState();
}

class _ClienteEditScreenState extends State<ClienteEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String tipoIdentificacion;
  late String identificacion;
  late String nombres;
  late String apellidos;
  late String direccion;
  late String telefono;
  late String edad;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    tipoIdentificacion = widget.cliente.tipoIdentificacion;
    identificacion = widget.cliente.identificacion;
    nombres = widget.cliente.nombres;
    apellidos = widget.cliente.apellidos;
    direccion = widget.cliente.direccion;
    telefono = widget.cliente.telefono;
    edad = widget.cliente.edad.toString();
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { isLoading = true; errorMessage = null; });
    final apiService = ApiService(baseUrl: 'https://prestamos-bk.onrender.com');
    final clienteRepo = ClienteRepository(apiService);
    final error = await clienteRepo.updateCliente(
      identificacion,
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
        title: const Text('Editar Cliente'),
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
                        'Editar Cliente',
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
                              initialValue: identificacion,
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
                              readOnly: true,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              initialValue: nombres,
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
                              initialValue: apellidos,
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
                              initialValue: direccion,
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
                              initialValue: telefono,
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
                              initialValue: edad,
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
                          onPressed: isLoading ? null : _update,
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Actualizar'),
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
