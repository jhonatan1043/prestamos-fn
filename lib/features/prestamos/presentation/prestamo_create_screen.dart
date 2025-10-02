import 'package:flutter/material.dart';
import '../data/prestamo_repository.dart';
import '../data/prestamo_model.dart';
import '../../../core/network/api_service.dart';

class PrestamoCreateScreen extends StatefulWidget {
  const PrestamoCreateScreen({Key? key}) : super(key: key);

  @override
  State<PrestamoCreateScreen> createState() => _PrestamoCreateScreenState();
}

class _PrestamoCreateScreenState extends State<PrestamoCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  int id = 0;
  String codigo = '';
  String monto = '';
  String tasa = '';
  String plazoDias = '';
  DateTime? fechaInicio;
  String estado = 'ACTIVO';
  String clienteId = '';
  String usuarioId = '';
  bool isLoading = false;
  String? errorMessage;

  Future<void> _crearPrestamo() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { isLoading = true; errorMessage = null; });
    final repo = PrestamoRepository(ApiService(baseUrl: 'https://prestamos-bk.onrender.com'));
    final prestamo = PrestamoModel(
      id: id,
      codigo: codigo,
      monto: double.tryParse(monto) ?? 0,
      tasa: double.tryParse(tasa) ?? 0,
      plazoDias: int.tryParse(plazoDias) ?? 0,
      fechaInicio: fechaInicio ?? DateTime.now(),
      estado: estado,
      clienteId: int.tryParse(clienteId) ?? 0,
      usuarioId: int.tryParse(usuarioId) ?? 0,
    );
    final error = await repo.createPrestamo(prestamo);
    setState(() { isLoading = false; });
    if (error == null) {
      Navigator.pop(context, true);
    } else {
      setState(() { errorMessage = error; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Préstamo'),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        'Registrar Préstamo',
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
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Código'),
                              validator: (v) => v != null && v.isNotEmpty ? null : 'Campo requerido',
                              onChanged: (v) => codigo = v,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Monto'),
                              keyboardType: TextInputType.number,
                              validator: (v) => v != null && double.tryParse(v) != null ? null : 'Monto inválido',
                              onChanged: (v) => monto = v,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Tasa (%)'),
                              keyboardType: TextInputType.number,
                              validator: (v) => v != null && double.tryParse(v) != null ? null : 'Tasa inválida',
                              onChanged: (v) => tasa = v,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Plazo (días)'),
                              keyboardType: TextInputType.number,
                              validator: (v) => v != null && int.tryParse(v) != null ? null : 'Plazo inválido',
                              onChanged: (v) => plazoDias = v,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Fecha de inicio (YYYY-MM-DD)'),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Campo requerido';
                                try {
                                  fechaInicio = DateTime.parse(v);
                                  return null;
                                } catch (_) {
                                  return 'Fecha inválida';
                                }
                              },
                              onChanged: (v) {
                                try {
                                  fechaInicio = DateTime.parse(v);
                                } catch (_) {}
                              },
                            ),
                            const SizedBox(height: 18),
                            DropdownButtonFormField<String>(
                              value: estado,
                              decoration: const InputDecoration(labelText: 'Estado'),
                              items: const [
                                DropdownMenuItem(value: 'ACTIVO', child: Text('ACTIVO')),
                                DropdownMenuItem(value: 'CERRADO', child: Text('CERRADO')),
                              ],
                              onChanged: (v) => setState(() { estado = v ?? 'ACTIVO'; }),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'ID Cliente'),
                              keyboardType: TextInputType.number,
                              validator: (v) => v != null && int.tryParse(v) != null ? null : 'ID inválido',
                              onChanged: (v) => clienteId = v,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'ID Usuario'),
                              keyboardType: TextInputType.number,
                              validator: (v) => v != null && int.tryParse(v) != null ? null : 'ID inválido',
                              onChanged: (v) => usuarioId = v,
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
                          onPressed: isLoading ? null : _crearPrestamo,
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Registrar'),
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
