import 'package:flutter/material.dart';
import 'package:sum_day/registration/RegistrationForm.dart';
 // Импортируем нашу новую форму

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: RegistrationForm(), // Просто вызываем форму тут!
        ),
      ),
    );
  }
}