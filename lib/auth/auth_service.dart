import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUpwithEmailPassword(
    String username,
    String email,
    String password,
  ) async {
    final usernameExist = await _supabase
        .from('users')
        .select('username')
        .ilike('username', username);

    if (usernameExist.isNotEmpty) {
      throw Exception("Username already exist");
    }

    final userData = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final userID = userData.user?.id;

    await _supabase.from('users').upsert({'id': userID, 'username': username});
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  getCurrentUser() {
    final session = _supabase.auth.currentSession;
    return session?.user;
  }
}
