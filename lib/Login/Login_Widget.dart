import 'package:flutter/material.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Email_Interfais.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Password_Interfais.dart';
import 'package:sum_day/registration/registration_mainScren.dart';


class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: isDesktop ? 80 : 64,
                      height: isDesktop ? 80 : 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(isDesktop ? 24 : 18),
                      ),
                      child: Icon(Icons.wb_sunny_rounded,
                          color: Colors.white, size: isDesktop ? 40 : 32),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Вход в аккаунт',
                      style: TextStyle(
                        fontSize: isDesktop ? 32 : 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF0EEFF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Добро пожаловать назад',
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
                          style: TextStyle(
                              color: Color(0xFF7C3AED), fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.login_rounded),
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
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegistrationScreen(),
                            ),
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
            );
          },
        ),
      ),
    );
  }
}