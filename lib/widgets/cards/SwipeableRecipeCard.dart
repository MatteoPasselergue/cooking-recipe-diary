import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cooking_recipe_diary/services/ImageService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cooking_recipe_diary/models/RecipeModel.dart';
import 'package:cooking_recipe_diary/providers/RecipeProvider.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';

import '../../providers/LanguageProvider.dart';
import '../../services/LocalizationService.dart';

class SwipeableRecipeCard extends StatefulWidget {
  const SwipeableRecipeCard({Key? key}) : super(key: key);

  @override
  State<SwipeableRecipeCard> createState() => _SwipeableRecipeCardState();
}

class _SwipeableRecipeCardState extends State<SwipeableRecipeCard> with SingleTickerProviderStateMixin {
  final Random random = Random();
  Recipe? currentRecipe;
  bool _isLoading = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(_controller);

    Future.microtask(() async {
      try {
        await Provider
            .of<RecipeProvider>(context, listen: false)
            .fetchRecipes();
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeRecipe(List<Recipe> recipes) async {
    if (recipes.isEmpty) return;

    await _controller.forward();

    setState(() {
      Recipe newRecipe;
      do {
        newRecipe = recipes[random.nextInt(recipes.length)];
      } while (newRecipe == currentRecipe && recipes.length > 1);
      currentRecipe = newRecipe;
    });

    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final fakeRecipes = [
      Recipe(id: 1,
          name: "name",
          ingredients: [],
          steps: [],
          prepTime: 0,
          cookTime: 0,
          restTime: 0,
          servings: 0,
          categoryId: 1,
          tagIds: [],
          userId: 1,
          imageVersion: 0),
      Recipe(id: 2,
          name: "name2",
          ingredients: [],
          steps: [],
          prepTime: 0,
          cookTime: 0,
          restTime: 0,
          servings: 0,
          categoryId: 1,
          tagIds: [],
          userId: 1,
          imageVersion: 0),
      Recipe(id: 3,
          name: "name3",
          ingredients: [],
          steps: [],
          prepTime: 0,
          cookTime: 0,
          restTime: 0,
          servings: 0,
          categoryId: 1,
          tagIds: [],
          userId: 1,
          imageVersion: 0)
    ];
    final recipes = recipeProvider.recipes;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (recipes.isEmpty) {
      return Center(
          child: Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return Text(LocalizationService.translate("no_recipes_found"));
            },
          ),);
    }

    if (currentRecipe == null) {
      currentRecipe = recipes[random.nextInt(recipes.length)];
    }

    return GestureDetector(
      onTap: () {},
      onHorizontalDragEnd: (_) {
        changeRecipe(recipes);
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: AppTheme.recipeCardDecoration,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Positioned.fill(
                  child: (currentRecipe!.imageVersion != 0)
                      ? CachedNetworkImage(
                    imageUrl: ImageService.buildImageUrl(
                        "recipes", currentRecipe!.id,
                        version: currentRecipe!.imageVersion),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppConfig.backgroundColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentRecipe!.name,
                      style: AppTheme.recipeTitleStyle.copyWith(
                        color: AppConfig.primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppConfig.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.ac_unit,
                      size: 20,
                      color: AppConfig.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
