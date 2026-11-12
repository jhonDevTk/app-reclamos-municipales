import 'package:flutter/material.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {

  final Color azul = const Color(0xFF123D69);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController =
      TextEditingController(text: 'Juan Vecino');

  final TextEditingController dniController =
      TextEditingController(text: '12345678');

  final TextEditingController correoController =
      TextEditingController(text: 'juan.vecino@email.com');

  final TextEditingController telefonoController =
      TextEditingController(text: '999999999');

  final TextEditingController direccionController =
      TextEditingController(text: 'San Juan de Lurigancho, Lima');

  bool notificacionesCorreo = true;
  bool alertasReclamos = true;
  bool alertasMunicipales = false;

  @override
  void dispose() {
    nombreController.dispose();
    dniController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    direccionController.dispose();
    super.dispose();
  }

  void guardarDatos() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datos actualizados correctamente.'),
        ),
      );

      setState(() {});
    }
  }

  void guardarConfiguracion() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración guardada correctamente.'),
      ),
    );
  }

  void cambiarContrasena() {
    final nuevaContrasenaController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cambiar contraseña'),

          content: TextField(
            controller: nuevaContrasenaController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Nueva contraseña',
              border: OutlineInputBorder(),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),

            ElevatedButton(
              onPressed: () {
                if (nuevaContrasenaController.text.length >= 6) {
                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Solicitud de cambio registrada en la demostración.',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    ).then((_) {
      nuevaContrasenaController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FA),

      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        centerTitle: true,
        // Botón de retroceso para volver al menú anterior o principal
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Certus Municipal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Perfil de Usuario y Configuración',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123D69),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Administra tus datos personales y las preferencias de tu cuenta municipal.',
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 22),

            // INFORMACIÓN DEL USUARIO

            Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [

                    CircleAvatar(
                      radius: 45,
                      backgroundColor: const Color(0xFFDCEFF5),

                      child: Text(
                        nombreController.text.trim().isEmpty
                            ? 'U'
                            : nombreController.text
                                .trim()
                                .split(RegExp(r'\s+'))
                                .take(2)
                                .map((e) => e[0])
                                .join()
                                .toUpperCase(),

                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: azul,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      nombreController.text,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      correoController.text,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFFE4F5F2),
                        borderRadius: BorderRadius.circular(25),
                      ),

                      child: const Text(
                        'CUENTA DE VECINO',
                        style: TextStyle(
                          color: Color(0xFF26777A),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // DATOS PERSONALES

            Card(
              color: Colors.white,
              elevation: 2,

              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        'Datos personales',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF123D69),
                        ),
                      ),

                      const SizedBox(height: 18),

                      campo(
                        'Nombres y apellidos',
                        nombreController,
                        Icons.person,
                      ),

                      campo(
                        'DNI',
                        dniController,
                        Icons.badge,
                        teclado: TextInputType.number,
                        maxLength: 8,
                      ),

                      campo(
                        'Correo electrónico',
                        correoController,
                        Icons.email,
                        teclado: TextInputType.emailAddress,
                      ),

                      campo(
                        'Teléfono',
                        telefonoController,
                        Icons.phone,
                        teclado: TextInputType.phone,
                      ),

                      campo(
                        'Dirección',
                        direccionController,
                        Icons.location_on,
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton.icon(
                          onPressed: guardarDatos,

                          icon: const Icon(Icons.save),

                          label: const Text(
                            'GUARDAR CAMBIOS',
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
            ),

            const SizedBox(height: 18),

            // CONFIGURACIÓN

            Card(
              color: Colors.white,
              elevation: 2,

              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'Configuración de la cuenta',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF123D69),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Personaliza cómo deseas recibir información.',
                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 12),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: azul,
                      title: const Text(
                        'Notificaciones por correo',
                      ),
                      subtitle: const Text(
                        'Recibir avisos en tu email.',
                      ),
                      value: notificacionesCorreo,
                      onChanged: (value) {
                        setState(() {
                          notificacionesCorreo = value;
                        });
                      },
                    ),

                    const Divider(),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: azul,
                      title: const Text(
                        'Alertas de reclamos',
                      ),
                      subtitle: const Text(
                        'Recibir cambios en tus solicitudes.',
                      ),
                      value: alertasReclamos,
                      onChanged: (value) {
                        setState(() {
                          alertasReclamos = value;
                        });
                      },
                    ),

                    const Divider(),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: azul,
                      title: const Text(
                        'Alertas municipales',
                      ),
                      subtitle: const Text(
                        'Recibir avisos sobre servicios municipales.',
                      ),
                      value: alertasMunicipales,
                      onChanged: (value) {
                        setState(() {
                          alertasMunicipales = value;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: guardarConfiguracion,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: azul,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),

                        child: const Text(
                          'GUARDAR CONFIGURACIÓN',
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: cambiarContrasena,
                        icon: const Icon(Icons.lock_outline),
                        label: const Text(
                          'CAMBIAR CONTRASEÑA',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'CERTUS MUNICIPAL - VENTANA 10',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget campo(
    String titulo,
    TextEditingController controller,
    IconData icono, {
    TextInputType teclado = TextInputType.text,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: TextFormField(
        controller: controller,
        keyboardType: teclado,
        maxLength: maxLength,

        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Este campo es obligatorio';
          }

          if (titulo == 'DNI' &&
              !RegExp(r'^[0-9]{8}$').hasMatch(value)) {
            return 'El DNI debe tener 8 números';
          }

          if (titulo == 'Correo electrónico' &&
              !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
            return 'Ingrese un correo válido';
          }

          return null;
        },

        decoration: InputDecoration(
          labelText: titulo,
          prefixIcon: Icon(
            icono,
            color: azul,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          counterText: '',
        ),
      ),
    );
  }
}