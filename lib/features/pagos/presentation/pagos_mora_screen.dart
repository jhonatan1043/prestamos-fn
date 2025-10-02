import 'package:flutter/material.dart';
import '../data/pago_repository.dart';
import '../data/pago_model.dart';
import '../../../core/network/api_service.dart';

class PagosMoraScreen extends StatelessWidget {
  const PagosMoraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repo = PagoRepository(ApiService(baseUrl: 'https://prestamos-bk.onrender.com'));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos en Mora (+30 días)'),
        backgroundColor: const Color(0xFF00C853),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<PagoModel>>(
        future: repo.getAllPagos(), // TODO: Replace with repo.getPagosMora(30) if endpoint available
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final pagos = snapshot.data!;
          final pagosMora = pagos.where((p) {
            final diasMora = DateTime.now().difference(p.fecha).inDays;
            return diasMora > 30;
          }).toList();
          if (pagosMora.isEmpty) {
            return const Center(child: Text('No hay pagos en mora por más de 30 días.'));
          }
          return ListView.builder(
            itemCount: pagosMora.length,
            itemBuilder: (context, index) {
              final pago = pagosMora[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: Text('Préstamo ID: ${pago.prestamoId}'),
                  subtitle: Text('Fecha: ${pago.fecha.toLocal().toString().split(' ')[0]}\nMonto: ${pago.monto}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
