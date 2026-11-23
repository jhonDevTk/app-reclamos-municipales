import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// PANTALLA 2: Crear cuenta (registro de nuevo usuario)
class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  bool ocultarClave = true;
  bool _cargando = false;

  // Controladores para capturar los datos de los campos
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();

  // Colores sacados del diseño
  static const azulBoton = Color(0xFF113F73);
  static const azulTitulo = Color(0xFF0F3157);
  static const azulLink = Color(0xFF5B9BBF);
  static const textoCampo = Color(0xFF3A444E);
  static const iconoCampo = Color(0xFF5F6B76);
  static const bordeCampo = Color(0xFFC6CACB);

  @override
  void dispose() {
    _nombreController.dispose();
    _dniController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  Future<void> _registrarUsuario() async {
    final correo = _correoController.text.trim();
    final clave = _claveController.text.trim();

    if (correo.isEmpty || clave.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa tu correo y contraseña')),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      await Supabase.instance.client.auth.signUp(
        email: correo,
        password: clave,
        data: {
          'nombre_completo': _nombreController.text.trim(),
          'dni': _dniController.text.trim(),
          'telefono': _telefonoController.text.trim(),
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta registrada correctamente')),
      );
      Navigator.pop(context);
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error al registrar')),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  // Un campo de texto (caja blanca con borde redondeado)
  Widget campo(
    IconData icono,
    String texto, {
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool esClave = false,
  }) {
    return Container(
      height: 57,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bordeCampo),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(icono, color: iconoCampo, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: esClave && ocultarClave,
              style: const TextStyle(fontSize: 16, color: textoCampo),
              decoration: InputDecoration.collapsed(
                hintText: texto,
                hintStyle: const TextStyle(fontSize: 16, color: textoCampo),
              ),
            ),
          ),
          if (esClave)
            GestureDetector(
              onTap: () => setState(() => ocultarClave = !ocultarClave),
              child: Icon(
                ocultarClave
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: iconoCampo,
                size: 26,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Barra superior para poder regresar fácilmente al menú o login anterior
      appBar: AppBar(
        backgroundColor: azulTitulo,
        title: const Text('Municipalidad - Registro', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------- Cabecera celeste: logo + "Crear Cuenta" ----------
            ClipPath(
              clipper: _CurvaCabecera(),
              child: Container(
                width: double.infinity,
                height: 165,
                padding: const EdgeInsets.only(top: 15),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF8FBFF), Color(0xFFD6E7FA)],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.security, size: 45, color: Color(0xFF173A5E)),
                        const SizedBox(width: 10),
                        const Text(
                          'MUNICIPALIDAD',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF173A5E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Crear Cuenta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: azulTitulo,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ---------- Foto de perfil con lápiz ----------
            SizedBox(
              width: 85,
              height: 85,
              child: Stack(
                children: [
                  ClipOval(
                    child: Container(
                      width: 81,
                      height: 81,
                      color: const Color(0xFFE3E7EC),
                      alignment: Alignment.bottomCenter,
                      child: const Icon(Icons.person,
                          size: 74, color: Color(0xFF8E97A3)),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Color(0xFF153E75),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Color(0x33000000), blurRadius: 4),
                        ],
                      ),
                      child: const Icon(Icons.edit_outlined,
                          size: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ---------- Formulario ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Column(
                children: [
                  campo(
                    Icons.person_outline,
                    'Nombres y Apellidos',
                    controller: _nombreController,
                  ),
                  campo(
                    Icons.badge_outlined,
                    'DNI (Documento de Identidad)',
                    controller: _dniController,
                    keyboardType: TextInputType.number,
                  ),
                  campo(
                    Icons.mail_outline,
                    'Correo electrónico',
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  campo(
                    Icons.phone_outlined,
                    'Teléfono Celular',
                    controller: _telefonoController,
                    keyboardType: TextInputType.phone,
                  ),
                  campo(
                    Icons.lock_outline,
                    'Contraseña',
                    controller: _claveController,
                    esClave: true,
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulBoton,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shadowColor: const Color(0x66113F73),
                        shape: const StadiumBorder(),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      onPressed: _cargando ? null : _registrarUsuario,
                      child: _cargando
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('REGISTRARSE'),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => Navigator.pop(context), // vuelve al login
                    child: const Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 25),
                      child: Text(
                        '¿Ya tienes cuenta? Inicia Sesión',
                        style: TextStyle(fontSize: 16, color: azulLink),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Recorta la parte de abajo de la cabecera con una curva suave
class _CurvaCabecera extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 25);
    path.quadraticBezierTo(
        size.width / 2, size.height + 25, size.width, size.height - 25);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}