import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 's3_nuevo_reclamo.dart';
import 's4_mapa.dart';
import 's5_lista_reclamos.dart';
import 's6_filtros.dart';
import 's7_detalles.dart';
import 's9_notificaciones.dart';
import 's10_perfil.dart';

// PANTALLA 8: Actualizar Estado del Reclamo (conectada a Supabase)
// - Si recibe un reclamoId (desde la ventana 7) actualiza ese reclamo.
// - Si no recibe nada (por ejemplo, desde el menú), toma el reclamo más reciente.
// Al guardar: cambia el estado en la tabla "reclamos" y deja un registro
// en "historial_estados" con la observación.
class ActualizarScreen extends StatefulWidget {
  final int? reclamoId;

  const ActualizarScreen({super.key, this.reclamoId});

  @override
  State<ActualizarScreen> createState() => _ActualizarScreenState();
}

class _ActualizarScreenState extends State<ActualizarScreen> {
  final _supabase = Supabase.instance.client;

  final List<String> _estados = [
    'Registrado',
    'En Proceso',
    'En Atención',
    'Solucionado',
    'Derivado',
  ];

  final TextEditingController _observacionesController = TextEditingController();

  Map<String, dynamic>? _reclamo;
  String _estadoSeleccionado = 'En Proceso';
  bool _cargando = true;
  bool _guardando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarReclamo();
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  // ---------- CONSULTAS A SUPABASE ----------
  Future<void> _cargarReclamo() async {
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
        reclamo = await _supabase
            .from('reclamos')
            .select()
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();
      }

      if (!mounted) return;
      setState(() {
        _reclamo = reclamo;
        final estadoActual = reclamo?['estado']?.toString();
        if (estadoActual != null && _estados.contains(estadoActual)) {
          _estadoSeleccionado = estadoActual;
        }
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

  Future<void> _guardarCambios() async {
    if (_reclamo == null) return;
    setState(() => _guardando = true);

    final id = _reclamo!['id'];
    final observacion = _observacionesController.text.trim();

    try {
      // 1) Cambiar el estado del reclamo
      await _supabase
          .from('reclamos')
          .update({'estado': _estadoSeleccionado})
          .eq('id', id);

      // 2) Guardar el movimiento en el historial
      await _supabase.from('historial_estados').insert({
        'reclamo_id': id,
        'estado': _estadoSeleccionado,
        'observacion': observacion.isEmpty ? null : observacion,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Estado actualizado a "$_estadoSeleccionado"'),
          backgroundColor: Colors.green,
        ),
      );
      // Devolvemos "true" para que la ventana 7 sepa que debe recargar
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ---------- AYUDANTES ----------
  String _dosDigitos(int n) => n.toString().padLeft(2, '0');

  String _codigoReclamo(Map<String, dynamic> r) {
    final f = DateTime.tryParse(r['created_at'].toString())?.toLocal() ?? DateTime.now();
    final fecha = '${f.year}${_dosDigitos(f.month)}${_dosDigitos(f.day)}';
    return '#RM-$fecha-${_dosDigitos(r['id'] as int)}';
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
      case 's7':
        destino = DetallesScreen(reclamoId: _reclamo?['id'] as int?);
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

  // ---------- INTERFAZ ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Estado'),
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
              PopupMenuItem(value: 's7', child: Text('7. Detalles')),
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
          BottomNavigationBarItem(icon: Icon(Icons.report_problem), label: 'Mis Reclamos'),
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

    if (_error != null || _reclamo == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inbox, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                _error ?? 'Todavía no hay reclamos para actualizar.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: _cargarReclamo, child: const Text('Reintentar')),
            ],
          ),
        ),
      );
    }

    final r = _reclamo!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tarjeta de Información del Reclamo
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID RECLAMO: ${_codigoReclamo(r)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8E6C9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      (r['categoria'] ?? 'Reclamos Municipales').toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    (r['titulo'] ?? '-').toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (r['direccion'] ?? 'Ubicación no indicada').toString(),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Estado actual: ${r['estado'] ?? 'Registrado'}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Selector de Nuevo Estado
          const Text(
            'Seleccionar Nuevo Estado',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
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
                    child: Text(estado, style: const TextStyle(fontSize: 15)),
                  );
                }).toList(),
                onChanged: _guardando
                    ? null
                    : (String? nuevoValor) {
                        if (nuevoValor != null) {
                          setState(() => _estadoSeleccionado = nuevoValor);
                        }
                      },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Campo de Observaciones
          const Text(
            'Observaciones y Notas (Opcional)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _observacionesController,
            maxLines: 4,
            enabled: !_guardando,
            decoration: InputDecoration(
              hintText: 'Ej.: El técnico inspeccionó el poste; se requiere cambio de bombilla.',
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            onPressed: _guardando ? null : _guardarCambios,
            child: _guardando
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text(
                    'GUARDAR CAMBIOS',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1),
                  ),
          ),
        ],
      ),
    );
  }
}
