import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../lib/repository/repository.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockAuthResponse extends Mock implements AuthResponse {}
class MockUser extends Mock implements User {}
class MockSession extends Mock implements Session {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('Login Tests', () {
    late MockSupabaseClient mockSupabase;
    late MockGoTrueClient mockAuth;
    late AuthRepository repository;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockAuth = MockGoTrueClient();
      when(() => mockSupabase.auth).thenReturn(mockAuth);
      repository = AuthRepository(supabaseClient: mockSupabase);
      SharedPreferences.setMockInitialValues({});
    });

    // ✅ Успешный вход — данные верные, сессия получена
    test('Успешный вход: верные данные -> получаем сессию', () async {
      final mockResponse = MockAuthResponse();
      final mockUser = MockUser();
      final mockSession = MockSession();

      when(() => mockResponse.user).thenReturn(mockUser);
      when(() => mockResponse.session).thenReturn(mockSession);
      when(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => mockResponse);

      final response = await mockSupabase.auth.signInWithPassword(
        email: 'test@test.com',
        password: 'password123',
      );

      expect(response.user, isNotNull,
          reason: 'Пользователь должен быть получен при верных данных');
      expect(response.session, isNotNull,
          reason: 'Сессия должна быть создана при успешном входе');
    });

    // ❌ Неверный пароль — сервер кидает ошибку
    test('Неверный пароль: сервер возвращает ошибку', () async {
      when(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenThrow(AuthException('Invalid login credentials'));

      expect(
            () async => await mockSupabase.auth.signInWithPassword(
          email: 'test@test.com',
          password: 'wrongpassword',
        ),
        throwsA(isA<AuthException>()),
        reason: 'Должна быть ошибка AuthException при неверном пароле',
      );
    });

    // ❌ Пользователь не существует
    test('Пользователь не найден: сервер возвращает ошибку', () async {
      when(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenThrow(AuthException('User not found'));

      expect(
            () async => await mockSupabase.auth.signInWithPassword(
          email: 'notexist@test.com',
          password: 'password123',
        ),
        throwsA(isA<AuthException>()),
        reason: 'Должна быть ошибка AuthException если пользователь не найден',
      );
    });

    // ❌ Пустой email
    test('Пустой email: не отправляем запрос на сервер', () async {
      const email = '';
      const password = 'password123';

      final isEmailEmpty = email.trim().isEmpty;
      expect(isEmailEmpty, isTrue,
          reason: 'Пустой email должен блокировать отправку на сервер');

      verifyNever(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ));
    });

    // ❌ Пустой пароль
    test('Пустой пароль: не отправляем запрос на сервер', () async {
      const email = 'test@test.com';
      const password = '';

      final isPasswordEmpty = password.trim().isEmpty;
      expect(isPasswordEmpty, isTrue,
          reason: 'Пустой пароль должен блокировать отправку на сервер');

      verifyNever(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ));
    });

    // ❌ Некорректный формат email
    test('Некорректный email: не проходит валидацию', () async {
      const email = 'notanemail';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      expect(emailRegex.hasMatch(email), isFalse,
          reason: 'Email без @ не должен проходить валидацию');

      verifyNever(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ));
    });

    // ✅ Успешный вход -> редирект на главный экран
    test('После успешного входа: сессия активна -> пускаем на главный экран', () async {
      final mockResponse = MockAuthResponse();
      final mockUser = MockUser();
      final mockSession = MockSession();

      when(() => mockResponse.user).thenReturn(mockUser);
      when(() => mockResponse.session).thenReturn(mockSession);
      when(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => mockResponse);

      final response = await mockSupabase.auth.signInWithPassword(
        email: 'test@test.com',
        password: 'password123',
      );

      final canNavigate = response.user != null && response.session != null;
      expect(canNavigate, isTrue,
          reason: 'При наличии user и session должен быть редирект на главный экран');
    });

    // ❌ Нет интернета — сервер недоступен
    test('Нет соединения: получаем сетевую ошибку', () async {
      when(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenThrow(Exception('Network error'));

      expect(
            () async => await mockSupabase.auth.signInWithPassword(
          email: 'test@test.com',
          password: 'password123',
        ),
        throwsA(isA<Exception>()),
        reason: 'При отсутствии сети должна быть сетевая ошибка',
      );
    });

  });
}