import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mad2/models/order.dart';
import 'package:mad2/services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService();

  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.getOrders();
      // Assuming API returns list directly or wrapped in 'data'
      // Based on screenshot 2, it returns a List directly
      final List<dynamic> data = response is List
          ? response
          : (response['data'] ?? []);
      _orders = data.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
      debugPrint("Fetch orders error: $_error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> createOrder(
    Map<String, dynamic> orderData,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _service.createOrder(orderData);
      // Wait for success, then refresh orders
      await fetchOrders();
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        // Validation error
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          _error = data['message']; // e.g., "The given data was invalid."
          if (data.containsKey('errors')) {
            _error = "$_error: ${data['errors']}";
          }
        } else {
          _error = "Validation Error: ${e.response?.data}";
        }
      } else {
        _error = e.message ?? e.toString();
      }
      debugPrint("Create order error: $_error");
      return null;
    } catch (e) {
      _error = e.toString();
      debugPrint("Create order error: $_error");
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(int amount) async {
    try {
      return await _service.createPaymentIntent(amount);
    } catch (e) {
      _error = e.toString();
      debugPrint("Create payment intent error: $_error");
      return null;
    }
  }
}
