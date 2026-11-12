import 'package:flutter/material.dart';
import 's6_filtros.dart';
import 's7_detalles.dart';

// PANTALLA 5: Lista de reclamos ("Mis Reclamos")
class ListaReclamosScreen extends StatefulWidget {
  const ListaReclamosScreen({super.key});

  @override
  State<ListaReclamosScreen> createState() => _ListaReclamosScreenState();
}

class _ListaReclamosScreenState extends State<ListaReclamosScreen> {
  // Colores sacados del diseño
  static const Color azulBarra = Color(0xFF0058AA);
  static const Color azulChip = Color(0xFF066AC6);
  static const Color fondo = Color(0xFFF3F8FE);
  static const Color azulTexto = Color(0xFF101928);
  static const Color grisTexto = Color(0xFF575A61);
  static const Color colorIcono = Color(0xFF0B1A3A);

  // Categoría seleccionada arriba
  String categoriaElegida = 'Todos';

  final List<String> categorias = [
    'Todos',
    'Alumbrado',
    'Limpieza',
    'Seguridad',
    'Vías',
    'Ruido',
  ];

  // Datos de ejemplo corregidos con su tipado completo
  final List<Map<String, String>> reclamos = [
    {
      'categoria': 'Alumbrado',
      'titulo': 'Alumbrado público',
      'direccion': 'Calle Los Pinos 123, San Isidro',
      'fecha': '14/04/2026 - 10:30 a. m.',
      'estado': 'Registrado',
    },
    {
      'categoria': 'Limpieza',
      'titulo': 'Recojo de basura',
      'direccion': 'Av. Los Ángeles 456, San Isidro',
      'fecha': '13/04/2026 - 04:15 p. m.',
      'estado': 'En atención',
    },
    {
      'categoria': 'Vías',
      'titulo': 'Pistas y veredas',
      'direccion': 'Jr. Libertad 789, San Isidro',
      'fecha': '12/04/2026 - 09:20 a. m.',
      'estado': 'Derivado',
    },
    {
      'categoria': 'Seguridad',
      'titulo': 'Seguridad ciudadana',
      'direccion': 'Parque Central, San Isidro',
      'fecha': '10/04/2026 - 06:45 p. m.',
      'estado': 'Solucionado',
    },
    {
      'categoria': 'Ruido',
      'titulo': 'Ruido',
      'direccion': 'Av. Principal 321, San Isidro',
      'fecha': '08/04/2026 - 11:10 a. m.',
      'estado': 'Cerrado',
    },
  ];

  // Icono de cada categoría
  Widget iconoCategoria(String categoria) {
    switch (categoria) {
      case 'Alumbrado':
        return const Icon(Icons.lightbulb_outline, size: 30, color: colorIcono);
      case 'Seguridad':
        return const Icon(Icons.security, size: 30, color: colorIcono);
      case 'Vías':
        return const Icon(Icons.alt_route, size: 30, color: colorIcono);
      case 'Limpieza':
        return const Icon(Icons.delete, size: 30, color: colorIcono);
      default:
        return const Icon(Icons.campaign, size: 32, color: colorIcono);
    }
  }

  // Color de fondo de la etiqueta de estado
  Color colorEstado(String estado) {
    if (estado == 'Registrado') return const Color(0xFFF8DB73);
    if (estado == 'En atención') return const Color(0xFF1588E5);
    if (estado == 'Derivado') return const Color(0xFF9965E1);
    if (estado == 'Solucionado') return const Color(0xFF0DB45A);
    return const Color(0xFFB0C4D6);
  }

  // Color del texto de la etiqueta de estado
  Color colorTextoEstado(String estado) {
    if (estado == 'Registrado') return const Color(0xFF2B2A1F);
    if (estado == 'Cerrado') return const Color(0xFF5E7388);
    return Colors.white;
  }

  // Botón redondeado de categoría
  Widget chip(String texto) {
    final elegido = categoriaElegida == texto;
    return GestureDetector(
      onTap: () => setState(() => categoriaElegida = texto),
      child: Container(
        height: 36,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: elegido ? azulChip : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: elegido ? Colors.white : const Color(0xFF1E2F4A),
          ),
        ),
      ),
    );
  }

  // Una tarjeta de reclamo
  Widget tarjeta(Map<String, String> r) {
    return Container(
      height: 111,
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE6EBF1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
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
            MaterialPageRoute(builder: (_) => const DetallesScreen()),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 55,
              height: 60,
              child: Center(child: iconoCategoria(r['categoria']!)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r['titulo']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: azulTexto,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      r['direccion']!,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: grisTexto,
                      ),
                    ),
                    Text(
                      r['fecha']!,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: grisTexto,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      height: 22,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorEstado(r['estado']!),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        r['estado']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colorTextoEstado(r['estado']!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 34,
              height: 111,
              child: Center(
                child: Icon(
                  Icons.chevron_right,
                  size: 28,
                  color: Color(0xFF1A2233),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = categoriaElegida == 'Todos'
        ? reclamos
        : reclamos.where((r) => r['categoria'] == categoriaElegida).toList();

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azulBarra,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, size: 22),
            ),
            const SizedBox(width: 6),
            const Text(
              'Mis Reclamos',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FiltrosScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [for (final cat in categorias) chip(cat)],
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              children: [for (final r in lista) tarjeta(r)],
            ),
          ),
        ],
      ),
    );
  }
}