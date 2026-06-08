import 'package:flutter/material.dart';
import 'package:sum_day/Login/LoginScreen.dart';
import 'package:sum_day/Main_Screen/Main_Screen.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Email_Interfais.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Name_Interfais.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Password_Interfais.dart';
import 'package:sum_day/repository/repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authRepository = AuthRepository(supabaseClient: Supabase.instance.client);

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
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
      final isSuccess = await authRepository.registerUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        rememberMe: _rememberMe,
      );

      if (isSuccess && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Вы успешно зарегистрировались!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
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
                        width: isDesktop ? 80 : 64,
                        height: isDesktop ? 80 : 64,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED),
                          borderRadius: BorderRadius.circular(isDesktop ? 24 : 18),
                        ),
                        child: Icon(Icons.wb_sunny_rounded,
                            color: Colors.white, size: isDesktop ? 40 : 32),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Создать аккаунт',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isDesktop ? 32 : 24,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF0EEFF),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Заполните данные, чтобы начать',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Color(0xFF8B8BAA)),
                      ),
                      const SizedBox(height: 40),

                      CustomNameField(nameController: _nameController),
                      const SizedBox(height: 16),

                      CustomEmailField(controller: _emailController),
                      const SizedBox(height: 16),

                      CustomPasswordField(controller: _passwordController),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: const Color(0xFF7C3AED),
                            checkColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF3A3A5C)),
                            onChanged: (value) {
                              setState(() => _rememberMe = value ?? false);
                            },
                          ),
                          const Text(
                            'Запомнить меня',
                            style: TextStyle(fontSize: 14, color: Color(0xFF8B8BAA)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C3AED),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                              : const Text('Зарегистрироваться'),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Уже есть аккаунт? ',
                            style: TextStyle(color: Color(0xFF8B8BAA), fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              'Войти',
                              style: TextStyle(
                                color: Color(0xFF7C3AED),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
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