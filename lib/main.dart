import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/s1_login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jjsayqplzsuvjvvitodh.supabase.co',
    publishableKey: 'sb_publishable_gsTCj-lo3Ssf50bzeUmLEg_UkWhH4Q7',
  );

  runApp(const AppMunicipal());
}

class AppMunicipal extends StatelessWidget {
  const AppMunicipal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Reclamos Municipales',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}