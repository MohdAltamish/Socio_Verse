import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false) {
    _init();
  }

  Future<void> _init() async {
    final box = await Hive.openBox('settings');
    final isAuthenticated = box.get('isAuthenticated', defaultValue: false);
    state = isAuthenticated;
  }

  Future<void> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final box = await Hive.openBox('settings');
    await box.put('isAuthenticated', true);
    state = true;
  }

  Future<void> logout() async {
    final box = await Hive.openBox('settings');
    await box.put('isAuthenticated', false);
    state = false;
  }
}
