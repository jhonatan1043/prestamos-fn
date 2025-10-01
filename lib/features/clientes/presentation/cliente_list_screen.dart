import 'package:flutter/material.dart';
import '../data/cliente_repository.dart';
import '../../../core/network/api_service.dart';
import 'cliente_edit_screen.dart';


class ClienteListScreen extends StatefulWidget {
  const ClienteListScreen({Key? key}) : super(key: key);

  @override
  State<ClienteListScreen> createState() => _ClienteListScreenState();
}

class _ClienteListScreenState extends State<ClienteListScreen> {
  List<ClienteModel> clientes = [];
  List<ClienteModel> filteredClientes = [];
  bool isLoading = true;
  String? errorMessage;
  late ClienteRepository clienteRepo;
  String searchText = '';
  // Paginación
  int currentPage = 1;
  int pageSize = 10;

  Future<void> _eliminarCliente(int index) async {
    final cliente = clientes[index];
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar cliente?'),
        content: const Text('¿Estás seguro que deseas eliminar este cliente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() { isLoading = true; });
      final error = await clienteRepo.deleteCliente(cliente.identificacion);
      if (error == null) {
        await _fetchClientes();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cliente eliminado')));
      } else {
        setState(() { errorMessage = error; });
      }
      setState(() { isLoading = false; });
    }
  }

  Future<void> _editarCliente(int index) async {
    final cliente = clientes[index];
    final nombresController = TextEditingController(text: cliente.nombres);
    final apellidosController = TextEditingController(text: cliente.apellidos);
    final direccionController = TextEditingController(text: cliente.direccion);
    final telefonoController = TextEditingController(text: cliente.telefono.toString());
    final edadController = TextEditingController(text: cliente.edad.toString());
    final tipoIdController = TextEditingController(text: cliente.tipoIdentificacion);
    final identificacionController = TextEditingController(text: cliente.identificacion);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar cliente'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: tipoIdController,
                decoration: const InputDecoration(labelText: 'Tipo de Identificación'),
              ),
              TextField(
                controller: identificacionController,
                decoration: const InputDecoration(labelText: 'Identificación'),
              ),
              TextField(
                controller: nombresController,
                decoration: const InputDecoration(labelText: 'Nombres'),
              ),
              TextField(
                controller: apellidosController,
                decoration: const InputDecoration(labelText: 'Apellidos'),
              ),
              TextField(
                controller: direccionController,
                decoration: const InputDecoration(labelText: 'Dirección'),
              ),
              TextField(
                controller: telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: edadController,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() { isLoading = true; });
      final updated = ClienteModel(
        tipoIdentificacion: tipoIdController.text,
        identificacion: identificacionController.text,
        nombres: nombresController.text,
        apellidos: apellidosController.text,
        direccion: direccionController.text,
        telefono: telefonoController.text,
        edad: int.tryParse(edadController.text) ?? 0,
      );
      final error = await clienteRepo.updateCliente(updated.identificacion, updated);
      if (error == null) {
        await _fetchClientes();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cliente actualizado')));
      } else {
        setState(() { errorMessage = error; });
      }
      setState(() { isLoading = false; });
    }
  }

  Future<void> _crearCliente() async {
    // Aquí podrías mostrar un formulario similar al de editar, o navegar a una pantalla de creación
    // Para simplicidad, aquí se muestra un formulario en un dialog
    final tipoIdController = TextEditingController();
    final identificacionController = TextEditingController();
    final nombresController = TextEditingController();
    final apellidosController = TextEditingController();
    final direccionController = TextEditingController();
    final telefonoController = TextEditingController();
    final edadController = TextEditingController();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Crear cliente'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: tipoIdController,
                decoration: const InputDecoration(labelText: 'Tipo de Identificación'),
              ),
              TextField(
                controller: identificacionController,
                decoration: const InputDecoration(labelText: 'Identificación'),
              ),
              TextField(
                controller: nombresController,
                decoration: const InputDecoration(labelText: 'Nombres'),
              ),
              TextField(
                controller: apellidosController,
                decoration: const InputDecoration(labelText: 'Apellidos'),
              ),
              TextField(
                controller: direccionController,
                decoration: const InputDecoration(labelText: 'Dirección'),
              ),
              TextField(
                controller: telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: edadController,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() { isLoading = true; });
      final nuevo = ClienteModel(
        tipoIdentificacion: tipoIdController.text,
        identificacion: identificacionController.text,
        nombres: nombresController.text,
        apellidos: apellidosController.text,
        direccion: direccionController.text,
        telefono: telefonoController.text,
        edad: int.tryParse(edadController.text) ?? 0,
      );
      final error = await clienteRepo.createCliente(nuevo);
      if (error == null) {
        await _fetchClientes();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cliente creado')));
      } else {
        setState(() { errorMessage = error; });
      }
      setState(() { isLoading = false; });
    }
  }
  void _filterClientes() {
    setState(() {
      if (searchText.isEmpty) {
        filteredClientes = clientes;
      } else {
        filteredClientes = clientes.where((c) =>
          c.nombres.toLowerCase().contains(searchText.toLowerCase()) ||
          c.apellidos.toLowerCase().contains(searchText.toLowerCase()) ||
          c.identificacion.toLowerCase().contains(searchText.toLowerCase())
        ).toList();
      }
      currentPage = 1;
    });
  }

  Future<void> _fetchClientes() async {
    setState(() { isLoading = true; errorMessage = null; });
    final list = await clienteRepo.getClientes();
    clientes = list;
    _filterClientes();
    setState(() { isLoading = false; });
  }

  @override
  void initState() {
    super.initState();
    clienteRepo = ClienteRepository(ApiService(baseUrl: 'https://prestamos-bk.onrender.com'));
    _fetchClientes();
  }

  @override
  Widget build(BuildContext context) {
    // Calcular paginación
    final totalItems = filteredClientes.length;
    final totalPages = (totalItems / pageSize).ceil();
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = (startIndex + pageSize) > totalItems ? totalItems : (startIndex + pageSize);
    final pageClientes = filteredClientes.sublist(startIndex, endIndex);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
        backgroundColor: const Color(0xFF00C853),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
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
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredClientes.isEmpty
                  ? const Center(child: Text('No hay clientes registrados'))
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Buscar por nombre, apellido o identificación',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              searchText = value;
                              _filterClientes();
                            },
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: pageClientes.length,
                            itemBuilder: (context, index) {
                              final cliente = pageClientes[index];
                              final realIndex = startIndex + index;
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: ListTile(
                                  leading: const Icon(Icons.person, color: Color(0xFF00C853)),
                                  title: Text('${cliente.nombres} ${cliente.apellidos}'),
                                  subtitle: Text('ID: ${cliente.identificacion}\nTel: ${cliente.telefono}\nEdad: ${cliente.edad}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.orange),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ClienteEditScreen(cliente: cliente),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _eliminarCliente(realIndex),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (totalPages > 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: currentPage > 1
                                      ? () => setState(() { currentPage--; })
                                      : null,
                                ),
                                Text('Página $currentPage de $totalPages'),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: currentPage < totalPages
                                      ? () => setState(() { currentPage++; })
                                      : null,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00C853),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, '/cliente_register');
        },
        tooltip: 'Crear cliente',
      ),
    );
  }
}
