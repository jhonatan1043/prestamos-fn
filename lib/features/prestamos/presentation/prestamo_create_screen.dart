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
  final TextEditingController _montoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int id = 0;
  String codigo = '';
  String monto = '';
  String tasa = '';
  String plazoDias = '';
  DateTime? fechaInicio;
  final TextEditingController _fechaController = TextEditingController();
  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  int? clienteId;
  bool isLoading = false;
  String? errorMessage;
  List<ClienteModel> clientes = [];

  Future<void> _crearPrestamo() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final repo = PrestamoRepository(
      ApiService(baseUrl: 'https://prestamos-bk.onrender.com'),
    );
    // Generar código automáticamente
    final autoCodigo = 'PRE-${DateTime.now().millisecondsSinceEpoch}';
    // Obtener usuarioId desde sesión
    final userIdRaw = await TokenStorage.getId();
    final userId = userIdRaw is int ? userIdRaw : int.tryParse(userIdRaw?.toString() ?? '') ?? 0;
    if (userId == 0) {
      // Debug para usuarioId incorrecto
      // ignore: avoid_print
      print('DEBUG usuarioId: $userIdRaw ${userId.runtimeType}');
    }
    // Asegurar formato ISO-8601 con zona horaria Z
    final fechaIso = (fechaInicio ?? DateTime.now()).toUtc().toIso8601String();
    final prestamo = PrestamoModel(
      id: id,
      codigo: autoCodigo,
      monto: double.tryParse(monto) ?? 0,
      tasa: double.tryParse(tasa) ?? 0,
      plazoDias: int.tryParse(plazoDias) ?? 0,
      fechaInicio: DateTime.parse(fechaIso),
      estado: 'ACTIVO',
      clienteId: clienteId ?? 0,
      usuarioId: userId,
    );
    final error = await repo.createPrestamo(prestamo);
    setState(() {
      isLoading = false;
    });
    if (error == null) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 6),
        ),
      );
      setState(() {
        errorMessage = error;
      });
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
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
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
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
                              decoration: const InputDecoration(
                                labelText: 'Código (auto)',
                              ),
                              initialValue:
                                  'PRE-${DateTime.now().millisecondsSinceEpoch}',
                              readOnly: true,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _montoController,
                              decoration: const InputDecoration(
                                labelText: 'Monto (COP)',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) =>
                                  v != null && double.tryParse(v.replaceAll('.', '').replaceAll(',', '')) != null
                                  ? null
                                  : 'Monto inválido',
                              onChanged: (v) {
                                String clean = v.replaceAll('.', '').replaceAll(',', '');
                                double? value = double.tryParse(clean);
                                if (value != null) {
                                  monto = value.toString();
                                  String formatted = value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
                                  _montoController.value = TextEditingValue(
                                    text: formatted,
                                    selection: TextSelection.collapsed(offset: formatted.length),
                                  );
                                } else {
                                  monto = '';
                                }
                              },
                            ),
                            const SizedBox(height: 18),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Tasa (%)',
                              ),
                              value: tasa.isNotEmpty ? tasa : null,
                              items: List.generate(100, (i) => DropdownMenuItem(
                                value: (i + 1).toString(),
                                child: Text('${i + 1}%'),
                              )),
                              onChanged: (v) => setState(() { tasa = v ?? ''; }),
                              validator: (v) => v != null ? null : 'Seleccione la tasa',
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Plazo (días)',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) =>
                                  v != null && int.tryParse(v) != null
                                  ? null
                                  : 'Plazo inválido',
                              onChanged: (v) => plazoDias = v,
                            ),
                            const SizedBox(height: 18),
                            GestureDetector(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: fechaInicio ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() {
                                    fechaInicio = picked;
                                    _fechaController.text = _formatearFecha(
                                      picked,
                                    );
                                  });
                                }
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _fechaController,
                                  decoration: const InputDecoration(
                                    labelText: 'Fecha de inicio (dd/MM/yyyy)',
                                  ),
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Campo requerido'
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            // Estado se maneja internamente
                            FutureBuilder<List<ClienteModel>>(
                              future: ClienteRepository(
                                ApiService(
                                  baseUrl: 'https://prestamos-bk.onrender.com',
                                ),
                              ).getClientes(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                final clientesList = snapshot.data!;
                                return DropdownButtonFormField<int>(
                                  decoration: const InputDecoration(
                                    labelText: 'Cliente',
                                  ),
                                  value: clienteId,
                                  items: clientesList
                                      .map(
                                        (c) => DropdownMenuItem(
                                          value: c.id,
                                          child: Text(
                                            '${c.nombres} ${c.apellidos} (${c.identificacion})',
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) => setState(() {
                                    clienteId = v;
                                  }),
                                  validator: (v) => v != null
                                      ? null
                                      : 'Seleccione un cliente',
                                );
                              },
                            ),
                            const SizedBox(height: 18),
                            // UsuarioId se maneja internamente
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      // El mensaje de error ahora solo se muestra como SnackBar flotante
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C853),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: isLoading ? null : _crearPrestamo,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
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
