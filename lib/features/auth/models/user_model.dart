class UserModel {
  final int id;
  final String name;
  final String email;
  final String? profilePhotoUrl;
  final String? role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePhotoUrl,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePhotoUrl: json['profile_photo_url'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_photo_url': profilePhotoUrl,
      'role': role,
    };
  }
}
