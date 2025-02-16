import 'dart:developer';

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

    return await _supabase
        .from('users')
        .upsert({'id': userID, 'username': username});
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  getCurrentUser() {
    final session = _supabase.auth.currentSession;
    return session?.user;
  }

  Future<dynamic> getCurrentUserProfile() async {
    final user = getCurrentUser();

    final userProfile =
        await _supabase.from('users').select().eq('id', user.id).single();

    inspect(userProfile);

    return userProfile;
  }

  Future uploadProfileImage(path, file) async {
    await _supabase.storage.from('image').upload(path, file);

    // Get the public URL
    final String imageUrl = _supabase.storage.from('image').getPublicUrl(path);

    final user = getCurrentUser();

    await _supabase.from('users').update({'image': imageUrl}).eq('id', user.id);
  }

  Future<void> updateAdress(double lat, double long, String address) async {
    final user = getCurrentUser();

    await _supabase.from('users').update({
      'address': {
        'lat': lat,
        'long': long,
        'address': address,
      }
    }).eq('id', user.id);
  }
}
