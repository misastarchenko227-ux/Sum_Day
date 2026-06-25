import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sum_day/Main_Screen/Main_Screen.dart';
import 'package:sum_day/widgets/back_button.dart';
import 'package:sum_day/Login/QRLoginScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final _supabase = Supabase.instance.client;
  final _scannerController = MobileScannerController();
  bool _isProcessing = false;

  bool _isMobile() {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onQRScanned(String sessionId) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Подтвердить вход?',
            style: TextStyle(color: Color(0xFFC4B5FD))),
        content: const Text(
          'Войти в аккаунт с этого устройства?',
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
      final session = await _supabase
          .from('qr_sessions')
          .select('access_token, refresh_token')
          .eq('session_id', sessionId)
          .single();

      final accessToken = session['access_token'] as String?;
      final refreshToken = session['refresh_token'] as String?;

      if (accessToken == null || refreshToken == null) {
        throw Exception('Токены не найдены');
      }

      await _supabase.auth.setSession(refreshToken);

      // Сохраняем флаг чтобы при следующем запуске не выкидывало на логин
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', true);

      await _supabase.from('qr_sessions').update({
        'status': 'authorized',
      }).eq('session_id', sessionId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Вход подтверждён!')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
        );
      }
    }
    catch (e) {
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
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: _isProcessing
            ? const Center(
            child: CircularProgressIndicator(color: Color(0xFFC4B5FD)))
            : _isMobile()
            ? MobileScanner(
          controller: _scannerController,
          onDetect: (capture) {
            final barcode = capture.barcodes.firstOrNull;
            if (barcode?.rawValue != null) {
              _onQRScanned(barcode!.rawValue!);
            }
          },
        )
            : const QRLoginScreen(),
      ),
    );
  }
}