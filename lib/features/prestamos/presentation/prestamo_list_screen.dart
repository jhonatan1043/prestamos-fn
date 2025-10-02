import 'package:flutter/material.dart';
import '../data/prestamo_repository.dart';
import '../data/prestamo_model.dart';
import '../../../core/network/api_service.dart';

class PrestamoListScreen extends StatefulWidget {
  const PrestamoListScreen({Key? key}) : super(key: key);

  @override
  State<PrestamoListScreen> createState() => _PrestamoListScreenState();
}

class _PrestamoListScreenState extends State<PrestamoListScreen> {
  List<PrestamoModel> prestamos = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPrestamos();
  }

  Future<void> _fetchPrestamos() async {
    setState(() { isLoading = true; errorMessage = null; });
    final repo = PrestamoRepository(ApiService(baseUrl: 'https://prestamos-bk.onrender.com'));
    final list = await repo.getPrestamos();
    setState(() {
      prestamos = list;
      isLoading = false;
    });
  }

  void _goToCreate() async {
    final result = await Navigator.pushNamed(context, '/prestamo_create');
    if (result == true) {
      _fetchPrestamos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Préstamos'),
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : prestamos.isEmpty
                ? const Center(child: Text('No hay préstamos registrados'))
                : ListView.builder(
                    itemCount: prestamos.length,
                    itemBuilder: (context, index) {
                      final p = prestamos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.monetization_on, color: Color(0xFF00C853)),
                          title: Text('Código: ${p.codigo}'),
                          subtitle: Text('Monto: ${p.monto}\nTasa: ${p.tasa}%\nPlazo: ${p.plazoDias} días\nEstado: ${p.estado}'),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00C853),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _goToCreate,
        tooltip: 'Nuevo préstamo',
      ),
    );
  }
}
