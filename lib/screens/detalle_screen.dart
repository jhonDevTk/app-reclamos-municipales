import 'package:flutter/material.dart';

class DetalleScreen extends StatelessWidget {
  const DetalleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Reclamo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Reclamo #001 - Alumbrado Público', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Descripción: Farola rota en la esquina de la av. principal.'),
            SizedBox(height: 20),
            Text('Historial de Estados:', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Registrado'),
              subtitle: Text('26/10/2026 - 10:00 AM'),
            ),
            ListTile(
              leading: Icon(Icons.hourglass_empty, color: Colors.orange),
              title: Text('En revisión por la municipalidad'),
              subtitle: Text('27/10/2026 - 08:30 AM'),
            ),
          ],
        ),
      ),
    );
  }
}
