import 'package:flutter/material.dart';

class CustomEmailField extends StatelessWidget {
  final TextEditingController controller;

  // Контроллер передаем через конструктор, чтобы управлять текстом из главного экрана
  const CustomEmailField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Пожалуйста, введите Email';
        }
        // Регулярное выражение для проверки корректности email
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Введите корректный Email';
        }
        return null;
      },
    );
  }
}