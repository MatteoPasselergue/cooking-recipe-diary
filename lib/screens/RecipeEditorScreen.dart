import 'dart:io';

import 'package:cooking_recipe_diary/providers/RecipeProvider.dart';
import 'package:cooking_recipe_diary/services/ImageService.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/widgets/bodies/EditorBody.dart';
import 'package:cooking_recipe_diary/widgets/headers/EditorHeader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import '../models/RecipeModel.dart';
import '../services/LocalizationService.dart';
import '../widgets/dialogs/ConfirmationDialog.dart';
import '../widgets/dialogs/LoadingDialog.dart';
import 'HomeScreen.dart';
import 'RecipeScreen.dart';

class RecipeEditorScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeEditorScreen({super.key, required this.recipe});

  @override
  _RecipeEditorScreenState createState() => _RecipeEditorScreenState();
}

class _RecipeEditorScreenState extends State<RecipeEditorScreen> {
  final GlobalKey<EditorBodyState> bodyKey = GlobalKey<EditorBodyState>();
  bool _hasChanged = false;

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return WillPopScope(
      onWillPop: _onWillPop,
        child:Scaffold(
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
                      EditorHeader(onSendData: updateRecipe, recipe: recipe, onDelete: deleteRecipe, onChanged: () {
                    if (!_hasChanged) {
                      setState(() {
                        _hasChanged = true;
                      });}}
                      ),
                      //BODY
                      EditorBody(key: bodyKey, recipe: recipe, onChanged: () {
                        if (!_hasChanged) {
                          setState(() {
                            _hasChanged = true;
                          });}})
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ));
  }

  Future<bool> _onWillPop() async{
    if (!_hasChanged) {
      return true;
    }

    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: LocalizationService.translate("confirm_no_save_modification_title"),
          message: LocalizationService.translate("confirm_no_save_modification_message"),

        );
      },
    );

    return shouldLeave ?? false;

  }


  void updateRecipe(Map<String, dynamic> headerData) async {
    final oldRecipe = widget.recipe;
    final bodyData = bodyKey.currentState!.getData();

    String name = headerData["name"] ?? oldRecipe.name;
    int prepTime = headerData["prep"] ?? oldRecipe.prepTime;
    int cookTime = headerData["cook"] ?? oldRecipe.cookTime;
    int restTime = headerData["rest"] ?? oldRecipe.restTime;
    int servings = headerData["servings"] ?? oldRecipe.servings;
    int categoryId = headerData["category"] ?? oldRecipe.categoryId;
    String note = bodyData["note"] ?? oldRecipe.note;

    List<Ingredient> ingredients = bodyData["ingredients"] ?? oldRecipe.ingredients;
    List<String> steps = bodyData["steps"] ?? oldRecipe.steps;
    List<String> tags = headerData["tags"] ?? oldRecipe.tags;
    int imageVersion = oldRecipe.imageVersion;
    File? imageFile;

    if(ImageService.buildImageUrl("recipes", oldRecipe.id, version: oldRecipe.imageVersion) != headerData["imagePath"]){
      if(headerData["imagePath"] != null){
        await DefaultCacheManager().removeFile(ImageService.buildImageUrl("recipes", oldRecipe.id, version: oldRecipe.imageVersion));
        imageVersion++;
        imageFile = File(headerData["imagePath"]);
      }else{
        imageVersion = 0;
        await DefaultCacheManager().removeFile(ImageService.buildImageUrl("recipes", oldRecipe.id, version: oldRecipe.imageVersion));
      }
    }

    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    final Recipe newRecipe = Recipe(id: oldRecipe.id, name: name, ingredients: ingredients, steps: steps, prepTime: prepTime, cookTime: cookTime, restTime: restTime, servings: servings, categoryId: categoryId, tags: tags, userId: oldRecipe.userId, imageVersion: imageVersion, note: note);

    LoadingDialog.showLoadingDialog(context, "edit_recipe");
    try {

      await recipeProvider.updateRecipe(newRecipe, imageFile: imageFile);

      LoadingDialog.hideLoadingDialog(context);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
      );

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RecipeScreen(recipe: newRecipe)),
      );
    } catch(e){
      LoadingDialog.hideLoadingDialog(context);
      LoadingDialog.showError(context, "$e");
    }
  }

  void deleteRecipe() async {
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);

    LoadingDialog.showLoadingDialog(context, "remove_recipe");

    try {
      await recipeProvider.deleteRecipe(widget.recipe.id);

      LoadingDialog.hideLoadingDialog(context);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
      );

    }finally{
      /*TODO: LoadingDialog.showSuccessMessage(context, "$e");*/
    }

  }
}
