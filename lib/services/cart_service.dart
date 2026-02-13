import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mad2/core/api/api_client.dart';

class CartService {
  final Dio _dio = ApiClient().dio;

  Future<dynamic> getCart() async {
    final response = await _dio.get('/api/cart');
    debugPrint(
      "CartService: GET /api/cart response type: ${response.data.runtimeType}",
    );
    return response.data;
  }

  Future<Map<String, dynamic>> addToCart(int productId, int quantity) async {
    try {
      debugPrint(
        "CartService: POST /api/cart with product_id=$productId, quantity=$quantity",
      );
      final response = await _dio.post(
        '/api/cart',
        data: {'product_id': productId, 'quantity': quantity},
      );
      debugPrint("CartService: Success ${response.statusCode}");
      return response.data;
    } on DioException catch (e) {
      debugPrint(
        "CartService: Error ${e.response?.statusCode} - ${e.response?.data}",
      );
      rethrow;
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    await _dio.delete('/api/cart/$cartItemId');
  }

  Future<void> clearCart() async {
    // Optional: Only if API supports it, otherwise loop delete
    // awaiting API verify
  }
}
