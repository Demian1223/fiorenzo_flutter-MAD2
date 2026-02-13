import 'package:dio/dio.dart';
import 'package:mad2/core/api/api_client.dart';
import 'package:mad2/features/auth/models/user_model.dart';

class AuthService {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post(
      '/api/login',
      data: {'email': email, 'password': password},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final response = await _dio.post(
      '/api/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    return response.data;
  }

  Future<UserModel> getUser() async {
    final response = await _dio.get('/api/me');
    // Note: Laravel resource wrapping might require response.data['data'] depending on API
    // Using direct mapping based on user prompt example: { "id": 1 ... } (no wrapper shown in example)
    return UserModel.fromJson(response.data);
  }

  Future<void> logout() async {
    try {
      await _dio.post('/api/logout');
    } catch (e) {
      // Ignore network errors on logout
    }
  }
}
