import 'dart:convert';

import 'package:lat_uas/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _usersKey = "users";
  static const _loggedInKey = "logged_in_username";

  // ambil semau user terregristrasi

  static Future<List<User>> _getAllUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) {
      return [];
    }
    final List decode = json.decode(raw) as List;
    return decode.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }

  // save semua user

  static Future<void> _saveAllUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = json.encode(users.map((e) => e.toJson()).toList());
    await prefs.setString(_usersKey, raw);
  }

  // Register: kembalikan true jika berhasil, false jika username sudah ada

  static Future<bool> register(String username, String password) async {
    final users = await _getAllUser();
    final exist = users.any((u) => u.username == username);
    if (exist) return false;
    final newUser = User(
      username: username,
      password: password,
      timeStamp: DateTime.now().millisecondsSinceEpoch,
    );
    users.add(newUser);
    await _saveAllUsers(users);
    return true;
  }

  // Login: kembalikan User jika cocok, null jika gagal

  static Future<User?> login(String username, String password) async {
    final users = await _getAllUser();
    final matched = users.where(
      (u) => u.username == username && u.password == password,
    );
    if (matched.isNotEmpty) {
      final user = matched.first;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_loggedInKey, username);
      return user;
    }
    return null;
  }

  //autologin check

  static Future<User?> currentLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_loggedInKey);
    if (username == null) return null;
    final users = await _getAllUser();
    final matched = users.where((u) => u.username == username);
    if (matched.isNotEmpty) {
      return matched.first;
    }
    return null;
  }

  // logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
  }
}
