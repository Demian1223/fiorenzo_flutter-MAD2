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
      id: int.tryParse(json['id'].toString()) ?? 0,
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
      // Check for nested 'product' object
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }

  CartItem copyWith({
    int? id,
    int? productId,
    int? quantity,
    Product? product,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }
}
