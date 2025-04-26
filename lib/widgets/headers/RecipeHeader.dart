import 'package:cached_network_image/cached_network_image.dart';
import 'package:cooking_recipe_diary/widgets/snackbar/AppSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/CategoryModel.dart';
import '../../models/RecipeModel.dart';
import '../../providers/CategoryProvider.dart';
import '../../services/ImageService.dart';
import '../../services/LocalizationService.dart';
import '../../utils/AppConfig.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../buttons/ActionIconButton.dart';
import '../buttons/TagButton.dart';
import '../containers/BaseContainer.dart';
import '../containers/ServingsCounterContainer.dart';

class RecipeHeader extends StatelessWidget {
  final Recipe recipe;
  final Function(int) onServingsChanged;
  final Function() editRecipe;
  final int servings;

  const RecipeHeader({super.key, required this.recipe, required this.onServingsChanged, required this.editRecipe, required this.servings});
  
  
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories;
    Category? currentCategory = categories.any((cat) => cat.id == recipe.categoryId) ? categories.firstWhere((cat) => cat.id == recipe.categoryId) : null;
    IconData? icon = (currentCategory != null) ? Utils.iconDataMap[currentCategory.iconName] : Icons.question_mark;
    String category = (currentCategory !=null) ? currentCategory.name : LocalizationService.translate("no_category");

    final double height = MediaQuery.of(context).size.height * 0.6;
    return Container(
      color: AppConfig.primaryColor,
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16), child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(recipe.name, style: AppTheme.recipeTitleStyle.copyWith(fontSize: 26), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              const Padding(padding: EdgeInsets.all(8),),
              Row(
                children: [
                  const ActionIconButton(factSize: 0.13, icon: Icons.arrow_back, page: "back"),
                  ActionIconButton(factSize: 0.13, icon: Icons.edit, page: null, onTap: editRecipe),
                ],
              ),
            ],
          )),
          SingleChildScrollView(scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...recipe.tags.map((tag) => TagButton(tag: tag, onTap: null)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(30),
            child: Container(
              height: height,
              decoration: AppTheme.recipeCardDecoration,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: (recipe.imageVersion != 0)
                          ? CachedNetworkImage(imageUrl: ImageService.buildImageUrl("recipes", recipe.id, version: recipe.imageVersion), fit: BoxFit.cover,) : Image.asset('assets/images/default.png', fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppConfig.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              size: 20,
                              color: AppConfig.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              category,
                              style: TextStyle(
                                color: AppConfig.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(padding: EdgeInsets.all(6),
                    child: GestureDetector(
                        child: BaseContainer(child: ServingsCounterContainer(defaultCounter: servings, onChanged: onServingsChanged),),
                      onTap: () {ScaffoldMessenger.of(context).showSnackBar(AppSnackBar.popMessage("servings"));},
                    )),
                Padding(padding: EdgeInsets.all(6), child: BaseContainer(child: _buildDurationView(context, "total_time", Icons.access_time, Duration(seconds: (recipe.prepTime + recipe.restTime + recipe.cookTime))))),
                Padding(padding: EdgeInsets.all(6), child: BaseContainer(child: _buildDurationView(context, "prep_time",Icons.hourglass_full, Duration(seconds: recipe.prepTime)))),
                Padding(padding: EdgeInsets.all(6), child: BaseContainer(child: _buildDurationView(context, "rest_time", Icons.nightlight_round, Duration(seconds: recipe.restTime)))),
                Padding(padding: EdgeInsets.all(6), child: BaseContainer(child: _buildDurationView(context, "cook_time", Icons.microwave, Duration(seconds: recipe.cookTime)))),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(10))

        ],
      ),
    );
  }

  Widget _buildDurationView(BuildContext context, String type,IconData icon, Duration duration) {
    return GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(AppSnackBar.popMessage(type));
        },
        child: Row(mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppConfig.primaryColor,),
            const SizedBox(width: 4),
            Text("${duration.inHours}h ${duration.inMinutes.remainder(60)}m",
                style: TextStyle(fontSize: 14, color: AppConfig.primaryColor)),
          ],
        ));
  }
  
}