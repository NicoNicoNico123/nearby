// lib/core/network/hive_service.dart
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/auth/data/models/user_hive_model.dart';

class HiveService {
  static const String _userBox = 'user_box';
  static const String _tokenBox = 'token_box';

  // Fallback storage for web when Hive fails
  static String? _webToken;
  static UserHiveModel? _webUser;

  static Future<void> init() async {
    try {
      // Initialize Hive differently for web vs mobile
      if (kIsWeb) {
        // For web, use in-memory storage
        await Hive.initFlutter();
      } else {
        // For mobile/desktop, use file system
        final appDocumentDir =
            await path_provider.getApplicationDocumentsDirectory();
        await Hive.initFlutter(appDocumentDir.path);
      }

      // Register adapters
      Hive.registerAdapter(UserHiveModelAdapter());

      // Open boxes
      await Future.wait([
        Hive.openBox<UserHiveModel>(_userBox),
        Hive.openBox<String>(_tokenBox),
      ]);
      print('[HiveService] Initialized successfully'); // Debug log
    } catch (e) {
      print('[HiveService] Initialization failed: $e'); // Debug log
      // On web, if Hive fails, we'll continue without local storage
      if (!kIsWeb) {
        throw const CacheFailure('Failed to initialize Hive');
      } else {
        print('[HiveService] Continuing without local storage on web'); // Debug log
      }
    }
  }

  static Future<void> close() async {
    try {
      await Hive.close();
      print('[HiveService] Closed successfully'); // Debug log
    } catch (e) {
      print('[HiveService] Close failed: $e'); // Debug log
      throw const CacheFailure('Failed to close Hive');
    }
  }

  static Box<UserHiveModel> get userBox => Hive.box<UserHiveModel>(_userBox);
  static Box<String> get tokenBox => Hive.box<String>(_tokenBox);

  static const String _authTokenKey = 'auth_token';

  static Future<void> cacheAuthToken(String token) async {
    try {
      await tokenBox.put(_authTokenKey, token);
      print('[HiveService] Token cached successfully: $token'); // Debug log
    } catch (e) {
      print('[HiveService] Failed to cache token: $e'); // Debug log
      // On web, use fallback storage
      if (kIsWeb) {
        _webToken = token;
        print('[HiveService] Using web fallback for token: $token');
      } else {
        throw const CacheFailure('Failed to cache auth token');
      }
    }
  }

  static String? getAuthToken() {
    try {
      final token = tokenBox.get(_authTokenKey);
      print('[HiveService] Retrieved token: $token'); // Debug log
      return token;
    } catch (e) {
      print('[HiveService] Failed to get token: $e'); // Debug log
      // On web, use fallback storage
      if (kIsWeb) {
        print('[HiveService] Using web fallback token: $_webToken');
        return _webToken;
      }
      throw const CacheFailure('Failed to get auth token');
    }
  }

  static Future<void> cacheUser(UserHiveModel user) async {
    try {
      await userBox.put('current_user', user);
      print(
        '[HiveService] User cached successfully: ${user.email}',
      ); // Debug log
    } catch (e) {
      print('[HiveService] Failed to cache user: $e'); // Debug log
      // On web, use fallback storage
      if (kIsWeb) {
        _webUser = user;
        print('[HiveService] Using web fallback for user: ${user.email}');
      } else {
        throw const CacheFailure('Failed to cache user');
      }
    }
  }

  static Future<Option<UserHiveModel>> getCachedUser() async {
    try {
      final user = userBox.get('current_user');
      print('[HiveService] Retrieved user: ${user?.email}'); // Debug log
      return user != null ? optionOf(user) : none();
    } catch (e) {
      print('[HiveService] Failed to get cached user: $e'); // Debug log
      // On web, use fallback storage
      if (kIsWeb) {
        print('[HiveService] Using web fallback user: ${_webUser?.email}');
        return _webUser != null ? optionOf(_webUser!) : none();
      }
      return none();
    }
  }

  static Future<void> clearCachedUser() async {
    try {
      await userBox.delete('current_user');
      await tokenBox.delete(_authTokenKey);
      print('[HiveService] Cleared cached user and token'); // Debug log
    } catch (e) {
      print('[HiveService] Failed to clear cached user: $e'); // Debug log
    }
    // Always clear fallback storage on web
    if (kIsWeb) {
      _webUser = null;
      _webToken = null;
      print('[HiveService] Cleared web fallback storage');
    }
  }

  static Future<bool> isUserLoggedIn() async {
    try {
      final token = getAuthToken();
      final isLoggedIn = token != null && token.isNotEmpty;
      print(
        '[HiveService] isUserLoggedIn check: $isLoggedIn (token: $token)',
      ); // Debug log
      return isLoggedIn;
    } catch (e) {
      print('[HiveService] Failed to check login status: $e'); // Debug log
      return false;
    }
  }

  static Future<void> clearAllData() async {
    try {
      await userBox.clear();
      await tokenBox.clear();
      print('[HiveService] Cleared all data'); // Debug log
    } catch (e) {
      print('[HiveService] Failed to clear all data: $e'); // Debug log
      throw const CacheFailure('Failed to clear Hive data');
    }
  }
}
