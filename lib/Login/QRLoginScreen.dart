import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import "package:uuid/uuid.dart";

class QRLoginScreen extends StatefulWidget {
  const QRLoginScreen({super.key});

  @override
  State<QRLoginScreen> createState() => _QRLoginScreenState();
}

class _QRLoginScreenState extends State<QRLoginScreen> {
  final _supabase = Supabase.instance.client;
  late String _sessionId;
  bool _isLoggingIn = false;
  Timer? _expiryTimer;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _initSession();
  }

  void _initSession() {
    _sessionId = const Uuid().v4();
    _insertSession();
    _listenToSession();
    // Обновляем QR каждые 60 секунд
    _expiryTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _channel?.unsubscribe();
      setState(() {
        _sessionId = const Uuid().v4();
        _isLoggingIn = false;
      });
      _insertSession();
      _listenToSession();
    });
  }

  Future<void> _insertSession() async {
    await _supabase.from('qr_sessions').insert({
      'session_id': _sessionId,
    });
  }

  void _listenToSession() {
    _channel = _supabase
        .channel('qr_session_$_sessionId')
        .onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'qr_sessions',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'session_id',
        value: _sessionId,
      ),
      callback: (payload) {
        final status = payload.newRecord['status'];
        final token = payload.newRecord['access_token'];
        if (status == 'authorized' && token != null) {
          _completeLogin(token);
        }
      },
    )
        .subscribe();
  }

  Future<void> _completeLogin(String token) async {
    setState(() => _isLoggingIn = true);
    // Устанавливаем сессию по токену
    await _supabase.auth.setSession(token);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    _channel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Вход по QR-коду',
            style: TextStyle(color: Color(0xFFC4B5FD))),
        iconTheme: const IconThemeData(color: Color(0xFFC4B5FD)),
      ),
      body: Center(
        child: _isLoggingIn
            ? const CircularProgressIndicator(color: Color(0xFFC4B5FD))
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Отсканируй QR-код в мобильном приложении',
              style: TextStyle(color: Color(0xFFC4B5FD)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: QrImageView(
                data: _sessionId,
                version: QrVersions.auto,
                size: 220,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Код обновляется каждые 60 секунд',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}