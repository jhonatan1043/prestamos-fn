import 'package:flutter/material.dart';
import 'package:prestamosft/core/utils/token_storage.dart';
import '../data/prestamo_repository.dart';
import '../data/prestamo_model.dart';
import '../../../core/network/api_service.dart';
import '../../clientes/data/cliente_repository.dart';

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
  int? clienteId;
  bool isLoading = false;
  String? errorMessage;
  List<ClienteModel> clientes = [];

  Future<void> _crearPrestamo() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { isLoading = true; errorMessage = null; });
    final repo = PrestamoRepository(ApiService(baseUrl: 'https://prestamos-bk.onrender.com'));
    // Generar código automáticamente
    final autoCodigo = 'PRE-${DateTime.now().millisecondsSinceEpoch}';
    // Obtener usuarioId desde sesión
     final userId = await TokenStorage.getId() ?? 0;
    final prestamo = PrestamoModel(
      id: id,
      codigo: autoCodigo,
      monto: double.tryParse(monto) ?? 0,
      tasa: double.tryParse(tasa) ?? 0,
      plazoDias: int.tryParse(plazoDias) ?? 0,
      fechaInicio: fechaInicio ?? DateTime.now(),
      estado: 'ACTIVO',
      clienteId: clienteId ?? 0,
      usuarioId: userId, // Ajusta si tienes el id del usuario en sesión
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
                            // Código generado automáticamente
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Código (auto)'),
                              initialValue: 'PRE-${DateTime.now().millisecondsSinceEpoch}',
                              readOnly: true,
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
                            // Estado se maneja internamente
                            FutureBuilder<List<ClienteModel>>(
                              future: ClienteRepository(ApiService(baseUrl: 'https://prestamos-bk.onrender.com')).getClientes(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                final clientesList = snapshot.data!;
                                return DropdownButtonFormField<int>(
                                  decoration: const InputDecoration(labelText: 'Cliente'),
                                  value: clienteId,
                                  items: clientesList.map((c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text('${c.nombres} ${c.apellidos} (${c.identificacion})'),
                                  )).toList(),
                                  onChanged: (v) => setState(() { clienteId = v; }),
                                  validator: (v) => v != null ? null : 'Seleccione un cliente',
                                );
                              },
                            ),
                            const SizedBox(height: 18),
                            // UsuarioId se maneja internamente
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
