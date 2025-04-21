import 'dart:convert';

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
    required this.imageVersion,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    var ingredientsJson = json['ingredients'];
    List<Ingredient> ingredientsList = [];
    if (ingredientsJson is String && ingredientsJson.isNotEmpty && ingredientsJson != "{}") {
      ingredientsList = List<Ingredient>.from(jsonDecode(ingredientsJson).map((item) => Ingredient.fromJson(item)));
    } else if (ingredientsJson is Map) {
      ingredientsList = [];
    } else if (ingredientsJson is List) {
      ingredientsList = ingredientsJson.map((item) => Ingredient.fromJson(item)).toList();
    }

    var stepsJson = json['steps'];
    List<String> stepsList = [];
    if (stepsJson is String && stepsJson.isNotEmpty && stepsJson != "{}") {
      stepsList = List<String>.from(jsonDecode(stepsJson));
    } else if (stepsJson is Map) {
      stepsList = [];
    } else if (stepsJson is List) {
      stepsList = List<String>.from(stepsJson);
    }

    var timeField = json['time'];
    Map<String, dynamic> timeJson;
    if (timeField is String && timeField.isNotEmpty && timeField != "{}") {
      timeJson = jsonDecode(timeField);
    } else if (timeField is Map) {
      timeJson = timeField.cast<String, dynamic>();
    } else {
      timeJson = {};
    }

    int prepTime = int.tryParse(timeJson['prep']?.toString() ?? '') ?? 0;
    int cookTime = int.tryParse(timeJson['cook']?.toString() ?? '') ?? 0;
    int restTime = int.tryParse(timeJson['rest']?.toString() ?? '') ?? 0;

    return Recipe(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      ingredients: ingredientsList,
      steps: stepsList,
      prepTime: prepTime,
      cookTime: cookTime,
      restTime: restTime,
      servings: int.tryParse(json['number_of_persons'].toString()) ?? 0,
      categoryId: int.tryParse(json['CategoryId'].toString()) ?? 0,
      tagIds: List<int>.from(json['tagIds'] ?? []),
      userId: int.tryParse(json['UserId'].toString()) ?? 0,
      imageVersion: int.tryParse(json['imageVersion'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'steps': steps,
      'time': {
        'prep': prepTime,
        'cook': cookTime,
        'rest': restTime,
      },
      'servings': servings,
      'CategoryId': (categoryId == 0) ? null : categoryId,
      'tagIds': tagIds,
      'UserId': userId,
      'imageVersion': imageVersion,
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
      quantity: json['quantity'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'name': name,
    };
  }
}
