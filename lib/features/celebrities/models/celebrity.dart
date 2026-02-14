class Celebrity {
  final int id;
  final String name;
  final String role;
  final String bio;
  final String image;
  final String philosophy; // Used as "Quote"
  final String experience; // Used as "Spotted At"

  Celebrity({
    required this.id,
    required this.name,
    required this.role,
    required this.bio,
    required this.image,
    required this.philosophy,
    required this.experience,
  });

  factory Celebrity.fromJson(Map<String, dynamic> json) {
    return Celebrity(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      bio: json['bio'],
      image: json['image'],
      philosophy: json['philosophy'],
      experience: json['experience'],
    );
  }
}
