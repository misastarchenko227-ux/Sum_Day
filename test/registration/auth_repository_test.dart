import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../lib/repository/repository.dart';

// Импортируйте ваш репозиторий (укажите правильный путь к вашему файлу)
// import 'package:sum_day/repository/auth_repository.dart';

// 1. СОЗДАЕМ КЛАССЫ-ЗАГЛУШКИ (МОКИ)
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {} // Клиент для auth
class MockAuthResponse extends Mock implements AuthResponse {}
class MockUser extends Mock implements User {}

void main() {
  // Регистрируем fallback значения для mocktail (нужно, если передаем сложные объекты)
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('AuthRepository Tests', () {
    late MockSupabaseClient mockSupabase;
    late MockGoTrueClient mockAuth;
    late AuthRepository repository;

    // Этот код запускается перед КАЖДЫМ тестом
    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockAuth = MockGoTrueClient();

      // Говорим: когда кто-то просит supabase.auth, отдай наш мок mockAuth
      when(() => mockSupabase.auth).thenReturn(mockAuth);

      repository = AuthRepository(supabaseClient: mockSupabase);

      // Очищаем локальное хранилище перед каждым тестом
      SharedPreferences.setMockInitialValues({});
    });

    test('Успешная регистрация сохраняет галочку "Запомнить меня"', () async {
      // Подготовка (Arrange)
      final mockResponse = MockAuthResponse();
      final mockUser = MockUser();

      // Настраиваем фейковый успешный ответ от Supabase
      when(() => mockResponse.user).thenReturn(mockUser);
      when(() => mockAuth.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        data: any(named: 'data'),
      )).thenAnswer((_) async => mockResponse); // Мгновенный ответ без интернета!

      // Действие (Act)
      final isSuccess = await repository.registerUser(
        email: 'test@test.com',
        password: 'password123',
        name: 'John',
        rememberMe: true, // Пользователь поставил гавлочку
      );

      // Проверка (Assert)
      expect(isSuccess, isTrue); // Метод должен вернуть true

      // Проверяем, что галочка реально сохранилась локально
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('remember_me'), isTrue);
    });

    test('Проверка авторизации: сессия есть и галочка стоит -> пускаем', () async {
      SharedPreferences.setMockInitialValues({'remember_me': true});

      final mockResponse = MockAuthResponse();
      final mockSession = MockSession();

      when(() => mockResponse.session).thenReturn(mockSession);
      when(() => mockAuth.refreshSession()).thenAnswer((_) async => mockResponse);

      final isLoggedIn = await repository.isUserLoggedInAndRemembered();

      expect(isLoggedIn, isTrue);
    });

    test('Проверка авторизации: сессия есть, НО галочки нет -> разлогиниваем', () async {
      SharedPreferences.setMockInitialValues({'remember_me': false});

      final isLoggedIn = await repository.isUserLoggedInAndRemembered();

      expect(isLoggedIn, isFalse);
      verifyNever(() => mockAuth.refreshSession());
    });

    test('Проверка авторизации: refreshSession упал -> разлогиниваем', () async {
      SharedPreferences.setMockInitialValues({'remember_me': true});

      when(() => mockAuth.refreshSession()).thenThrow(Exception('User not found'));
      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      final isLoggedIn = await repository.isUserLoggedInAndRemembered();

      expect(isLoggedIn, isFalse);
      verify(() => mockAuth.signOut()).called(1);
    });

  });
}

// Заглушка для сессии (нужна только для тестов выше)
class MockSession extends Mock implements Session {}