class Recipe {
  final int id;
  final String name;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final int prepTime;
  final int cookTime;
  final int restTime;
  final int servings;
  final int categoryId;
  final List<int> tagIds;
  final int userId;
  final int imageVersion;


  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.steps,
    required this.prepTime,
    required this.cookTime,
    required this.restTime,
    required this.servings,
    required this.categoryId,
    required this.tagIds,
    required this.userId,
    required this.imageVersion
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      ingredients: (json['ingredients'] as List)
          .map((item) => Ingredient.fromJson(item))
          .toList(),
      steps: List<String>.from(json['steps']),
      prepTime: json['prepTime'],
      cookTime: json['cookTime'],
      restTime: json['restTime'],
      servings: json['servings'],
      categoryId: json['categoryId'],
      tagIds: List<int>.from(json['tagIds']),
      userId: json['userId'],
      imageVersion: json['imageVersion']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'steps': steps,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'restTime': restTime,
      'servings': servings,
      'categoryId': categoryId,
      'tagIds': tagIds,
      'userId': userId,
      'imageVersion': imageVersion
    };
  }
}

class Ingredient {
  final String quantity;
  final String name;

  Ingredient({
    required this.quantity,
    required this.name,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      quantity: json['quantity'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'name': name,
    };
  }
}
