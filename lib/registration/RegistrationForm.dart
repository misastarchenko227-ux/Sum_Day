import 'package:flutter/material.dart';
import 'package:sum_day/AppHeaderIcon/AppHeaderIcon.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Email_Interfais.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Name_Interfais.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Password_Interfais.dart';

class RegistrationWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final bool rememberMe;
  final VoidCallback onRegister;
  final VoidCallback onLoginTap;
  final ValueChanged<bool?> onRememberMeChanged;

  const RegistrationWidget({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.rememberMe,
    required this.onRegister,
    required this.onLoginTap,
    required this.onRememberMeChanged,
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
                        borderRadius: BorderRadius.circular(isDesktop ? 24 : 18),
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
                    CustomNameField(nameController: nameController),
                    const SizedBox(height: 16),
                    CustomEmailField(controller: emailController),
                    const SizedBox(height: 16),
                    CustomPasswordField(controller: passwordController),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          activeColor: const Color(0xFF7C3AED),
                          checkColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF3A3A5C)),
                          onChanged: onRememberMeChanged,
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
                        onPressed: isLoading ? null : onRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: isLoading
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
                          onTap: onLoginTap,
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
            );
          },
        ),
      ),
    );
  }
}