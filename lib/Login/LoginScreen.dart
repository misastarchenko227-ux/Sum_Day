import 'package:flutter/material.dart';
import 'package:sum_day/Main_Screen/Main_Screen.dart';
import 'package:sum_day/registration/registration_mainScren.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Email_Interfais.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Password_Interfais.dart';
import 'package:sum_day/repository/repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _authRepository = AuthRepository(supabaseClient: Supabase.instance.client);

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 600;
            final horizontalPadding = isDesktop ? 120.0 : 24.0;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        // Увеличим ширину, так как текст длинный, а 80 пикселей для него слишком мало
                        width: isDesktop ? 300 : 200,
                        height: isDesktop ? 120 : 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED),
                          borderRadius: BorderRadius.circular(isDesktop ? 24 : 18),
                        ),
                        child: Column( // <--- Объединяем их в колонку
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                                Icons.wb_sunny_rounded,
                                color: Colors.white,
                                size: isDesktop ? 40 : 32
                            ),
                            const SizedBox(height: 8), // Небольшой отступ между иконкой и текстом
                            Text(
                              "SumDay",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 20 : 16, // Сделали шрифт чуть меньше, чтобы он влез в контейнер
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Вход в аккаунт',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isDesktop ? 32 : 24,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF0EEFF),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'С возвращением',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Color(0xFF8B8BAA)),
                      ),
                      const SizedBox(height: 40),
                      CustomEmailField(controller: emailController),
                      const SizedBox(height: 16),
                      CustomPasswordField(controller: passwordController),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: null,
                          child: const Text(
                            'Забыли пароль?',
                            style: TextStyle(color: Color(0xFF7C3AED), fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _login,
                          icon: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                              : const Icon(Icons.login_rounded),
                          label: const Text('Войти'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C3AED),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: const [
                          Expanded(child: Divider(color: Color(0xFF2E2E4A))),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('нет аккаунта?',
                                style: TextStyle(
                                    color: Color(0xFF5A5A78), fontSize: 13)),
                          ),
                          Expanded(child: Divider(color: Color(0xFF2E2E4A))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegistrationScreen()),
                            );
                          },
                          icon: const Icon(Icons.person_add_alt_1_rounded),
                          label: const Text('Регистрация'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFC4B5FD),
                            side: const BorderSide(color: Color(0xFF3A3A5C)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}