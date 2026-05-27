import 'package:flutter/material.dart';

class CustomNameField extends StatelessWidget {
  // Переменная теперь публичная (без подчеркивания)
  final TextEditingController nameController;

  const CustomNameField({
    super.key,
    required this.nameController, // Теперь Dart не ругается
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: 'Имя',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Пожалуйста, введите имя';
        }
        return null;
      },
    );
  }
}