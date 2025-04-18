class Recipe {
  final int id;
  final String title;

  Recipe({
    required this.id,
    required this.title,
  });
  
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: int.parse(json['id'].toString()),
      title: json['title'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
