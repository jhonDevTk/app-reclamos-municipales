import 'package:flutter/material.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() =>
      _NotificacionesScreenState();
}

class _NotificacionesScreenState
    extends State<NotificacionesScreen> {

  final Color azul = const Color(0xFF123D69);

  final List<Map<String, dynamic>> notificaciones = [
    {
      'titulo': 'Nuevo Reclamo Registrado',
      'mensaje': 'Su reclamo #RM-20261025-01 ha sido asignado.',
      'hora': 'Hace 5 min',
      'icono': Icons.notifications,
      'color': Colors.amber,
      'leida': false,
    },
    {
      'titulo': 'Alerta de Corte de Agua',
      'mensaje': 'Mañana corte programado en SJL a las 8 AM.',
      'hora': 'Hoy, 3:15 PM',
      'icono': Icons.warning,
      'color': Colors.red,
      'leida': false,
    },
    {
      'titulo': 'Actualización de Estado',
      'mensaje': 'Reclamo #RM-20261025-01 ahora está En Proceso.',
      'hora': 'Hoy, 3:15 PM',
      'icono': Icons.info,
      'color': Colors.blue,
      'leida': false,
    },
    {
      'titulo': 'Recordatorio Municipal',
      'mensaje': 'Revisa los horarios de atención municipal.',
      'hora': 'Hoy, 1:40 PM',
      'icono': Icons.notifications,
      'color': Colors.amber,
      'leida': false,
    },
    {
      'titulo': 'Servicio de Atención',
      'mensaje': 'Tenemos canales digitales disponibles para consultas.',
      'hora': 'Ayer',
      'icono': Icons.info,
      'color': Colors.blue,
      'leida': true,
    },
  ];

  int get noLeidas =>
      notificaciones.where((n) => !n['leida']).length;

  void marcarTodasLeidas() {
    setState(() {
      for (var notificacion in notificaciones) {
        notificacion['leida'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todas las notificaciones fueron leídas.'),
      ),
    );
  }

  void marcarLeida(int index) {
    setState(() {
      notificaciones[index]['leida'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FA),

      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
        // Botón de retroceso añadido para volver al menú o pantalla anterior
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Certus Municipal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            const Text(
              'Notificaciones y Alertas',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123D69),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Consulta los avisos municipales y las actualizaciones de tus reclamos.',
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 22),

            Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'Mis notificaciones',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF123D69),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Tienes $noLeidas notificaciones sin leer',
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 15),

                    ...List.generate(
                      notificaciones.length,
                      (index) => construirNotificacion(index),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: noLeidas > 0
                            ? marcarTodasLeidas
                            : null,

                        icon: const Icon(Icons.done_all),

                        label: const Text(
                          'MARCAR TODAS COMO LEÍDAS',
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: azul,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            Card(
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'Resumen de avisos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF123D69),
                      ),
                    ),

                    const SizedBox(height: 12),

                    resumen('Total de notificaciones',
                        notificaciones.length),

                    resumen('Sin leer', noLeidas),

                    resumen(
                      'Leídas',
                      notificaciones.length - noLeidas,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            Card(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(
                  Icons.help_outline,
                  color: Color(0xFF123D69),
                ),
                title: const Text('¿Necesitas ayuda?'),
                subtitle: const Text(
                  'Comunícate con atención al vecino.',
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Atención al vecino'),
                      content: const Text(
                        'Puedes comunicarte mediante la mesa de partes, '
                        'central telefónica o plataforma web municipal.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget construirNotificacion(int index) {
    final n = notificaciones[index];

    return GestureDetector(
      onTap: () => marcarLeida(index),

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: n['leida']
              ? Colors.white
              : const Color(0xFFF3FBFC),

          borderRadius: BorderRadius.circular(14),

          border: Border.all(
            color: n['leida']
                ? Colors.grey.shade200
                : const Color(0xFF75D5D3),
          ),
        ),

        child: Row(
          children: [

            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (n['color'] as Color).withOpacity(0.15),
                borderRadius: BorderRadius.circular(13),
              ),

              child: Icon(
                n['icono'] as IconData,
                color: n['color'] as Color,
                size: 27,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    n['titulo'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    n['mensaje'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    n['hora'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            if (!n['leida'])
              const Icon(
                Icons.circle,
                size: 9,
                color: Color(0xFF35B8B5),
              ),
          ],
        ),
      ),
    );
  }

  Widget resumen(String titulo, int cantidad) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo),
          Text(
            cantidad.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF123D69),
            ),
          ),
        ],
      ),
    );
  }
}