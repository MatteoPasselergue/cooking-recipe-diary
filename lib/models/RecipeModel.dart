import 'dart:convert';

class Recipe {
  final int id;
  final String name;
  final String note;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final int prepTime;
  final int cookTime;
  final int restTime;
  final int servings;
  final int categoryId;
  final List<String> tags;
  final int userId;
  final int imageVersion;

  Recipe({
    required this.id,
    required this.name,
    required this.note,
    required this.ingredients,
    required this.steps,
    required this.prepTime,
    required this.cookTime,
    required this.restTime,
    required this.servings,
    required this.categoryId,
    required this.tags,
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

    var tagsJson = json['tags'];
    List<String> tagsList = [];
    if (tagsJson is String && tagsJson.isNotEmpty && tagsJson != "{}") {
      tagsList = List<String>.from(jsonDecode(tagsJson));
    } else if (tagsJson is Map) {
      tagsList = [];
    } else if (tagsJson is List) {
      tagsList = List<String>.from(tagsJson);
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
      servings: int.tryParse(json['servings'].toString()) ?? 1,
      categoryId: int.tryParse(json['CategoryId'].toString()) ?? 0,
      tags: tagsList,
      userId: int.tryParse(json['UserId'].toString()) ?? 0,
      imageVersion: int.tryParse(json['imageVersion'].toString()) ?? 0,
      note: json['note'] ?? ''
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
      'tags': tags,
      'UserId': (userId == 0) ? null : userId,
      'imageVersion': imageVersion,
      'note': note,
    };
  }

  Recipe copyWith({
    int? id,
    String? name,
    List<Ingredient>? ingredients,
    List<String>? steps,
    int? prepTime,
    int? cookTime,
    int? restTime,
    int? servings,
    int? categoryId,
    List<String>? tags,
    int? userId,
    int? imageVersion,
    String? note,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      restTime: restTime ?? this.restTime,
      servings: servings ?? this.servings,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      userId: userId ?? this.userId,
      imageVersion: imageVersion ?? this.imageVersion,
      note: note ?? this.note
    );
  }
}

class Ingredient {
  final double quantity;
  final String name;
  final String unit;

  Ingredient({
    required this.quantity,
    required this.name,
    required this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      quantity: double.tryParse(json['quantity'].toString()) ?? 0,
      name: json['name'] ?? '',
      unit: json['unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'name': name,
      'unit': unit
    };
  }
}
