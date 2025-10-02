import 'package:flutter/material.dart';
import '../../../core/utils/token_storage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String role = 'USER';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final r = await TokenStorage.getRole();
    setState(() {
      role = r ?? 'USER';
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'ADMIN';
    final List<Widget> options = isAdmin
        ? [
            _DashboardOption(
              title: "Gestionar Usuarios",
              icon: Icons.person_add,
              onTap: () {
                Navigator.pushNamed(context, '/user_list');
              },
            ),
            _DashboardOption(
              title: "Gestionar Clientes",
              icon: Icons.group_add,
              onTap: () {
                Navigator.pushNamed(context, '/cliente_list');
              },
            ),
            _DashboardOption(
              title: "Gestionar Préstamos",
              icon: Icons.account_balance,
              onTap: () {
                Navigator.pushNamed(context, '/prestamo_list');
              },
            ),
            _DashboardOption(
              title: "Pagos",
              icon: Icons.payment,
              onTap: () {
                Navigator.pushNamed(context, '/pagos_dashboard');
              },
            ),
            _DashboardOption(
              title: "Reportes",
              icon: Icons.bar_chart,
              onTap: () {
                // Acción para reportes
              },
            ),
          ]
        : [
            _DashboardOption(
              title: "Pagos",
              icon: Icons.payment,
              onTap: () {
                Navigator.pushNamed(context, '/pagos_dashboard');
              },
            ),
          ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Plataforma de Préstamos",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color(0xFF388E3C),
        elevation: 8,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle, size: 28, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'perfil',
                child: ListTile(
                  leading: Icon(Icons.person, color: Color(0xFF388E3C)),
                  title: Text('Ver perfil'),
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout, color: Color(0xFF388E3C)),
                  title: Text('Cerrar sesión'),
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'perfil') {
                Navigator.pushNamed(context, '/profile');
              } else if (value == 'logout') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('¿Salir?'),
                    content: const Text('¿Estás seguro que deseas salir de la sesión?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Salir'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await TokenStorage.clearToken();
                  Navigator.pushReplacementNamed(context, '/login');
                }
              }
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: options,
            ),
    );
  }
}

/// Clase separada (fuera del State)
class _DashboardOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardOption({
    required this.title,
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Icon(icon, size: 40, color: _getCardColor(title)),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: _getCardColor(title),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCardColor(String title) {
    switch (title.toLowerCase()) {
      case 'Gestionar Usuarios':
        return Colors.blue;
      case 'Gestionar Clientes':
        return Colors.green;
      case 'Gestionar Préstamos':
        return Colors.orange;
      case 'pagos':
        return Colors.purple;
      case 'Reportes':
        return Colors.red;
      default:
        return const Color(0xFF388E3C);
    }
  }
}
