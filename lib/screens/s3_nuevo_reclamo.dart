import 'package:flutter/material.dart';
import 's4_mapa.dart'; // Asegúrate de que apunte a tu pantalla de mapa correcta

class NuevoReclamoScreen extends StatefulWidget {
  const NuevoReclamoScreen({super.key});

  @override
  State<NuevoReclamoScreen> createState() => _NuevoReclamoScreenState();
}

class _NuevoReclamoScreenState extends State<NuevoReclamoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  String? _categoria;
  String _ubicacion = 'No seleccionada';

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // Abrir la ventana de selección de ubicación
  Future<void> _seleccionarUbicacion() async {
    final resultado = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const MapaScreen(),
      ),
    );

    if (!mounted) return;

    if (resultado != null) {
      setState(() {
        _ubicacion = resultado;
      });
    }
  }

  // Validar y mostrar resumen del reclamo
  Future<void> _registrarReclamo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_ubicacion == 'No seleccionada') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes seleccionar la ubicación del reclamo',
          ),
        ),
      );
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar reclamo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Revisa los datos antes de confirmar:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                const Text(
                  'Título:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_tituloController.text.trim()),

                const SizedBox(height: 10),

                const Text(
                  'Categoría:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_categoria ?? ''),

                const SizedBox(height: 10),

                const Text(
                  'Descripción:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_descripcionController.text.trim()),

                const SizedBox(height: 10),

                const Text(
                  'Ubicación:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_ubicacion),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Editar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmar != true) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reclamo confirmado correctamente'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Reclamo', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF123D69),
        foregroundColor: Colors.white,
        // Botón de retroceso añadido para volver al menú o pantalla anterior
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Registrar un reclamo',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF123D69),
                ),
              ),

              const SizedBox(height: 20),

              // Título del reclamo
              const Text('Título del reclamo', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  hintText: 'Ej. Alumbrado público dañado',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el título';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Categoría del reclamo
              const Text('Categoría', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                initialValue: _categoria,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Selecciona una categoría',
                  prefixIcon: Icon(Icons.category),
                ),
                items: [
                  'Alumbrado público',
                  'Limpieza pública',
                  'Pistas y veredas',
                  'Seguridad ciudadana',
                  'Áreas verdes',
                  'Otros',
                ].map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categoria = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecciona una categoría';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Descripción del reclamo
              const Text('Descripción', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              TextFormField(
                controller: _descripcionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Describe el problema...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa una descripción';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Selección de ubicación
              const Text('Ubicación del reclamo', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              OutlinedButton.icon(
                onPressed: _seleccionarUbicacion,
                icon: const Icon(Icons.location_on),
                label: const Text(
                  'Seleccionar ubicación en el mapa',
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Ubicación: $_ubicacion',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 28),

              // Botón para registrar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _registrarReclamo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF123D69),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Registrar reclamo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}