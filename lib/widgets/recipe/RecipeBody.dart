import 'package:cached_network_image/cached_network_image.dart';
import 'package:cooking_recipe_diary/services/ImageService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/RecipeModel.dart';
import '../../providers/UserProvider.dart';
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = recipe.userId != 0 ? userProvider.getUserById(recipe.userId) : null;

    final ImageProvider image = (user !=null) ? CachedNetworkImageProvider(ImageService.buildImageUrl("users", recipe.userId, version: user.imageVersion),) : AssetImage("assets/images/default.png");
    
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
                          if(recipe.note.isNotEmpty)  Padding(padding: EdgeInsets.all(10), child: Align(alignment: Alignment.centerLeft, child: Text(recipe.note)),),
                          Padding(padding: EdgeInsets.only(left: 10), child: Align(alignment: Alignment.centerLeft, child: Text(LocalizationService.translate("ingredients"), style: AppTheme.recipeTitleStyle.copyWith(fontSize: 30),))),
                          Padding(padding: EdgeInsets.all(5)),
                          Wrap(spacing: 8, runSpacing:  8,
                            children: ingredientsButton,),
                          Padding(padding: EdgeInsets.all(10)),
                          Padding(padding: EdgeInsets.only(left: 10), child: Align(alignment: Alignment.centerLeft, child: Text(LocalizationService.translate("steps"), style: AppTheme.recipeTitleStyle.copyWith(fontSize: 30),))),
                          ...stepsButton,

                          Padding(padding: EdgeInsets.only(top: 20, bottom: 0), child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            Text(LocalizationService.translate("created_by"), style: TextStyle(fontStyle: FontStyle.italic),),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                            CircleAvatar(
                              backgroundColor: AppConfig.backgroundColor,
                              radius:  18, backgroundImage: (user != null && user.imageVersion != 0) ? image : null,
                            child: ( user==null || user.imageVersion == 0) ? Icon(Icons.account_circle, color: AppConfig.primaryColor) : null,
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                            (user != null) ? Text(user.name) : Text(LocalizationService.translate("unknown_user")),
                          ],),),
                        ]),
                    ),
                  ))
            ]
        )
    );
  }

}