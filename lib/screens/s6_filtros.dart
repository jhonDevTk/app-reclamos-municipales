import 'package:flutter/material.dart';

// PANTALLA 6: Filtrar por categoría
class FiltrosScreen extends StatefulWidget {
  const FiltrosScreen({super.key});

  @override
  State<FiltrosScreen> createState() => _FiltrosScreenState();
}

class _FiltrosScreenState extends State<FiltrosScreen> {
  // Colores sacados del diseño
  static const azul = Color(0xFF123869);
  static const fondo = Color(0xFFECFAFA);
  static const fondoTile = Color(0xFFDEE7F0);

  // Interruptores
  bool alumbrado = true;
  bool limpieza = false;
  bool seguridad = true;

  // Opciones: 'Todos', 'Activo' o 'Inactivo'
  String parques = 'Activo';
  String vias = 'Activo';

  // Estados: al inicio todos están marcados
  final List<String> estados = ['Registrado', 'En Proceso', 'Solucionado', 'En espera'];
  final Map<String, Color> colorEstado = {
    'Registrado': const Color(0xFFF7D372),
    'En Proceso': const Color(0xFF33B168),
    'Solucionado': const Color(0xFF2885CB),
    'En espera': const Color(0xFF7D909E),
  };
  final List<String> estadosMarcados = [
    'Registrado', 'En Proceso', 'Solucionado', 'En espera',
  ];

  // ---------- Piezas pequeñas ----------

  // Interruptor personalizado
  Widget interruptor(bool valor, ValueChanged<bool> alCambiar) {
    return GestureDetector(
      onTap: () => alCambiar(!valor),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        padding: const EdgeInsets.all(3),
        alignment: valor ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: valor ? azul : const Color(0xFFB7C2CE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  // Cuadrito con el icono de la categoría
  Widget tile(IconData icono) {
    return Container(
      width: 47,
      height: 47,
      decoration: BoxDecoration(
        color: fondoTile,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icono, color: azul, size: 26),
    );
  }

  // Tarjeta blanca: icono + título + algo a la derecha
  Widget tarjeta(IconData icono, String titulo, Widget derecha) {
    return Container(
      constraints: const BoxConstraints(minHeight: 77),
      margin: const EdgeInsets.only(bottom: 17),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x1A0F3866), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          tile(icono),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(fontSize: 17, color: Color(0xFF111820)),
            ),
          ),
          derecha,
        ],
      ),
    );
  }

  // Tarjeta con interruptor
  Widget filaInterruptor(IconData icono, String titulo, bool valor, ValueChanged<bool> alCambiar) {
    return tarjeta(icono, titulo, interruptor(valor, alCambiar));
  }

  // Tarjeta con 3 opciones: Todos / Activo / Inactivo
  Widget filaOpciones(IconData icono, String titulo, String elegido, ValueChanged<String> alCambiar) {
    return tarjeta(
      icono,
      titulo,
      Column(
        children: [
          for (final op in ['Todos', 'Activo', 'Inactivo'])
            GestureDetector(
              onTap: () => alCambiar(op),
              child: Container(
                width: 54,
                height: 18,
                margin: const EdgeInsets.symmetric(vertical: 2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: elegido == op ? azul : const Color(0xFFDCE5EE),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  op,
                  style: TextStyle(
                    fontSize: 13,
                    color: elegido == op ? Colors.white : const Color(0xFF1B2733),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Logo institucional
  Widget logo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 30,
          padding: const EdgeInsets.fromLTRB(13, 2.5, 2.5, 2.5),
          decoration: BoxDecoration(
            color: azul,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Text(
              'CERTUS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: azul,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'MUNICIPAL',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: azul),
        ),
      ],
    );
  }

  // Tarjeta de "Estados" + botón APLICAR FILTROS
  Widget tarjetaEstados() {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.only(top: 14, bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x1A0F3866), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text('Estados',
                style: TextStyle(fontSize: 20, color: Color(0xFF111820))),
          ),
          const SizedBox(height: 10),

          // Fila de chips deslizables
          SizedBox(
            height: 22,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              children: [
                for (final e in estados)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (estadosMarcados.contains(e)) {
                          estadosMarcados.remove(e);
                        } else {
                          estadosMarcados.add(e);
                        }
                      });
                    },
                    child: Opacity(
                      opacity: estadosMarcados.contains(e) ? 1 : 0.4,
                      child: Container(
                        margin: const EdgeInsets.only(right: 7),
                        padding: const EdgeInsets.symmetric(horizontal: 11),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorEstado[e],
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Text(
                          e,
                          style: TextStyle(
                            fontSize: 13,
                            color: e == 'Registrado'
                                ? const Color(0xFF2E2A14)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 17),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3866),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(fontSize: 17, letterSpacing: 0.3),
                ),
                onPressed: () => Navigator.pop(context), // Vuelve a la lista anterior
                child: const Text('APLICAR FILTROS'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Menú inferior
  Widget menuInferior() {
    final items = [
      ['Inicio', Icons.home_outlined],
      ['Trámites', Icons.assignment_outlined],
      ['Reclamos', Icons.book],
      ['Notificaciones', Icons.notifications_none],
      ['Mi Perfil', Icons.person_outline],
    ];
    const seleccionado = 2;

    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 8 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE3E8EC))),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[i][1] as IconData,
                    size: 27,
                    color: i == seleccionado ? const Color(0xFF0F3461) : const Color(0xFF46515C),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    items[i][0] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: i == seleccionado ? FontWeight.bold : FontWeight.normal,
                      color: i == seleccionado ? const Color(0xFF0F3461) : const Color(0xFF37424D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: i == seleccionado ? const Color(0xFF0F3461) : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      // Barra superior con botón de retroceso funcional estilo LoginScreen
      appBar: AppBar(
        backgroundColor: const Color(0xFF123869),
        title: const Text('Municipalidad - Filtros', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Vuelve al menú anterior
        ),
      ),
      bottomNavigationBar: menuInferior(),
      body: Stack(
        children: [
          // Forma celeste decorativa (abajo a la derecha)
          Positioned(
            right: 0,
            bottom: 0,
            child: CustomPaint(size: const Size(91, 112), painter: _FormaCeleste()),
          ),

          ListView(
            padding: EdgeInsets.zero,
            children: [
              // Cabecera con degradado y curva
              ClipPath(
                clipper: _CurvaCabecera(),
                child: Container(
                  height: 105,
                  padding: const EdgeInsets.only(top: 51),
                  alignment: Alignment.topCenter,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFFFFF), Color(0xFFD5ECFE)],
                    ),
                  ),
                  child: logo(),
                ),
              ),

              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Filtrar por Categoría',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF12396A),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: Column(
                  children: [
                    filaInterruptor(Icons.lightbulb_outline, 'Alumbrado Público', alumbrado, (v) {
                      setState(() => alumbrado = v);
                    }),
                    filaInterruptor(Icons.cleaning_services, 'Limpieza Pública', limpieza, (v) {
                      setState(() => limpieza = v);
                    }),
                    filaOpciones(Icons.park, 'Parques y Jardines', parques, (v) {
                      setState(() => parques = v);
                    }),
                    filaInterruptor(Icons.security, 'Seguridad Ciudadana', seguridad, (v) {
                      setState(() => seguridad = v);
                    }),
                    filaOpciones(Icons.alt_route, 'Mantenimiento de Vías', vias, (v) {
                      setState(() => vias = v);
                    }),

                    tarjetaEstados(),
                    const SizedBox(height: 17),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Curva de abajo de la cabecera
class _CurvaCabecera extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 19);
    path.quadraticBezierTo(
        size.width / 2, size.height + 19, size.width, size.height - 19);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Forma celeste decorativa de la esquina
class _FormaCeleste extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 152 * 1.0;
    final sy = size.height / 187;
    final path = Path()
      ..moveTo(114 * s, 17 * sy)
      ..lineTo(136 * s, 0)
      ..lineTo(152 * s, 17 * sy)
      ..lineTo(152 * s, 187 * sy)
      ..lineTo(24 * s, 187 * sy)
      ..lineTo(0, 152 * sy)
      ..lineTo(112 * s, 152 * sy)
      ..close();
    final pintura = Paint()
      ..color = const Color(0xFF7FE8EC)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, pintura);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}