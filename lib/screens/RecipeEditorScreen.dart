import 'dart:io';

import 'package:cooking_recipe_diary/providers/RecipeProvider.dart';
import 'package:cooking_recipe_diary/services/ImageService.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/widgets/editor/EditorBody.dart';
import 'package:cooking_recipe_diary/widgets/editor/EditorHeader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/RecipeModel.dart';
import 'HomeScreen.dart';

class RecipeEditorScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeEditorScreen({super.key, required this.recipe});

  @override
  _RecipeEditorScreenState createState() => _RecipeEditorScreenState();
}

class _RecipeEditorScreenState extends State<RecipeEditorScreen> {
  final GlobalKey<EditorBodyState> bodyKey = GlobalKey<EditorBodyState>();

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      backgroundColor: AppConfig.primaryColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // HEADER
                      EditorHeader(onSendData: updateRecipe, recipe: recipe),
                      //BODY
                      EditorBody(key: bodyKey, recipe: recipe)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void updateRecipe(Map<String, dynamic> headerData) async {
    final oldRecipe = widget.recipe;
    final bodyData = bodyKey.currentState!.getData();

    print(headerData);
    String name = headerData["name"] ?? oldRecipe.name;
    int prepTime = headerData["prep"] ?? oldRecipe.prepTime;
    int cookTime = headerData["cook"] ?? oldRecipe.cookTime;
    int restTime = headerData["rest"] ?? oldRecipe.restTime;
    int servings = headerData["servings"] ?? oldRecipe.servings;
    int categoryId = headerData["category"] ?? oldRecipe.categoryId;

    List<Ingredient> ingredients = bodyData["ingredients"] ?? oldRecipe.ingredients;
    List<String> steps = bodyData["steps"] ?? oldRecipe.steps;
    List<String> tags = headerData["tags"] ?? oldRecipe.tags;
    int imageVersion = oldRecipe.imageVersion;
    File? imageFile;

    if(ImageService.buildImageUrl("recipes", oldRecipe.id, version: oldRecipe.imageVersion) != headerData["imagePath"]){
      imageVersion++;
      imageFile = File(headerData["imagePath"]);
    }

    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    await recipeProvider.updateRecipe(Recipe(id: oldRecipe.id, name: name, ingredients: ingredients, steps: steps, prepTime: prepTime, cookTime: cookTime, restTime: restTime, servings: servings, categoryId: categoryId, tags: tags, userId: oldRecipe.userId, imageVersion: imageVersion), imageFile: imageFile);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
    );

    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RecipeScreen(recipeId: oldRecipe.id)),
    );*/

  }
}
