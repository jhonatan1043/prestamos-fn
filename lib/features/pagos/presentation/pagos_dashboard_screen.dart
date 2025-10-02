import 'package:flutter/material.dart';

class PagosDashboardScreen extends StatelessWidget {
  const PagosDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Pagos'),
        backgroundColor: const Color(0xFF00C853),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DashboardCard(
              title: 'Historial de Pagos',
              icon: Icons.history,
              color: Colors.blueAccent,
              onTap: () => Navigator.pushNamed(context, '/pagos_historial'),
            ),
            const SizedBox(height: 18),
            _DashboardCard(
              title: 'Pagos en Mora (+30 días)',
              icon: Icons.warning,
              color: Colors.redAccent,
              onTap: () => Navigator.pushNamed(context, '/pagos_mora'),
            ),
            const SizedBox(height: 18),
            _DashboardCard(
              title: 'Reportar Pago',
              icon: Icons.payment,
              color: Colors.green,
              onTap: () => Navigator.pushNamed(context, '/pagos_reportar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
