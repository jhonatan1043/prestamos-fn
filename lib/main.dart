import 'package:flutter/material.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/user/presentation/register_screen.dart';
import 'features/home/presentation/dashboard_screen.dart';
import 'features/user/presentation/user_list_screen.dart';
import 'features/user/presentation/profile_screen.dart';
import 'features/clientes/presentation/cliente_list_screen.dart';
import 'features/clientes/presentation/cliente_register_screen.dart';
import 'features/prestamos/presentation/prestamo_list_screen.dart';
import 'features/prestamos/presentation/prestamo_create_screen.dart';
import 'features/pagos/presentation/pagos_dashboard_screen.dart';
import 'features/pagos/presentation/pagos_historial_screen.dart';
import 'features/pagos/presentation/pagos_mora_screen.dart';
import 'features/pagos/presentation/pagos_reportar_screen.dart';
import 'core/utils/session_manager.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const PrestamosApp());
}

class PrestamosApp extends StatelessWidget {
  const PrestamosApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Préstamos',
      navigatorKey: SessionManager().navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C853), // Verde vibrante
          brightness: Brightness.light,
          primary: const Color(0xFF00C853),
          secondary: const Color(0xFF00E676), // Verde claro
          surface: const Color(0xFFF5F5F5),
          background: const Color(0xFFE8F5E9),
          error: const Color(0xFFD32F2F),
        ),
        scaffoldBackgroundColor: const Color(0xFFE8F5E9),
        cardColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00C853),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Color(0xFFF5F5F5),
        ),
        textTheme: GoogleFonts.montserratTextTheme().copyWith(
          headlineSmall: GoogleFonts.montserrat(
            color: const Color(0xFF00C853),
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/prestamo_list': (context) => const PrestamoListScreen(),
        '/prestamo_create': (context) => const PrestamoCreateScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const Placeholder(),
        '/dashboard': (context) => const DashboardScreen(),
        '/user_list': (context) => const UserListScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/cliente_list': (context) => const ClienteListScreen(),
        '/cliente_register': (context) => const ClienteRegisterScreen(),
        '/cliente_edit': (context) => throw UnimplementedError('Use Navigator.push with arguments for ClienteEditScreen'),
        // Pagos screens
        '/pagos_dashboard': (context) => const PagosDashboardScreen(),
        '/pagos_historial': (context) => const PagosHistorialScreen(),
        '/pagos_mora': (context) => const PagosMoraScreen(),
        '/pagos_reportar': (context) => const PagosReportarScreen(),
      },
    );
  }
}
// ...existing code...
