import 'package:flutter/material.dart';
import 'package:sum_day/Text_Stile/AppTheme.dart';

class CustomNameField extends StatelessWidget {
  final TextEditingController nameController;

  const CustomNameField({
    super.key,
    required this.nameController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      keyboardType: TextInputType.name,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: AppTheme.fieldDecoration('Имя', Icons.person_outline),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Пожалуйста, введите имя';
        }
        return null;
      },
    );
  }
}