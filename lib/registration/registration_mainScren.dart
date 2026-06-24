import 'package:flutter/material.dart';
import 'package:sum_day/Login/LoginScreen.dart';
import 'package:sum_day/Main_Screen/Main_Screen.dart';
import 'package:sum_day/registration/RegistrationForm.dart';
import 'package:sum_day/repository/repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _authRepository = AuthRepository(supabaseClient: Supabase.instance.client);

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final isSuccess = await _authRepository.registerUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        rememberMe: _rememberMe,
      );

      if (isSuccess && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Вы успешно зарегистрировались!')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),(route) => false
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка аутентификации: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Неизвестная ошибка: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: RegistrationWidget(
        nameController: _nameController,
        emailController: _emailController,
        passwordController: _passwordController,
        isLoading: _isLoading,
        rememberMe: _rememberMe,
        onRegister: _registerUser,
        onRememberMeChanged: (value) {
          setState(() => _rememberMe = value ?? false);
        },
        onLoginTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
      ),
    );
  }
}