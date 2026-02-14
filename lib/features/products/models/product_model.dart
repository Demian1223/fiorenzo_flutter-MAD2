import 'package:mad2/core/config/app_config.dart';

class ProductModel {
  final int id;
  final String name;
  final String? description;
  final String price;
  final String imageUrl;
  final String gender;
  final String brandName;
  final String categoryName;
  // New fields for SQLite & robust data
  final int stock;
  final int? categoryId;
  final int? brandId;
  final String? updatedAt;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.imageUrl,
    required this.gender,
    required this.brandName,
    required this.categoryName,
    this.stock = 0,
    this.categoryId,
    this.brandId,
    this.updatedAt,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'] ?? 'Unknown Product',
      description: json['description'],
      price: json['price'].toString(),
      stock: json['stock'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      gender: json['gender'] ?? 'unisex',
      // Safely handle nested objects if API sends them, or flat fields
      brandId: json['brand'] is Map ? json['brand']['id'] : json['brand_id'],
      brandName: json['brand'] is Map
          ? json['brand']['name']
          : (json['brand_name'] ?? 'FIORENZO'),
      categoryId: json['category'] is Map
          ? json['category']['id']
          : json['category_id'],
      categoryName: json['category'] is Map
          ? json['category']['name']
          : (json['category_name'] ?? 'General'),
      updatedAt: json['updated_at'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }

  // For SQLite insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
      'gender': gender,
      'brand_id': brandId,
      'brand_name': brandName,
      'category_id': categoryId,
      'category_name': categoryName,
      'updated_at': updatedAt,
    };
  }

  // For SQLite retrieval
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      stock: map['stock'] ?? 0,
      imageUrl: map['image_url'],
      gender: map['gender'],
      brandId: map['brand_id'],
      brandName: map['brand_name'],
      categoryId: map['category_id'],
      categoryName: map['category_name'],
      updatedAt: map['updated_at'],
      // SQLite doesn't store List<String> natively easily without joining
      // For now, we reuse the single image_url as a list item if needed
      // Or we could store images as a JSON string.
      // Given the requirement, we'll keep it simple for now.
      images: [map['image_url']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
      'gender': gender,
      'brand_name': brandName,
      'category_name': categoryName,
      'images': images,
    };
  }

  String get fullImageUrl {
    if (imageUrl.startsWith('http') || imageUrl.startsWith('assets/')) {
      return imageUrl;
    }
    final cleanPath = imageUrl.startsWith('/')
        ? imageUrl.substring(1)
        : imageUrl;
    return '${AppConfig.baseUrl}/$cleanPath';
  }

  // Helper to get full URLs for the gallery
  List<String> get fullImages {
    if (images.isEmpty) return [fullImageUrl];
    return images.map((img) {
      if (img.startsWith('http')) return img;
      final clean = img.startsWith('/') ? img.substring(1) : img;
      return '${AppConfig.baseUrl}/$clean';
    }).toList();
  }
}
