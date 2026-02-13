import 'product.dart';

class OrderItem {
  final int id;
  final int productId;
  final int quantity;
  final double unitPrice; // Stored price at time of order
  final Product? product;

  OrderItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      // Handle potentially string or num type
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0.0,
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }
}

class Order {
  final int id;
  final String status;
  final double totalAmount;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'] ?? 'pending',
      totalAmount:
          double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
      createdAt: DateTime.parse(json['created_at']),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}
