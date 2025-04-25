import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/widgets/buttons/ActionIconButton.dart';
import 'package:cooking_recipe_diary/widgets/cards/SwipeableRecipeCard.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

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
                  ActionIconButton(factSize: 0.15, icon: Icons.add, page: "add", onTap: null),
                  ActionIconButton(factSize: 0.15, icon: Icons.search, page: "search", onTap: null),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ActionIconButton(factSize: 0.15, icon: Icons.person, page: "profile", onTap: null),
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