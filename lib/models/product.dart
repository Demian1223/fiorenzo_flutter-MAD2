import 'package:mad2/core/config/app_config.dart';

class Product {
  final int id;
  final String name;
  final String slug;
  final String price;
  final String? description;
  final String imageUrl;
  final String gender;
  final String brandName;
  final String categoryName;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    this.description,
    required this.imageUrl,
    required this.gender,
    required this.brandName,
    required this.categoryName,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? 'Unknown Product',
      slug: json['slug'] ?? '',
      price: json['price'].toString(),
      description: json['description'],
      imageUrl: json['image_url'] ?? '',
      gender: json['gender'] ?? 'unisex',
      brandName: json['brand_name'] ?? 'FIORENZO',
      categoryName: json['category_name'] ?? 'General',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }

  String get fullImageUrl {
    if (imageUrl.startsWith('http')) return imageUrl;
    final cleanPath = imageUrl.startsWith('/')
        ? imageUrl.substring(1)
        : imageUrl;
    return '${AppConfig.baseUrl}/$cleanPath';
  }

  List<String> get fullImages {
    if (images.isEmpty) return [fullImageUrl];
    return images.map((img) {
      if (img.startsWith('http')) return img;
      final clean = img.startsWith('/') ? img.substring(1) : img;
      return '${AppConfig.baseUrl}/$clean';
    }).toList();
  }
}
