import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product.dart';
import '../models/order.dart';

class ApiService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl =
      'http://127.0.0.1:8000/api'; // Use 10.0.2.2 for Android Emulator

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add interceptor for auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  // Auth
  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      final token = response.data['token'];
      await _storage.write(key: 'auth_token', value: token);
      return token;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  // Products
  Future<List<Product>> getProducts({String? gender, int? categoryId}) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {
          if (gender != null) 'gender': gender,
          if (categoryId != null) 'category_id': categoryId,
        },
      );

      final data = response.data['data'] as List;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Get Products Error: $e');
      return [];
    }
  }

  Future<Product?> getProduct(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      print('Get Product Error: $e');
      return null;
    }
  }

  // Cart
  Future<Map<String, dynamic>> getCart() async {
    try {
      final response = await _dio.get('/cart');
      return response.data; // Expecting { cart: [...], total: ... }
    } catch (e) {
      print('Get Cart Error: $e');
      return {};
    }
  }

  Future<bool> addToCart(int productId, int quantity) async {
    try {
      await _dio.post(
        '/cart',
        data: {'product_id': productId, 'quantity': quantity},
      );
      return true;
    } catch (e) {
      print('Add to Cart Error: $e');
      return false;
    }
  }

  Future<bool> removeFromCart(int id) async {
    try {
      await _dio.delete('/cart/$id');
      return true;
    } catch (e) {
      print('Remove Cart Error: $e');
      return false;
    }
  }

  // Orders
  Future<List<Order>> getOrders() async {
    try {
      final response = await _dio.get('/orders');
      final data = response.data as List;
      return data.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      print('Get Orders Error: $e');
      return [];
    }
  }

  Future<Order?> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await _dio.post('/orders', data: orderData);
      return Order.fromJson(
        response.data,
      ); // Assuming API returns the created order
    } catch (e) {
      print('Create Order Error: $e');
      return null;
    }
  }
}
