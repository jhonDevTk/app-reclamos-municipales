import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Importamos la pantalla de registro y la de perfil
import 's2_registro.dart';
import 's10_perfil.dart';

// PANTALLA 1: Iniciar sesión (Renombrada a LoginScreen para mantener el estándar del proyecto)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool ocultarClave = true;
  bool _cargando = false;

  // Controladores para capturar correo y contraseña
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();

  // Colores sacados del diseño original
  static const azulBoton = Color(0xFF113F73);
  static const azulTitulo = Color(0xFF0F3157);
  static const azulLink = Color(0xFF5B9BBF);
  static const textoCampo = Color(0xFF3A444E);
  static const iconoCampo = Color(0xFF5F6B76);
  static const bordeCampo = Color(0xFFC6CACB);

  @override
  void dispose() {
    _correoController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
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
      await Supabase.instance.client.auth.signInWithPassword(
        email: correo,
        password: clave,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión iniciada correctamente')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const PerfilScreen(),
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error al iniciar sesión')),
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
      height: 60,
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
          // mostrar / ocultar contraseña
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

      // Barra superior con opción de volver al menú de pruebas del Líder Técnico
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: azulTitulo,
        title: const Text('Municipalidad - Login', style: TextStyle(color: Colors.white)),
      ),

      // "¿No tienes cuenta?" en la parte inferior
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: 20,
          bottom: 20 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFE8F2FC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '¿No tienes cuenta?',
              style: TextStyle(fontSize: 16, color: Color(0xFF0E1E2D)),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegistroScreen()),
                );
              },
              child: const Text(
                'REGÍSTRATE COMO VECINO',
                style: TextStyle(fontSize: 17, color: azulLink, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------- Cabecera celeste con diseño de curva ----------
            ClipPath(
              clipper: _CurvaCabecera(),
              child: Container(
                width: double.infinity,
                height: 160,
                padding: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF8FBFF), Color(0xFFD6E7FA)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.security, size: 50, color: Color(0xFF173A5E)),
                    const SizedBox(width: 12),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MUNICIPALIDAD',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF173A5E),
                          ),
                        ),
                        Text(
                          'Gestión de Reclamos',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2C4A68),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: azulTitulo,
              ),
            ),

            const SizedBox(height: 20),

            // ---------- Formulario de acceso ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Column(
                children: [
                  campo(
                    Icons.person_outline,
                    'Correo electrónico o Usuario',
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  campo(
                    Icons.lock_outline,
                    'Contraseña',
                    controller: _claveController,
                    esClave: true,
                  ),
                  const SizedBox(height: 25),

                  // Botón INGRESAR
                  SizedBox(
                    width: double.infinity,
                    height: 53,
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
                      onPressed: _cargando ? null : _iniciarSesion,
                      child: _cargando
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('INGRESAR'),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        '¿Olvidaste tu contraseña?',
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