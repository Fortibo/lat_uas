import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lat_uas/models/user.dart';
import 'package:lat_uas/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AuthService', () {
    setUp(() async {
      // Ensure a clean in-memory storage before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('register should store a new user and return true', () async {
      final result = await AuthService.register('alice', 'secret');
      expect(result, isTrue);

      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('users');
      expect(raw, isNotNull);

      final list = (json.decode(raw!) as List)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();
      expect(list.length, 1);
      expect(list.first.username, 'alice');
    });

    test('register should return false when username already exists', () async {
      // Preload storage with one user
      SharedPreferences.setMockInitialValues({
        'users': json.encode([
          User(username: 'bob', password: 'pw', timeStamp: 1).toJson(),
        ]),
      });

      final result = await AuthService.register('bob', 'new');
      expect(result, isFalse);

      // Ensure original users remain unchanged in terms of count
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('users');
      final list = (json.decode(raw!) as List)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();
      expect(list.length, 1);
      expect(list.first.password, 'pw');
    });

    test(
      'login should set logged_in_username and return the user on success',
      () async {
        // Seed with a valid user
        SharedPreferences.setMockInitialValues({
          'users': json.encode([
            User(username: 'carol', password: '123', timeStamp: 2).toJson(),
          ]),
        });

        final user = await AuthService.login('carol', '123');
        expect(user, isNotNull);
        expect(user!.username, 'carol');

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('logged_in_username'), 'carol');
      },
    );

    test(
      'login should return null and not set logged_in_username on failure',
      () async {
        SharedPreferences.setMockInitialValues({
          'users': json.encode([
            User(username: 'dave', password: 'abc', timeStamp: 3).toJson(),
          ]),
        });

        final user = await AuthService.login('dave', 'wrong');
        expect(user, isNull);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('logged_in_username'), isNull);
      },
    );

    test(
      'currentLoggedInUser should return the logged in user if exists',
      () async {
        SharedPreferences.setMockInitialValues({
          'users': json.encode([
            User(username: 'erin', password: 'xyz', timeStamp: 4).toJson(),
          ]),
          'logged_in_username': 'erin',
        });

        final user = await AuthService.currentLoggedInUser();
        expect(user, isNotNull);
        expect(user!.username, 'erin');
      },
    );

    test(
      'currentLoggedInUser should return null when no one logged in',
      () async {
        SharedPreferences.setMockInitialValues({
          'users': json.encode([
            User(username: 'frank', password: '111', timeStamp: 5).toJson(),
          ]),
        });

        final user = await AuthService.currentLoggedInUser();
        expect(user, isNull);
      },
    );

    test('logout should clear logged_in_username', () async {
      SharedPreferences.setMockInitialValues({
        'users': json.encode([
          User(username: 'gina', password: '222', timeStamp: 6).toJson(),
        ]),
        'logged_in_username': 'gina',
      });

      await AuthService.logout();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('logged_in_username'), isNull);
    });

    test('register should treat usernames as case-sensitive', () async {
      // Register two users that differ only by case
      final first = await AuthService.register('Alice', 'p1');
      final second = await AuthService.register('alice', 'p2');

      expect(first, isTrue);
      expect(second, isTrue);

      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('users');
      expect(raw, isNotNull);
      final list = (json.decode(raw!) as List)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();
      expect(list.length, 2);
      expect(list.any((u) => u.username == 'Alice'), isTrue);
      expect(list.any((u) => u.username == 'alice'), isTrue);
    });

    test('login should succeed with empty password if stored as such', () async {
      // Register a user with an empty password
      final ok = await AuthService.register('hank', '');
      expect(ok, isTrue);

      final user = await AuthService.login('hank', '');
      expect(user, isNotNull);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('logged_in_username'), 'hank');
    });

    test('currentLoggedInUser should return null if saved username is unknown', () async {
      // Seed a different user but set logged_in_username to a non-existing name
      SharedPreferences.setMockInitialValues({
        'users': json.encode([
          User(username: 'ivy', password: 'pw', timeStamp: 7).toJson(),
        ]),
        'logged_in_username': 'ghost',
      });

      final user = await AuthService.currentLoggedInUser();
      expect(user, isNull);
    });

    test('logout should be idempotent when no user is logged in', () async {
      // Seed users but no logged_in_username
      SharedPreferences.setMockInitialValues({
        'users': json.encode([
          User(username: 'john', password: 'pw', timeStamp: 8).toJson(),
        ]),
      });

      await AuthService.logout();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('logged_in_username'), isNull);

      // Ensure users list remains intact
      final raw = prefs.getString('users');
      final list = (json.decode(raw!) as List)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();
      expect(list.length, 1);
      expect(list.first.username, 'john');
    });

    test('login then logout should make currentLoggedInUser return null', () async {
      // Seed with a valid user and login
      SharedPreferences.setMockInitialValues({
        'users': json.encode([
          User(username: 'kate', password: 'zzz', timeStamp: 9).toJson(),
        ]),
      });

      final loggedIn = await AuthService.login('kate', 'zzz');
      expect(loggedIn, isNotNull);

      var current = await AuthService.currentLoggedInUser();
      expect(current, isNotNull);
      expect(current!.username, 'kate');

      // Now logout and verify
      await AuthService.logout();
      current = await AuthService.currentLoggedInUser();
      expect(current, isNull);
    });
  });
}
