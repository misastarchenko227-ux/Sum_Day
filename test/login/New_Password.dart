import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../lib/repository/repository.dart';
import 'Login.dart';

void main() {
  group('AuthRepository - sendPasswordResetEmail', () {
    late MockSupabaseClient mockClient;
    late MockGoTrueClient mockAuth;
    late AuthRepository repository;

    setUp(() {
      mockClient = MockSupabaseClient();
      mockAuth = MockGoTrueClient();
      when(() => mockClient.auth).thenReturn(mockAuth);
      repository = AuthRepository(supabaseClient: mockClient);
    });

    test('отправляет письмо с правильным redirectTo', () async {
      when(() => mockAuth.resetPasswordForEmail(
        any(),
        redirectTo: any(named: 'redirectTo'),
      )).thenAnswer((_) async {});

      await repository.sendPasswordResetEmail(email: 'test@test.com');

      verify(() => mockAuth.resetPasswordForEmail(
        'test@test.com',
        redirectTo: 'sumday://reset-password',
      )).called(1);
    });

    test('не выбрасывает ошибку если email не существует', () async {
      when(() => mockAuth.resetPasswordForEmail(
        any(),
        redirectTo: any(named: 'redirectTo'),
      )).thenThrow(Exception('User not found'));

      // Не должно выбросить ошибку
      expect(
            () => repository.sendPasswordResetEmail(email: 'nouser@test.com'),
        returnsNormally,
      );
    });
  });
}