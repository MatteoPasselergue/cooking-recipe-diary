class Category {
  final int id;
  final String name;
  final String iconName;

  Category({required this.iconName,
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      iconName: json['icon_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_name': name
    };
  }
}
