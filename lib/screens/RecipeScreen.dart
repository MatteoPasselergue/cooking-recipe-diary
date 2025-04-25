import 'package:cooking_recipe_diary/screens/RecipeEditorScreen.dart';
import 'package:flutter/material.dart';

import '../models/RecipeModel.dart';
import '../utils/AppConfig.dart';
import '../widgets/bodies/RecipeBody.dart';
import '../widgets/headers/RecipeHeader.dart';
import 'HomeScreen.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeScreen({super.key, required this.recipe});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {

  late int currentServings;

  @override
  void initState() {
    super.initState();
    currentServings = widget.recipe.servings;
  }

  void _onServingsChanged(int newServings) {
    setState(() {
      currentServings = newServings;
    });
  }

  void _editRecipe(){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RecipeEditorScreen(recipe: widget.recipe)),
    );
  }


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
                      RecipeHeader(recipe: recipe, onServingsChanged: _onServingsChanged, servings: currentServings, editRecipe: _editRecipe,),
                      //BODY
                      RecipeBody(recipe: recipe, currentServings: currentServings),
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

}