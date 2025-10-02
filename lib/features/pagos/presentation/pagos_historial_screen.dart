import 'package:flutter/material.dart';
import '../data/pago_repository.dart';
import '../data/pago_model.dart';
import '../../../core/network/api_service.dart';

class PagosHistorialScreen extends StatelessWidget {
  const PagosHistorialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repo = PagoRepository(ApiService(baseUrl: 'https://prestamos-bk.onrender.com'));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Pagos'),
        backgroundColor: const Color(0xFF00C853),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<PagoModel>>(
        future: repo.getAllPagos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final pagos = snapshot.data!;
          if (pagos.isEmpty) {
            return const Center(child: Text('No hay pagos registrados.'));
          }
          return ListView.builder(
            itemCount: pagos.length,
            itemBuilder: (context, index) {
              final pago = pagos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
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
