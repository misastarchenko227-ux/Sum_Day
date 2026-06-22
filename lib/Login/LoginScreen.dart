import 'package:flutter/material.dart';
import 'package:sum_day/Main_Screen/Main_Screen.dart';
import 'package:sum_day/repository/repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Login_Widget.dart';

final _authRepository = AuthRepository(supabaseClient: Supabase.instance.client);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final isSuccess = await _authRepository.loginUser(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (isSuccess && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${e.message}')),
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
  Future<void> _forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите email в поле выше')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authRepository.sendPasswordResetEmail(email: email);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }

    if (mounted) {
      showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF1A1A2E),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Письмо отправлено',
                    style: TextStyle(
                      color: Color(0xFFF0EEFF),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Color(0xFF8B8BAA)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Icon(
                Icons.mark_email_read_outlined,
                size: 48,
                color: Color(0xFF7C3AED),
              ),
              const SizedBox(height: 16),
              const Text(
                'Инструкция по сбросу пароля отправлена на почту, указанную при регистрации.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8B8BAA),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: LoginWidget(
        emailController: emailController,
        passwordController: passwordController,
        isLoading: _isLoading,
        onLogin: _login,
        onForgotPassword: _forgotPassword,
      ),
    );
  }
}
