import 'package:flutter/material.dart';

import 'package:sum_day/repository/repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Импортируйте ваши экраны (замените пути на правильные, если они отличаются)
import 'package:sum_day/Main_Screen/Main_Screen.dart';

import 'package:sum_day/Login/LoginScreen.dart';
final authRepository = AuthRepository(supabaseClient: Supabase.instance.client);
void main() async {
  // Инициализация Flutter-биндингов (обязательно перед SharedPreferences и Supabase)
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Supabase
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
      // Вместо прямой загрузки RegistrationScreen, мы сначала запускаем проверку авторизации
      home:  AuthStateCheck(), // Наш виджет проверки,
    );
  }
}

// Новый виджет, который проверяет, ставить ли галочку "Запомнить меня"
class AuthStateCheck extends StatefulWidget {
  const AuthStateCheck({super.key});

  @override
  State<AuthStateCheck> createState() => _AuthStateCheckState();
}

class _AuthStateCheckState extends State<AuthStateCheck> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Вызываем метод из репозитория, который мы только что протестировали!
    final shouldGoToHome = await authRepository.isUserLoggedInAndRemembered();

    if (!mounted) return;

    if (shouldGoToHome) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Пока идет асинхронная проверка (доли секунды), показываем красивый экран загрузки
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}