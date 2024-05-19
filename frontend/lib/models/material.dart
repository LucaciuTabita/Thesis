class Material {
  final int id;
  final String name;
  final String description;
  final String photoPath;

  Material({
    required this.id,
    required this.name,
    required this.description,
    required this.photoPath,
  });

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      photoPath: json['photo_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'photo_path': photoPath,
    };
  }
}