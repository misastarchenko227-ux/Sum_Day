import 'package:flutter/material.dart';
import 'package:sum_day/Text_Stile/AppTheme.dart';

class CustomPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const CustomPasswordField({
    super.key,
    required this.controller,
    this.labelText = 'Пароль',
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isPasswordObscured,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: AppTheme.fieldDecoration(widget.labelText, Icons.lock_outline).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordObscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppTheme.textSecondary,
          ),
          onPressed: () {
            setState(() {
              _isPasswordObscured = !_isPasswordObscured;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, введите пароль';
        }
        if (value.length < 6) {
          return 'Пароль должен быть не менее 6 символов';
        }
        return null;
      },
    );
  }
}