import 'package:supabase_flutter/supabase_flutter.dart';

class LoginResult {
  const LoginResult({this.user, this.errorMessage});

  final Map<String, dynamic>? user;
  final String? errorMessage;

  bool get isSuccess => user != null && errorMessage == null;
}

class AuthHelper {
  static final AuthHelper instance = AuthHelper._init();

  AuthHelper._init();

  SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  /// Register user baru via Supabase Auth. Return null jika berhasil, error message jika gagal.
  Future<String?> register(
      String fullName, String email, String password) async {
    final client = _client;
    if (client == null) {
      return 'Layanan autentikasi belum siap. Periksa konfigurasi Supabase.';
    }

    try {
      final response = await client.auth.signUp(
        email: email.trim().toLowerCase(),
        password: password,
        data: {'full_name': fullName.trim()},
      );
      if (response.user == null) {
        return 'Pendaftaran gagal';
      }
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Terjadi kesalahan saat mendaftar. Coba lagi nanti.';
    }
  }

  Future<LoginResult> loginWithPassword(String email, String password) async {
    final client = _client;
    if (client == null) {
      return const LoginResult(
        errorMessage:
            'Layanan autentikasi belum siap. Periksa konfigurasi Supabase.',
      );
    }

    try {
      final response = await client.auth.signInWithPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      if (response.user == null) {
        return const LoginResult(errorMessage: 'Email atau password salah');
      }

      final user = response.user!;
      return LoginResult(
        user: {
          'id': user.id,
          'fullName': user.userMetadata?['full_name'] ??
              user.email?.split('@').first ??
              'User',
          'email': user.email,
        },
      );
    } on AuthException catch (e) {
      return LoginResult(errorMessage: e.message);
    } catch (_) {
      return const LoginResult(
        errorMessage:
            'Tidak dapat login. Periksa koneksi internet lalu coba lagi.',
      );
    }
  }

  /// Backward-compatible login helper. Prefer [loginWithPassword] for error details.
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final result = await loginWithPassword(email, password);
    return result.user;
  }

  /// Cek apakah sudah login (Supabase session aktif)
  Future<bool> isLoggedIn() async {
    final client = _client;
    if (client == null) return false;
    return client.auth.currentSession != null;
  }

  /// Ambil data user yang sedang login dari Supabase
  Future<Map<String, String>> getCurrentUser() async {
    final user = _client?.auth.currentUser;
    if (user == null) {
      return {
        'name': 'User',
        'email': '',
      };
    }
    return {
      'name': user.userMetadata?['full_name'] ??
          user.email?.split('@').first ??
          'User',
      'email': user.email ?? '',
    };
  }

  /// Logout dari Supabase
  Future<void> logout() async {
    await _client?.auth.signOut();
  }
}
