import 'package:flutter/material.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Email_Interfais.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Name_Interfais.dart';
import 'package:sum_day/registration/Add_Email,Name,Password/Password_Interfais.dart';


class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  // ФУНКЦИЯ ДЛЯ СБОРА ДАННЫХ И ОТПРАВКИ В БД
  Future<void> _registerUser() async {
    // 1. Проверяем валидацию полей
    if (!_formKey.currentState!.validate()) return;

    // 2. Включаем индикатор загрузки
    setState(() {
      _isLoading = true;
    });

    try {
      // Собираем данные из контроллеров в переменные
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text;

      print('Отправка в БД: $name, $email, $password');

      // Здесь в будущем будет ваша логика работы с БД, например:
      // await myDatabase.createUser(name, email, password);

      // Имитируем задержку сети/БД в 2 секунды
      await Future.delayed(const Duration(seconds: 2));

      // Если все успешно, показываем сообщение
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Вы успешно зарегистрировались!')),
        );
      }
    } catch (e) {
      // Если произошла ошибка при записи в БД
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка регистрации: $e')),
        );
      }
    } finally {
      // 3. Выключаем индикатор загрузки в любом случае
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          CustomPasswordField(controller: _passwordController),
          const SizedBox(height: 32),

          // Кнопка регистрации

          ElevatedButton(
            // Если идет загрузка, делаем кнопку некликабельной (onPressed: null)
            onPressed: _isLoading ? null : _registerUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            // Если идет загрузка — показываем крутилку, иначе — текст
            child: _isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : const Text('Зарегистрироваться',style: TextStyle( color: Colors.black87),),
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