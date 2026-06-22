import 'package:flutter/material.dart';

class AppHeaderIcon extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDesktop;

  const AppHeaderIcon({
    super.key,
    required this.title,
    required this.icon,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isDesktop ? 300 : 200,
      height: isDesktop ? 120 : 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED),
        borderRadius: BorderRadius.circular(isDesktop ? 24 : 18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: isDesktop ? 40 : 32,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 20 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}