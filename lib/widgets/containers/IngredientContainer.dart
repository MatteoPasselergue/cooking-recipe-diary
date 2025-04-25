import 'package:cooking_recipe_diary/models/RecipeModel.dart';
import 'package:flutter/material.dart';

import '../../utils/theme.dart';

class IngredientContainer extends StatelessWidget {
  final Function(Ingredient)? onTap;
  final Ingredient ingredient;
  final int? defaultServings;
  final int? currentServings;

  const IngredientContainer({super.key, required this.ingredient, this.onTap, this.defaultServings, this.currentServings});

  @override
  Widget build(BuildContext context) {
    double amount = ingredient.quantity;

    if(defaultServings != null && currentServings != null && defaultServings != 0) amount = ingredient.quantity * (currentServings! / defaultServings!);

    String displayAmount = '';
    if (amount != 0) {
      String s = amount.toStringAsFixed(2);
      s = s.replaceAll(RegExp(r'0+$'), '');
      s = s.replaceAll(RegExp(r'\.$'), '');
      displayAmount = s;
    }

    String unit = ingredient.unit;
    String name = ingredient.name;
    return InkWell(
      onTap: () {if(onTap != null) onTap!(ingredient);},
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: AppTheme.categoryButtonDecoration,
        child: Text('$displayAmount$unit $name')
      ),
    );
  }

}