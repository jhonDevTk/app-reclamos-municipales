import 'package:flutter/material.dart';

import 's3_nuevo_reclamo.dart';
import 's4_mapa.dart';
import 's5_lista_reclamos.dart';
import 's6_filtros.dart';
import 's7_detalles.dart';
import 's9_notificaciones.dart';
import 's10_perfil.dart';

// PANTALLA 8: Actualizar Estado del Reclamo
class ActualizarScreen extends StatefulWidget {
  const ActualizarScreen({super.key});

  @override
  State<ActualizarScreen> createState() => _ActualizarScreenState();
}

class _ActualizarScreenState extends State<ActualizarScreen> {
  String _estadoSeleccionado = 'En Proceso';
  final List<String> _estados = [
    'Registrado',
    'En Proceso',
    'En Atención',
    'Solucionado',
    'Derivado'
  ];

  final TextEditingController _observacionesController = TextEditingController(
    text: 'El técnico inspeccionó el poste; se requiere cambio de bombilla de repuesto.',
  );

  void _irAVentana(String ruta) {
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
      case 's7':
        destino = const DetallesScreen();
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
        title: const Text('Actualizar Estado'),
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
            onSelected: _irAVentana,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 's3', child: Text('3. Nuevo Reclamo')),
              PopupMenuItem(value: 's4', child: Text('4. Mapa')),
              PopupMenuItem(value: 's5', child: Text('5. Lista de Reclamos')),
              PopupMenuItem(value: 's6', child: Text('6. Filtros')),
              PopupMenuItem(value: 's7', child: Text('7. Detalles')),
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
            // Tarjeta de Información del Reclamo
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
                      'ID RECLAMO: #RM-20261025-01',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC8E6C9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Reclamos Municipales',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Alumbrado Público Defectuoso',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Calle Tulipanes 345',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Selector de Nuevo Estado
            const Text(
              'Seleccionar Nuevo Estado',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _estadoSeleccionado,
                  isExpanded: true,
                  items: _estados.map((String estado) {
                    return DropdownMenuItem<String>(
                      value: estado,
                      child: Text(
                        estado,
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? nuevoValor) {
                    if (nuevoValor != null) {
                      setState(() {
                        _estadoSeleccionado = nuevoValor;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de Observaciones
            const Text(
              'Observaciones y Notas (Opcional)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _observacionesController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Botón Guardar Cambios
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF103456),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {
                // Acción al guardar cambios (vuelve o muestra aviso)
                Navigator.pop(context);
              },
              child: const Text(
                'GUARDAR CAMBIOS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 1,
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
            label: 'Mis Reclamos',
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