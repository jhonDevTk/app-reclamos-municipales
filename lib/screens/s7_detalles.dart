import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 's3_nuevo_reclamo.dart';
import 's4_mapa.dart';
import 's5_lista_reclamos.dart';
import 's6_filtros.dart';
import 's8_actualizar.dart';
import 's9_notificaciones.dart';
import 's10_perfil.dart';

// PANTALLA 7: Detalle del Reclamo (conectada a Supabase)
// Usa la tabla "reclamos" que ya existe en Supabase (campos: codigo_reclamo,
// titulo, categoria, descripcion, ubicacion_referencia, estado, fecha_registro...).
// - Si recibe un reclamoId (desde la lista, ventana 5) muestra ese reclamo.
// - Si no recibe nada (por ejemplo, desde el menú), muestra el reclamo más reciente.
class DetallesScreen extends StatefulWidget {
  final Object? reclamoId;

  const DetallesScreen({super.key, this.reclamoId});

  @override
  State<DetallesScreen> createState() => _DetallesScreenState();
}

class _DetallesScreenState extends State<DetallesScreen> {
  final _supabase = Supabase.instance.client;

  Map<String, dynamic>? _reclamo;
  List<Map<String, dynamic>> _historial = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  // ---------- CONSULTAS A SUPABASE ----------
  Future<void> _cargarDatos() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      Map<String, dynamic>? reclamo;

      if (widget.reclamoId != null) {
        reclamo = await _supabase
            .from('reclamos')
            .select()
            .eq('id', widget.reclamoId!)
            .maybeSingle();
      } else {
        // Sin id: traemos los reclamos y nos quedamos con el más reciente
        final filas = List<Map<String, dynamic>>.from(
          await _supabase.from('reclamos').select(),
        );
        filas.sort((a, b) {
          final fa = _fecha(_fechaDe(a)) ?? DateTime(2000);
          final fb = _fecha(_fechaDe(b)) ?? DateTime(2000);
          return fb.compareTo(fa);
        });
        reclamo = filas.isEmpty ? null : filas.first;
      }

      // El historial es opcional: si la tabla aún no existe, no rompe la ventana
      List<Map<String, dynamic>> historial = [];
      if (reclamo != null) {
        try {
          historial = List<Map<String, dynamic>>.from(
            await _supabase
                .from('historial_estados')
                .select()
                .eq('reclamo_id', reclamo['id'].toString())
                .order('created_at', ascending: true),
          );
        } catch (e) {
          debugPrint('Historial no disponible: $e');
        }
      }

      if (!mounted) return;
      setState(() {
        _reclamo = reclamo;
        _historial = historial;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo cargar el reclamo: $e';
        _cargando = false;
      });
    }
  }

  // ---------- AYUDANTES PARA MOSTRAR DATOS ----------
  DateTime? _fecha(dynamic valor) =>
      valor == null ? null : DateTime.tryParse(valor.toString())?.toLocal();

  String _dosDigitos(int n) => n.toString().padLeft(2, '0');

  String _formatoFecha(dynamic valor) {
    final f = _fecha(valor);
    if (f == null) return '-';
    return '${_dosDigitos(f.day)}/${_dosDigitos(f.month)}/${f.year}';
  }

  String _formatoFechaHora(dynamic valor) {
    final f = _fecha(valor);
    if (f == null) return '-';
    return '${_formatoFecha(valor)} ${_dosDigitos(f.hour)}:${_dosDigitos(f.minute)}';
  }

  // Devuelve la fecha del reclamo (fecha_registro; si no, created_at)
  dynamic _fechaDe(Map<String, dynamic> r) => r['fecha_registro'] ?? r['created_at'];

  // Devuelve la ubicación (ubicacion_referencia; si no, direccion)
  String _ubicacionDe(Map<String, dynamic> r) =>
      (r['ubicacion_referencia'] ?? r['direccion'] ?? 'No indicada').toString();

  // Usa codigo_reclamo si existe; si no, arma uno. Ejemplo: #RM-20261025-01
  String _codigoReclamo(Map<String, dynamic> r) {
    final codigo = r['codigo_reclamo']?.toString();
    if (codigo != null && codigo.isNotEmpty) return codigo;
    final f = _fecha(_fechaDe(r)) ?? DateTime.now();
    final fecha = '${f.year}${_dosDigitos(f.month)}${_dosDigitos(f.day)}';
    final id = r['id'].toString();
    final corto = id.length > 6 ? id.substring(0, 6).toUpperCase() : id.padLeft(2, '0');
    return '#RM-$fecha-$corto';
  }

  Color _colorFondoEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'en proceso':
      case 'en atención':
        return const Color(0xFFBBDEFB);
      case 'atendido':
      case 'solucionado':
        return const Color(0xFFC8E6C9);
      case 'rechazado':
        return const Color(0xFFFFCDD2);
      default: // pendiente / registrado
        return const Color(0xFFFFE082);
    }
  }

  Color _colorTextoEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'en proceso':
      case 'en atención':
        return const Color(0xFF0D47A1);
      case 'atendido':
      case 'solucionado':
        return const Color(0xFF1B5E20);
      case 'rechazado':
        return const Color(0xFFB71C1C);
      default:
        return const Color(0xFF5D4037);
    }
  }

  // ---------- NAVEGACIÓN ----------
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
      case 's8':
        destino = ActualizarScreen(reclamoId: _reclamo?['id']);
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

  Future<void> _abrirActualizar() async {
    if (_reclamo == null) return;
    final actualizado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ActualizarScreen(reclamoId: _reclamo!['id']),
      ),
    );
    // Si en la ventana 8 se guardó un cambio, recargamos el detalle
    if (actualizado == true) _cargarDatos();
  }

  // ---------- INTERFAZ ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Reclamo'),
        backgroundColor: const Color(0xFF2E2463),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
              PopupMenuItem(value: 's8', child: Text('8. Actualizar')),
              PopupMenuItem(value: 's9', child: Text('9. Notificaciones')),
              PopupMenuItem(value: 's10', child: Text('10. Perfil')),
            ],
          ),
        ],
      ),
      body: _construirCuerpo(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: const Color(0xFF2E2463),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Trámites'),
          BottomNavigationBarItem(icon: Icon(Icons.report_problem), label: 'Reclamos'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificaciones'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Mi Perfil'),
        ],
      ),
    );
  }

  Widget _construirCuerpo() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _mensajeCentral(
        icono: Icons.error_outline,
        texto: _error!,
        boton: 'Reintentar',
        accion: _cargarDatos,
      );
    }

    if (_reclamo == null) {
      return _mensajeCentral(
        icono: Icons.inbox,
        texto: 'Todavía no hay reclamos registrados.',
        boton: 'Actualizar',
        accion: _cargarDatos,
      );
    }

    final r = _reclamo!;
    final estado = (r['estado'] ?? 'Pendiente').toString();

    return RefreshIndicator(
      onRefresh: _cargarDatos,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarjeta de ID y Estado
            _tarjeta(
              child: Column(
                children: [
                  Text(
                    'ID RECLAMO: ${_codigoReclamo(r)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: _colorFondoEstado(estado),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      estado.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _colorTextoEstado(estado),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Tarjeta de Información General
            _tarjeta(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _tituloSeccion('INFORMACIÓN GENERAL'),
                  Text('Fecha de Registro: ${_formatoFecha(_fechaDe(r))}',
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Ubicación: ${_ubicacionDe(r)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const Icon(Icons.location_on, color: Colors.orange, size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Categoría: ${r['categoria'] ?? '-'}',
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    'Asunto: ${r['titulo'] ?? '-'}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Tarjeta de Descripción del Vecino
            _tarjeta(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _tituloSeccion('DESCRIPCIÓN DEL VECINO'),
                  Text(
                    (r['descripcion'] ?? 'Sin descripción').toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Tarjeta de Evidencia Fotográfica
            _tarjeta(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _tituloSeccion('EVIDENCIA FOTOGRÁFICA'),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: (r['foto_url'] != null && r['foto_url'].toString().isNotEmpty)
                        ? Image.network(
                            r['foto_url'].toString(),
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _fotoVacia(),
                          )
                        : _fotoVacia(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Tarjeta de Historial de Estados
            _tarjeta(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _tituloSeccion('HISTORIAL DE ESTADOS'),
                  ..._construirHistorial(r),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Botón para ir a la ventana 8 con este reclamo
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF103456),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: _abrirActualizar,
              icon: const Icon(Icons.edit),
              label: const Text(
                'ACTUALIZAR ESTADO',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _construirHistorial(Map<String, dynamic> r) {
    // Si aún no hay movimientos, al menos mostramos el registro inicial
    if (_historial.isEmpty) {
      return [
        _filaHistorial(
          '${_formatoFecha(_fechaDe(r))} - ${r['estado'] ?? 'Pendiente'}',
          null,
        ),
      ];
    }
    return _historial.map((h) {
      return _filaHistorial(
        '${_formatoFechaHora(h['created_at'])} - ${h['estado']}',
        h['observacion']?.toString(),
      );
    }).toList();
  }

  Widget _filaHistorial(String titulo, String? observacion) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.check_circle, color: Colors.green),
      title: Text(
        titulo,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: (observacion != null && observacion.isNotEmpty)
          ? Text(observacion, style: const TextStyle(fontSize: 13))
          : null,
    );
  }

  // ---------- PIEZAS REUTILIZABLES ----------
  Widget _tarjeta({required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }

  Widget _tituloSeccion(String texto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          texto,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        const Divider(),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _fotoVacia() {
    return Container(
      height: 90,
      width: 120,
      color: Colors.black87,
      child: const Center(child: Icon(Icons.image, color: Colors.white, size: 40)),
    );
  }

  Widget _mensajeCentral({
    required IconData icono,
    required String texto,
    required String boton,
    required VoidCallback accion,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(texto, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: accion, child: Text(boton)),
          ],
        ),
      ),
    );
  }
}
