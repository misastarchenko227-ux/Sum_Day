import 'package:flutter/material.dart';
import 'package:sum_day/Text_Stile/AppTheme.dart';

class CustomEmailField extends StatelessWidget {
  final TextEditingController controller;

  const CustomEmailField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: AppTheme.fieldDecoration('Email', Icons.email_outlined),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Пожалуйста, введите Email';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Введите корректный Email';
        }
        return null;
      },
    );
  }
}