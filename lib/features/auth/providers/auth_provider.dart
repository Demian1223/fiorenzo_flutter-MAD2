import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mad2/features/auth/models/user_model.dart';
import 'package:mad2/features/auth/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  UserModel? _user;
  String? _token;
  bool _isAppLoading = true; // For initial splash screen
  bool _isLoading = false; // For button spinners
  String? _authError;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _user != null && _token != null;
  bool get isAppLoading => _isAppLoading;
  bool get isLoading => _isLoading;
  String? get authError => _authError;

  Future<void> loadSession() async {
    _isAppLoading = true;
    notifyListeners();

    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        _token = token;
        try {
          final user = await _authService.getUser();
          _user = user;
        } catch (e) {
          debugPrint('Session load error: $e');
          _token = null;
          await _storage.delete(key: 'auth_token');
        }
      }
    } catch (e) {
      debugPrint('Storage error: $e');
    } finally {
      _isAppLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    _isLoading = true;
    _authError = null;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);
      debugPrint("AuthProvider: Login Response: $response");

      _token = response['access_token'] ?? response['token'];

      if (_token == null) {
        _authError = "Authentication failed: No token received from server.";
        return false;
      }

      _user = UserModel.fromJson(response['user']);

      await _storage.write(key: 'auth_token', value: _token);

      return true;
    } on DioException catch (e) {
      _authError = _parseError(e);
      return false;
    } catch (e, stack) {
      debugPrint("AuthProvider: Login Exception: $e\n$stack");
      _authError = 'An unexpected error occurred: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    String confirm,
  ) async {
    _isLoading = true;
    _authError = null;
    notifyListeners();

    try {
      final response = await _authService.register(
        name,
        email,
        password,
        confirm,
      );
      _token = response['access_token'] ?? response['token'];

      if (_token == null) {
        _authError = "Registration failed: No token received from server.";
        return false;
      }

      _user = UserModel.fromJson(response['user']);
      await _storage.write(key: 'auth_token', value: _token);
      return true;
    } on DioException catch (e) {
      _authError = _parseError(e);
      return false;
    } catch (e) {
      _authError = 'Registration failed';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_token != null) {
        await _authService.logout();
      }
    } catch (e) {
      debugPrint("Logout API error: $e");
    } finally {
      await _storage.delete(key: 'auth_token');
      _user = null;
      _token = null;
      _isLoading = false;
      debugPrint("AuthProvider: Logged out locally");
      notifyListeners();
    }
  }

  String _parseError(DioException e) {
    debugPrint('Auth Error Status: ${e.response?.statusCode}');
    debugPrint('Auth Error Data: ${e.response?.data}');

    if (e.response != null && e.response!.data != null) {
      final data = e.response!.data;

      // Handle Map (JSON) response
      if (data is Map<String, dynamic>) {
        // 1. Check for specific 'errors' object (Laravel Validation)
        if (data.containsKey('errors')) {
          final errors = data['errors'];
          if (errors is Map<String, dynamic> && errors.isNotEmpty) {
            // Return the first error message from the first field
            final firstKey = errors.keys.first;
            final firstList = errors[firstKey];
            if (firstList is List && firstList.isNotEmpty) {
              return firstList.first.toString();
            }
          }
        }

        // 2. Check for top-level 'message' (Laravel formatted error)
        if (data.containsKey('message')) {
          return data['message'].toString();
        }

        // 3. Fallback for other JSON fields like 'error'
        if (data.containsKey('error')) {
          return data['error'].toString();
        }
      }

      // Handle String response
      if (data is String) {
        return data; // Return raw string if server sends plain text
      }
    }

    // Fallback if no response data
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Check your internet.';
    }

    return e.message ?? 'An unexpected error occurred.';
  }
}
