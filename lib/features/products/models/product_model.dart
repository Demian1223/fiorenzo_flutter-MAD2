import 'package:mad2/core/config/app_config.dart';

class ProductModel {
  final int id;
  final String name;
  final String? description;
  final String price;
  final String imageUrl;
  final String gender; // "men" or "women"
  final String brandName;
  final String categoryName;
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
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'] ?? 'Unknown Product',
      description: json['description'],
      price: json['price'].toString(),
      imageUrl: json['image_url'] ?? '',
      gender: json['gender'] ?? 'unisex',
      brandName:
          json['brand_name'] ??
          'FIORENZO', // API should send this or we map from brand object
      categoryName: json['category_name'] ?? 'General', // API should send this
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'gender': gender,
      'brand_name': brandName,
      'category_name': categoryName,
      'images': images,
    };
  }

  String get fullImageUrl {
    if (imageUrl.startsWith('http')) {
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
