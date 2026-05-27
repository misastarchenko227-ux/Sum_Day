import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Задаем белый фон экрана
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Иконка успеха (можно использовать зеленый цвет из AppColors.success)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 90,
                ),
                const SizedBox(height: 24),

                const Text(
                  'Добро пожаловать!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                const Text(
                  'Вы успешно вошли в приложение. Пока это временный экран.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Временная кнопка для выхода, чтобы можно было вернуться назад тестить
                ElevatedButton(
                  onPressed: () {
                    // Возвращаемся на экран регистрации/авторизации
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Назад'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}