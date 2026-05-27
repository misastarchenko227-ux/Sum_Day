import 'package:flutter/material.dart';
import 'package:sum_day/registration/registration_mainScren.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://jcnycdmjawnvlmrdlsxn.supabase.co',
    anonKey: 'sb_publishable_giSuoz_HYC_-j0ggxSoHzA_pkezdZGz',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RegistrationScreen(), // Теперь const можно (и нужно) поставить сюда, если у экрана константный конструктор
    );
  }
}