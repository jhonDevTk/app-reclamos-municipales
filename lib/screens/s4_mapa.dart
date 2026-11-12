import 'package:flutter/material.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  String _ubicacion = 'Plaza de Armas, Lima';

  final List<String> _ubicaciones = [
    'Plaza de Armas, Lima',
    'Parque Kennedy, Miraflores',
    'Municipalidad de Surco',
    'Parque Central de Barranco',
  ];

  // Posición del marcador según la ubicación seleccionada
  Alignment get _posicionMarcador {
    switch (_ubicaciones.indexOf(_ubicacion)) {
      case 0:
        return const Alignment(-0.55, -0.50);
      case 1:
        return const Alignment(0.55, -0.50);
      case 2:
        return const Alignment(-0.55, 0.45);
      case 3:
        return const Alignment(0.55, 0.45);
      default:
        return Alignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FA),
      appBar: AppBar(
        title: const Text('Seleccionar ubicación', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF123D69),
        foregroundColor: Colors.white,
        // Botón de retroceso para volver al menú o pantalla anterior
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ubica el lugar del reclamo',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123D69),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Selecciona una ubicación de referencia en el mapa.',
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 20),

            // Mapa referencial
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 45,
                      right: 45,
                      top: 80,
                      child: Container(
                        height: 18,
                        color: Colors.white,
                      ),
                    ),

                    Positioned(
                      left: 0,
                      right: 0,
                      top: 180,
                      child: Container(
                        height: 18,
                        color: Colors.white,
                      ),
                    ),

                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 100,
                      child: Container(
                        width: 18,
                        color: Colors.white,
                      ),
                    ),

                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 90,
                      child: Container(
                        width: 18,
                        color: Colors.white,
                      ),
                    ),

                    // Marcador animado
                    AnimatedAlign(
                      alignment: _posicionMarcador,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      child: const Icon(
                        Icons.location_on,
                        size: 55,
                        color: Colors.red,
                      ),
                    ),

                    Positioned(
                      bottom: 15,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Text(
                          'Mapa referencial',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Selecciona una ubicación:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF123D69),
              ),
            ),

            const SizedBox(height: 8),

            // Lista de ubicaciones
            DropdownButtonFormField<String>(
              value: _ubicacion,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on, color: Color(0xFF123D69)),
                filled: true,
                fillColor: Colors.white,
              ),
              items: _ubicaciones.map((lugar) {
                return DropdownMenuItem<String>(
                  value: lugar,
                  child: Text(lugar),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _ubicacion = value;
                  });
                }
              },
            ),

            const SizedBox(height: 18),

            // Confirmar ubicación
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, _ubicacion);
                },
                icon: const Icon(Icons.check),
                label: const Text(
                  'Confirmar ubicación',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF123D69),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Center(
              child: Text(
                'Mapa referencial, no utiliza GPS.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}