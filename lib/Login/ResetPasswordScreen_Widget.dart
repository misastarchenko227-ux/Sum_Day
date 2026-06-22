import 'package:flutter/material.dart';
import 'package:sum_day/AppHeaderIcon/AppHeaderIcon.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Password_Interfais.dart';

class ResetPasswordWidget extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool isLoading;
  final VoidCallback onSave;

  const ResetPasswordWidget({
    super.key,
    required this.passwordController,
    required this.confirmController,
    required this.isLoading,
    required this.onSave,
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
                      width: isDesktop ? 300 : 200,
                      height: isDesktop ? 120 : 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(isDesktop ? 24 : 18),
                      ),
                      child: AppHeaderIcon(
                        title: "Sum Day",
                        icon: Icons.wb_sunny_rounded,
                        isDesktop: isDesktop,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Новый пароль',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isDesktop ? 32 : 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF0EEFF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Придумайте новый пароль для входа',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFF8B8BAA)),
                    ),
                    const SizedBox(height: 40),
                    CustomPasswordField(controller: passwordController),
                    const SizedBox(height: 16),
                    CustomPasswordField(
                      controller: confirmController,
                      labelText: 'Повторите пароль',
                    ),
                    const SizedBox(height: 8),
                    ValueListenableBuilder(
                      valueListenable: confirmController,
                      builder: (_, __, ___) {
                        final match = passwordController.text == confirmController.text;
                        if (confirmController.text.isEmpty) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            match ? 'Пароли совпадают ✓' : 'Пароли не совпадают',
                            style: TextStyle(
                              fontSize: 12,
                              color: match ? const Color(0xFF7C3AED) : Colors.redAccent,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : onSave,
                        icon: isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                            : const Icon(Icons.lock_reset_rounded),
                        label: const Text('Сохранить пароль'),
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