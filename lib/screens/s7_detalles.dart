import 'package:flutter/material.dart';

import 's3_nuevo_reclamo.dart';
import 's4_mapa.dart';
import 's5_lista_reclamos.dart';
import 's6_filtros.dart';
import 's8_actualizar.dart';
import 's9_notificaciones.dart';
import 's10_perfil.dart';

// PANTALLA 7: Detalle del Reclamo
class DetallesScreen extends StatelessWidget {
  const DetallesScreen({super.key});

  void _irAVentana(BuildContext context, String ruta) {
    Widget destino;
    switch (ruta) {
      case 's3':
        destino = const NuevoReclamoScreen();
        break;
      case 's4':
        destino = const MapaScreen();
        break;
      case 's5':
        destino = const ListaReclamosScreen();
        break;
      case 's6':
        destino = const FiltrosScreen();
        break;
      case 's8':
        destino = const ActualizarScreen();
        break;
      case 's9':
        destino = const NotificacionesScreen();
        break;
      case 's10':
        destino = const PerfilScreen();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => destino),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Reclamo'),
        backgroundColor: const Color(0xFF2E2463),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Vuelve a la pantalla anterior / menú de pruebas
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            color: const Color(0xFFF0F8FA),
            onSelected: (ruta) => _irAVentana(context, ruta),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 's3', child: Text('3. Nuevo Reclamo')),
              PopupMenuItem(value: 's4', child: Text('4. Mapa')),
              PopupMenuItem(value: 's5', child: Text('5. Lista de Reclamos')),
              PopupMenuItem(value: 's6', child: Text('6. Filtros')),
              PopupMenuItem(value: 's8', child: Text('8. Actualizar')),
              PopupMenuItem(value: 's9', child: Text('9. Notificaciones')),
              PopupMenuItem(value: 's10', child: Text('10. Perfil')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarjeta de ID y Estado
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'ID RECLAMO: #RM-20261025-01',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE082),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'REGISTRADO',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Tarjeta de Información General
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'INFORMACIÓN GENERAL',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 6),
                    Text(
                      'Fecha de Registro: 25/10/2026',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Ubicación: Calle Tulipanes 345, SJL',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Icon(
                          Icons.location_on,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Asunto: Alumbrado Público Defectuoso',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Tarjeta de Descripción del Vecino
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'DESCRIPCIÓN DEL VECINO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 6),
                    Text(
                      'El poste de luz en la esquina no funciona desde hace tres días. La calle está muy oscura de noche.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Tarjeta de Evidencia Fotográfica
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EVIDENCIA FOTOGRÁFICA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 90,
                        width: 120,
                        color: Colors.black87,
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Tarjeta de Historial de Estados
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'HISTORIAL DE ESTADOS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text(
                        '25/10/2026 - Registrado',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.radio_button_unchecked,
                        color: Colors.grey,
                      ),
                      title: Text(
                        'En proceso de asignación',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.radio_button_unchecked,
                        color: Colors.grey,
                      ),
                      title: Text(
                        'Solucionado',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: const Color(0xFF2E2463),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Trámites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem),
            label: 'Reclamos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mi Perfil',
          ),
        ],
      ),
    );
  }
}