import 'package:flutter/material.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Email_Interfais.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Name_Interfais.dart';


class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Заголовок
          const Text(
            "Добро пожаловать",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Создать аккаунт',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Заполните данные, чтобы начать',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Поле: Имя
          CustomNameField(nameController: _nameController),
          const SizedBox(height: 16),

          // Поле: Email
          CustomEmailField(controller: _emailController),
          const SizedBox(height: 16),

          // Поле: Пароль
          TextFormField(
            controller: _passwordController,
            obscureText: _isPasswordObscured,
            decoration: InputDecoration(
              labelText: 'Пароль',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_isPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Пожалуйста, придумайте пароль';
              if (value.length < 6) return 'Пароль должен быть не менее 6 символов';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Поле: Повтор пароля
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _isConfirmPasswordObscured,
            decoration: InputDecoration(
              labelText: 'Повторите пароль',
              prefixIcon: const Icon(Icons.lock_clock_outlined),
              suffixIcon: IconButton(
                icon: Icon(_isConfirmPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _isConfirmPasswordObscured = !_isConfirmPasswordObscured),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Пожалуйста, повторите пароль';
              if (value != _passwordController.text) return 'Пароли не совпадают';
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Кнопка регистрации
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Валидация прошла успешно!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Зарегистрироваться',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),

          // Ссылка на вход
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Уже есть аккаунт? '),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Войти',
                  style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}