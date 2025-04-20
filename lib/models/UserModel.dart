class User {
  final int id;
  final String name;
  final int imageVersion;

  User({required this.id, required this.name, required this.imageVersion});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      imageVersion: json["imageVersion"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageVersion': imageVersion
    };
  }
}
