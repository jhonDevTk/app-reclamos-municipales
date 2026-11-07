import 'package:flutter/material.dart';

class ActualizarScreen extends StatefulWidget {
  const ActualizarScreen({super.key});

  @override
  State<ActualizarScreen> createState() => _ActualizarScreenState();
}

class _ActualizarScreenState extends State<ActualizarScreen> {
  String _estadoSeleccionado = 'En revisión';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actualizar Estado (Municipalidad)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Cambiar estado del reclamo:', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: _estadoSeleccionado,
              items: ['Registrado', 'En revisión', 'En proceso', 'Solucionado']
                  .map((estado) => DropdownMenuItem(
                        value: estado,
                        child: Text(estado),
                      ))
                  .toList(),
              onChanged: (nuevoEstado) {
                setState(() {
                  _estadoSeleccionado = nuevoEstado!;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Comentario o respuesta para el vecino',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para guardar la actualización
              },
              child: const Text('Guardar y Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
