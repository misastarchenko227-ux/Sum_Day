import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  // Передаем клиента через конструктор (это позволит нам подменить его в тестах)
  final SupabaseClient supabaseClient;

  AuthRepository({required this.supabaseClient});

  /// Функция регистрации
  Future<bool> registerUser({
    required String email,
    required String password,
    required String name,
    required bool rememberMe,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      // Если пользователь успешно создан
      if (response.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('remember_me', rememberMe);
        return true;
      }
      return false;
    } catch (e) {
      // Здесь можно пробросить ошибку дальше, чтобы показать SnackBar в UI
      rethrow;
    }
  }

  /// Функция проверки при запуске приложения
  Future<bool> isUserLoggedInAndRemembered() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;

    // Если галочки изначально нет, то даже в сеть идти не надо — сразу на регистрацию
    if (!rememberMe) {
      return false;
    }

    try {
      // КЛЮЧЕВОЙ МОМЕНТ: вместо статического currentSession мы просим Supabase
      // обновить сессию. Этот метод ЖЕСТКО делает запрос на сервера Supabase.
      final response = await supabaseClient.auth.refreshSession();

      // Если сервер подтвердил, что сессия и пользователь живы
      if (response.session != null) {
        return true; // Пускаем на главный экран
      }
      return false;
    } catch (e) {
      // Если пользователь удален в БД, refreshSession выкинет ошибку (например, User not found)
      // В таком случае принудительно очищаем локальный мусор и не пускаем
      await supabaseClient.auth.signOut();
      return false;
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null && response.session != null) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
  /// Сброс пароля — всегда возвращает true (безопасность: не раскрываем существование аккаунта)
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
    } catch (e) {
      // Намеренноглотаем ошибку — не раскрываем существует ли аккаунт
    }
  }
}