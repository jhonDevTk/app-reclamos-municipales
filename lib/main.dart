import 'package:flutter/material.dart';

// Importamos todas las ventanas ordenadas por nombres s1, s2...
import 'screens/s1_login.dart';
import 'screens/s2_registro.dart';
import 'screens/s3_nuevo_reclamo.dart';
import 'screens/s4_mapa.dart';
import 'screens/s5_lista_reclamos.dart';
import 'screens/s6_filtros.dart';
import 'screens/s7_detalles.dart';
import 'screens/s8_actualizar.dart';
import 'screens/s9_notificaciones.dart';
import 'screens/s10_perfil.dart';

void main() {
  runApp(const AppMunicipal());
}

class AppMunicipal extends StatelessWidget {
  const AppMunicipal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Reclamos Municipales',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // Arrancamos en el Menú de Pruebas para visualizar y controlar las 10 ventanas
      home: const MenuPruebasScreen(),
    );
  }
}

class MenuPruebasScreen extends StatelessWidget {
  const MenuPruebasScreen({super.key});

  // Mismos colores de la ventana S5 (Lista de reclamos)
  static const Color azulBarra = Color(0xFF0058AA);
  static const Color azulChip = Color(0xFF066AC6);
  static const Color fondo = Color(0xFFF3F8FE);
  static const Color azulTexto = Color(0xFF101928);
  static const Color grisTexto = Color(0xFF575A61);
  static const Color colorIcono = Color(0xFF0B1A3A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azulBarra,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: const Text(
          'Reclamos Municipales',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
        children: [
          const Text(
            'Menú de ventanas',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: azulTexto,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Selecciona una ventana para revisar el avance.',
            style: TextStyle(fontSize: 14, color: grisTexto),
          ),
          const SizedBox(height: 18),

          _crearTarjeta(context, '1', 'Login', 'Inicio de sesión',
              Icons.login, const LoginScreen()),
          _crearTarjeta(context, '2', 'Registro', 'Crear una cuenta nueva',
              Icons.person_add_alt_1, const RegistroScreen()),
          _crearTarjeta(context, '3', 'Nuevo Reclamo',
              'Registrar un reclamo', Icons.edit_note,
              const NuevoReclamoScreen()),
          _crearTarjeta(context, '4', 'Mapa', 'Seleccionar ubicación',
              Icons.map_outlined, const MapaScreen()),
          _crearTarjeta(context, '5', 'Lista de Reclamos', 'Mis reclamos',
              Icons.list_alt, const ListaReclamosScreen()),
          _crearTarjeta(context, '6', 'Filtros', 'Filtrar reclamos',
              Icons.filter_alt_outlined, const FiltrosScreen()),
          _crearTarjeta(context, '7', 'Detalles', 'Detalle de un reclamo',
              Icons.description_outlined, const DetallesScreen()),
          _crearTarjeta(context, '8', 'Actualizar', 'Actualizar estado',
              Icons.update, const ActualizarScreen()),
          _crearTarjeta(context, '9', 'Notificaciones', 'Avisos y alertas',
              Icons.notifications_none, const NotificacionesScreen()),
          _crearTarjeta(context, '10', 'Perfil', 'Datos del usuario',
              Icons.person_outline, const PerfilScreen()),
        ],
      ),
    );
  }

  Widget _crearTarjeta(
    BuildContext context,
    String numero,
    String titulo,
    String subtitulo,
    IconData icono,
    Widget pantallaDestino,
  ) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 69, 191, 219),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 186, 108, 77)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(13, 154, 56, 56),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pantallaDestino),
          );
        },
        child: Row(
          children: [
            // Icono dentro de un recuadro suave
            Container(
              width: 46,
              height: 46,
              margin: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F0FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icono, size: 26, color: colorIcono),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$numero. $titulo',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: azulTexto,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitulo,
                    style: const TextStyle(fontSize: 13, color: grisTexto),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 34,
              child: Icon(
                Icons.chevron_right,
                size: 28,
                color: Color(0xFF1A2233),
              ),
            ),
          ],
        ),
      ),
    );
  }
}