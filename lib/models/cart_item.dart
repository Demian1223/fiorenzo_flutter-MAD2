import 'product.dart';

class CartItem {
  final int id;
  final int productId;
  final int quantity;
  final Product? product;

  CartItem({
    required this.id,
    required this.productId,
    required this.quantity,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'] ?? 1,
      // Check for nested 'product' object
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }
}
