class BrandModel {
  final int id;
  final String name;
  final String slug;

  BrandModel({required this.id, required this.name, required this.slug});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(id: json['id'], name: json['name'], slug: json['slug']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'slug': slug};
  }
}
