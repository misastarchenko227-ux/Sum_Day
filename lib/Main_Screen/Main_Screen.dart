import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sum_day/Login/QRScannerScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем текущего пользователя из Supabase
    final user = Supabase.instance.client.auth.currentUser;
    // Пытаемся достать имя из метаданных пользователя (обычно 'name' или 'display_name')
    final String userName = user?.userMetadata?['name'] ?? 
                            user?.userMetadata?['display_name'] ?? 
                            'Пользователь';

    // Определяем, является ли платформа ПК (Desktop) или Web.
    final bool isDesktop = kIsWeb ||
        Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.macOS ||
        Theme.of(context).platform == TargetPlatform.linux;

    return Scaffold(
      backgroundColor: Colors.white,
      // Для мобильных устройств используем стандартный Drawer
      drawer: !isDesktop
          ? Drawer(
              child: _buildMenuContent(context, userName),
            )
          : null,
      // Для мобильных устройств добавляем AppBar
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            // Если это ПК, боковое меню отображается всегда
            if (isDesktop)
              Container(
                width: 300,
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.grey.shade200)),
                  color: Colors.grey.shade50,
                ),
                child: _buildMenuContent(context, userName),
              ),
            // Основной контент экрана
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Добро пожаловать!',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Общий метод для создания содержимого меню с передачей имени пользователя
  Widget _buildMenuContent(BuildContext context, String userName) {
    return Column(
      children: [
        // Верхняя часть: Аватарка и Имя из Supabase
        UserAccountsDrawerHeader(
          margin: EdgeInsets.zero,
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
          ),
          currentAccountPicture: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.blueAccent),
          ),
          accountName: Text(
            userName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          accountEmail: null,
        ),
        // Пункты меню
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: const Icon(Icons.history, color: Colors.blueAccent),
                title: const Text('История'),
                onTap: () {
                  // TODO: Перейти к истории
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code_scanner, color: Colors.blueAccent),
                title: const Text('Вход для устройства через QR'),
                onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const QRScannerScreen()));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
