import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final _supabase = Supabase.instance.client;
  bool _isProcessing = false;

  void _onQRScanned(String sessionId) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    // Показываем диалог подтверждения (защита от случайного срабатывания)
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Подтвердить вход?',
            style: TextStyle(color: Color(0xFFC4B5FD))),
        content: const Text(
          'Вы пытаетесь войти на другом устройстве?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена',
                style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Войти',
                style: TextStyle(color: Color(0xFFC4B5FD))),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      setState(() => _isProcessing = false);
      return;
    }

    try {
      final token = _supabase.auth.currentSession?.accessToken;
      if (token == null) throw Exception('Не авторизован');

      // Записываем токен в сессию и помечаем как authorized
      await _supabase.from('qr_sessions').update({
        'access_token': token,
        'status': 'authorized',
      }).eq('session_id', sessionId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Вход подтверждён!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Сканировать QR',
            style: TextStyle(color: Color(0xFFC4B5FD))),
        iconTheme: const IconThemeData(color: Color(0xFFC4B5FD)),
      ),
      body: _isProcessing
          ? const Center(
          child: CircularProgressIndicator(color: Color(0xFFC4B5FD)))
          : MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.firstOrNull;
          if (barcode?.rawValue != null) {
            _onQRScanned(barcode!.rawValue!);
          }
        },
      ),
    );
  }
}