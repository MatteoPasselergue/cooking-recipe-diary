import 'package:flutter/material.dart';

import '../../models/RecipeModel.dart';
import '../../services/LocalizationService.dart';
import '../../utils/AppConfig.dart';
import '../../utils/theme.dart';
import '../containers/IngredientContainer.dart';
import '../containers/StepContainer.dart';
import '../home/WavePainter.dart';

class RecipeBody extends StatelessWidget {
  final Recipe recipe;
  final int currentServings;

  const RecipeBody({super.key, required this.recipe, required this.currentServings});

  @override
  Widget build(BuildContext context) {
    List<Widget> ingredientsButton = [
      ...recipe.ingredients.map((ingredient) => IngredientContainer(ingredient: ingredient, onTap: null, defaultServings: recipe.servings, currentServings: currentServings)),
    ];
    List<Widget> stepsButton = [
      ...recipe.steps.asMap().entries.map((entry) => StepContainer(step: entry.value, position: entry.key + 1, onTap: null,)),
    ];

    return Expanded(
        child: Column(
            children: [
              CustomPaint(
                size: Size(MediaQuery
                    .of(context)
                    .size
                    .width, 10),
                painter: WavePainter(waveColor: AppConfig.backgroundColor),
              ),
              Expanded(
                  child: Container(
                    width: double.infinity,
                    color: AppConfig.backgroundColor,
                    child: Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 6), child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 10), child: Align(alignment: Alignment.centerLeft, child: Text(LocalizationService.translate("ingredients"), style: AppTheme.recipeTitleStyle.copyWith(fontSize: 30),))),
                          Padding(padding: EdgeInsets.all(5)),
                          Wrap(spacing: 8, runSpacing:  8,
                            children: ingredientsButton,),
                          Padding(padding: EdgeInsets.all(10)),
                          Padding(padding: EdgeInsets.only(left: 10), child: Align(alignment: Alignment.centerLeft, child: Text(LocalizationService.translate("steps"), style: AppTheme.recipeTitleStyle.copyWith(fontSize: 30),))),
                          ...stepsButton,
                        ]),
                    ),
                  ))
            ]
        )
    );
  }

}