import 'package:flutter/material.dart';
import 'package:cooking_recipe_diary/models/RecipeModel.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';

import '../../screens/RecipeScreen.dart';
import '../../services/ImageService.dart';

class RecipeCardButton extends StatelessWidget {
  final Recipe recipe;

  const RecipeCardButton({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => RecipeScreen(recipe: recipe)),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: AppTheme.recipeCardDecoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: (recipe.imageVersion != 0)
                    ? Image.network(
                  ImageService.buildImageUrl("recipes", recipe.id, version: recipe.imageVersion),
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/images/default.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppConfig.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    recipe.name,
                    style: AppTheme.recipeTitleStyle.copyWith(
                      color: AppConfig.primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
