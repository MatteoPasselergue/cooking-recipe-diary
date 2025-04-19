import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:flutter/material.dart';

import '../../models/RecipeModel.dart';
import '../buttons/VerticalRecipeCardButton.dart';
import '../category/CategoryButtons.dart';
import 'WavePainter.dart';

class BodyContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CustomPaint(
        size: Size(MediaQuery
            .of(context)
            .size
            .width, 10),
        painter: WavePainter(waveColor: AppConfig.backgroundColor),
      ),
      Container(
        color: AppConfig.backgroundColor,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            CategoryButtons()
          ],
        ),
      )

    ],
    );
  }

}