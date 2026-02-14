import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mad2/core/config/app_config.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Debugging: Force user provided token
          final token = await _storage.read(key: 'auth_token');
          // const token = '18|i1q2P9I2fd2m0YryMI0Re7aIzhyQmt82NaxJKj6I741b028f';

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          debugPrint("ApiClient: Request ${options.uri}");
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Log detailed error for debugging
          if (e.response != null) {
            debugPrint(
              "ApiClient: Error ${e.response!.statusCode} ${e.requestOptions.uri}",
            );
            debugPrint("ApiClient: Data: ${e.response!.data}");
          } else {
            debugPrint("ApiClient: Error ${e.message}");
          }
          // Handle 401 Unauthorized globally if needed (optional interceptor logic)
          // For now, we pass it down to be handled by the repository/provider
          // to avoid circular dependency with AuthProvider or context.
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
