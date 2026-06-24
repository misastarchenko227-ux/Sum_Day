import 'package:flutter/material.dart';
import 'package:sum_day/AppHeaderIcon/AppHeaderIcon.dart';

import 'package:sum_day/Login/QRScannerScreen.dart';
import 'package:sum_day/registration/registration_mainScren.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Email_Interfais.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Password_Interfais.dart';

class LoginWidget extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  const LoginWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
    required this.onForgotPassword,
  });

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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      // Размеры контейнера-обертки (если они нужны)
                      width: isDesktop ? 300 : 200,
                      height: isDesktop ? 120 : 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(
                          isDesktop ? 24 : 18,
                        ),
                      ),
                      // Просто вызываем наш класс, он сам всё отрисует
                      child: AppHeaderIcon(
                        title: "Sum Day",
                        icon: Icons.wb_sunny_rounded,
                        isDesktop: isDesktop, // Используйте вашу переменную
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
                        onPressed: onForgotPassword,
                        child: const Text(
                          'Забыли пароль?',
                          style: TextStyle(
                            color: Color(0xFF7C3AED),
                            fontSize: 13,
                          ),
                        ),

                        // логика в LoginScreen на 86 строке
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : onLogin,
                        icon: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.login_rounded),
                        label: const Text('Войти'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: const [
                        Expanded(child: Divider(color: Color(0xFF2E2E4A))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'нет аккаунта?',
                            style: TextStyle(
                              color: Color(0xFF5A5A78),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Color(0xFF2E2E4A))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
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
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QRScannerScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        label: const Text('Войти по QR-коду'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFC4B5FD),
                          side: const BorderSide(color: Color(0xFF3A3A5C)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
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
