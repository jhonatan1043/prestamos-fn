import 'package:flutter/material.dart';
import '../data/pago_repository.dart';
import '../data/pago_model.dart';
import '../../clientes/data/cliente_repository.dart';
import '../../../core/network/api_service.dart';

class PagosReportarScreen extends StatelessWidget {
  const PagosReportarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clienteRepo = ClienteRepository(ApiService(baseUrl: 'https://prestamos-bk.onrender.com'));
    final pagoRepo = PagoRepository(ApiService(baseUrl: 'https://prestamos-bk.onrender.com'));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar Pago'),
        backgroundColor: const Color(0xFF00C853),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ClienteModel>>(
        future: clienteRepo.getClientes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final clientes = snapshot.data!;
          if (clientes.isEmpty) {
            return const Center(child: Text('No hay clientes registrados.'));
          }
          return ListView.builder(
            itemCount: clientes.length,
            itemBuilder: (context, index) {
              final cliente = clientes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Color(0xFF00C853)),
                  title: Text('${cliente.nombres} ${cliente.apellidos}'),
                  subtitle: Text('ID: ${cliente.identificacion}'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Ver pagos'),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) => _PagosTabla(cliente: cliente, pagoRepo: pagoRepo),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _PagosTabla extends StatelessWidget {
  final ClienteModel cliente;
  final PagoRepository pagoRepo;
  const _PagosTabla({required this.cliente, required this.pagoRepo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PagoModel>>(
      future: pagoRepo.getAllPagos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final pagos = snapshot.data!.where((p) => p.prestamoId == cliente.id).toList();
        // Simulación de cuotas: 12 cuotas de 1000 cada una
        final cuotaFija = 1000.0;
        final cuotas = List.generate(12, (i) => i + 1);
        // Algoritmo para aplicar abonos extra
        List<double> pagosPorCuota = List.filled(cuotas.length, 0);
        int pagoIndex = 0;
        for (var pago in pagos) {
          double monto = pago.monto;
          while (monto > 0 && pagoIndex < cuotas.length) {
            final restante = cuotaFija - pagosPorCuota[pagoIndex];
            if (monto >= restante) {
              pagosPorCuota[pagoIndex] += restante;
              monto -= restante;
              pagoIndex++;
            } else {
              pagosPorCuota[pagoIndex] += monto;
              monto = 0;
            }
          }
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Pagos de ${cliente.nombres} ${cliente.apellidos}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text('Cuota')),
                    const DataColumn(label: Text('Estado')),
                    const DataColumn(label: Text('Pagado')),
                  ],
                  rows: List.generate(cuotas.length, (i) {
                    final pagado = pagosPorCuota[i] >= cuotaFija;
                    return DataRow(cells: [
                      DataCell(Text('Cuota ${i + 1}')),
                      DataCell(
                        pagado
                          ? const Icon(Icons.check, color: Colors.green)
                          : const Icon(Icons.close, color: Colors.red)
                      ),
                      DataCell(Text(pagosPorCuota[i].toStringAsFixed(2))),
                    ]);
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
