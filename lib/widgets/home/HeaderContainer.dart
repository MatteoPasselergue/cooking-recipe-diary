import 'package:cooking_recipe_diary/models/RecipeModel.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/widgets/buttons/PageIconButton.dart';
import 'package:cooking_recipe_diary/widgets/buttons/VerticalRecipeCardButton.dart';
import 'package:cooking_recipe_diary/widgets/cards/SwipeableRecipeCard.dart';
import 'package:flutter/material.dart';

class HeaderContainer extends StatelessWidget {
  const HeaderContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: AppConfig.primaryColor,
      child: Column(
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PageIconButton(Icons.add, "add"),
                  PageIconButton(Icons.search, "search"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PageIconButton(Icons.settings, "settings"),
                  PageIconButton(Icons.person, "user"),
                ],
              ),
            ],
          ),
          Expanded(child: Padding(padding: EdgeInsets.all(15), child: SwipeableRecipeCard())),
        ],
      ),
    );
  }


}