import 'package:cooking_recipe_diary/models/RecipeModel.dart';
import 'package:flutter/material.dart';

import '../../utils/theme.dart';

class IngredientContainer extends StatelessWidget {
  final Function(Ingredient)? onTap;
  final Ingredient ingredient;

  const IngredientContainer({super.key, required this.ingredient, this.onTap});

  @override
  Widget build(BuildContext context) {
    double amount = ingredient.quantity;
    String unit = ingredient.unit;
    String name = ingredient.name;
    return InkWell(
      onTap: () {onTap!(ingredient);},
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: AppTheme.categoryButtonDecoration,
        child: Text('$amount$unit $name')
      ),
    );
  }

}