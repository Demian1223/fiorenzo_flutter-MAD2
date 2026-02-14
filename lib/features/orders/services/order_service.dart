import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mad2/core/api/api_client.dart';

class OrderService {
  final Dio _dio = ApiClient().dio;

  Future<dynamic> getOrders() async {
    final response = await _dio.get('/api/orders');
    return response.data;
  }

  Future<dynamic> getOrder(int id) async {
    final response = await _dio.get('/api/orders/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    // Try standard REST endpoint first
    try {
      final response = await _dio.post('/api/orders', data: data);
      return response.data;
    } on DioException catch (e) {
      debugPrint(
        "OrderService: Error ${e.response?.statusCode} - ${e.response?.data}",
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(int amount) async {
    try {
      final response = await _dio.post(
        '/api/checkout/payment-intent',
        data: {'amount': amount, 'currency': 'lkr'},
      );
      return response.data;
    } on DioException catch (e) {
      debugPrint(
        "OrderService: Payment Intent Error ${e.response?.statusCode} - ${e.response?.data}",
      );
      rethrow;
    }
  }
}
