import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mad2/models/order.dart';
import 'package:mad2/features/orders/services/order_service.dart';

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
      final List<dynamic> data;
      if (response is List) {
        data = response;
      } else if (response is Map) {
        data = response['orders'] ?? response['data'] ?? [];
      } else {
        data = [];
      }
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
      if (e.response?.statusCode == 422 || e.response?.statusCode == 400) {
        // Validation (422) or Bad Request (400)
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          _error = data['message'];
          if (data.containsKey('errors')) {
            _error = "$_error: ${data['errors']}";
          }
        } else {
          _error =
              "Server Error (${e.response?.statusCode}): ${e.response?.data}";
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
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _service.createPaymentIntent(amount);
      return response;
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          _error = data['message'] ?? data['error'] ?? e.message;
        } else {
          _error = e.response!.data.toString();
        }
      } else {
        _error = e.message ?? "Connection Error";
      }
      debugPrint("Create payment intent error: $_error");
      return null;
    } catch (e) {
      _error = e.toString();
      debugPrint("Create payment intent error: $_error");
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
