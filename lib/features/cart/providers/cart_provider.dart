import 'package:flutter/material.dart';
import 'package:mad2/models/cart_item.dart';
import 'package:mad2/features/cart/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _service = CartService();

  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _error;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Computed properties
  double get subtotal => _items.fold(0, (sum, item) {
    final price = double.tryParse(item.product?.price ?? '0') ?? 0;
    return sum + (price * item.quantity);
  });

  double get total => subtotal; // Add delivery fee logic later if needed

  Future<void> fetchCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.getCart();

      List<dynamic> data = [];
      if (response is List) {
        data = response;
      } else if (response is Map) {
        data =
            response['cart_items'] ??
            response['cart'] ??
            response['data'] ??
            [];
      }

      debugPrint("CartProvider: Parsed ${data.length} items");
      _items = data
          .map((json) {
            try {
              return CartItem.fromJson(json);
            } catch (e) {
              debugPrint("Error parsing cart item: $e");
              return null;
            }
          })
          .whereType<CartItem>()
          .toList();
    } catch (e) {
      _error = e.toString();
      debugPrint("Cart fetch error: $_error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(int productId, {int quantity = 1}) async {
    _isLoading = true;
    notifyListeners();
    debugPrint("CartProvider: Adding product $productId to cart...");

    try {
      final response = await _service.addToCart(productId, quantity);
      debugPrint("CartProvider: Add to cart response: $response");

      await fetchCart(); // Refresh cart
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint("CartProvider: Add to cart error: $_error");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    try {
      await _service.removeFromCart(cartItemId);
      _items.removeWhere((item) => item.id == cartItemId);
      notifyListeners();
    } catch (e) {
      debugPrint("Remove cart error: $e");
    }
  }

  Future<void> updateQuantity(int cartItemId, int newQuantity) async {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index == -1) return;

    final oldQuantity = _items[index].quantity;

    // 1. Optimistic Update
    _items[index] = _items[index].copyWith(quantity: newQuantity);
    notifyListeners();

    try {
      await _service.updateCartItem(cartItemId, newQuantity);
    } catch (e) {
      debugPrint("Update quantity error: $e");
      // Revert on failure
      _items[index] = _items[index].copyWith(quantity: oldQuantity);
      notifyListeners();
    }
  }

  void clear() {
    _items = [];
    notifyListeners();
  }
}
