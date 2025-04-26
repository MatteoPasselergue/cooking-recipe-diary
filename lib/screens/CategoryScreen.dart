import 'package:cooking_recipe_diary/models/CategoryModel.dart';
import 'package:cooking_recipe_diary/providers/RecipeProvider.dart';
import 'package:cooking_recipe_diary/services/LocalizationService.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';
import 'package:cooking_recipe_diary/utils/utils.dart';
import 'package:cooking_recipe_diary/widgets/buttons/TagButton.dart';
import 'package:cooking_recipe_diary/widgets/buttons/RecipeCardButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/RecipeModel.dart';
import '../utils/AppConfig.dart';
import '../widgets/buttons/ActionIconButton.dart';

class CategoryScreen extends StatefulWidget {
  final Category? category;
  final String type;
  
  const CategoryScreen({super.key, this.category, required this.type});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Category? category;
  late List<Recipe> recipes;
  late List<Recipe> displayedRecipes;
  late List<String> tags;
  List<String> selectedTags = [];
  
  
  @override
  void initState() {
    super.initState();
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    
    switch(widget.type){
      case "no_category":
        category = Category(iconName: 'question_mark', id: 0, name: LocalizationService.translate("no_category"));
        recipes = List.from(recipeProvider.recipes.where((recipe) => recipe.categoryId == category!.id).toList());
        break;
      case "category":
        category = widget.category;
        recipes = List.from(recipeProvider.recipes.where((recipe) => recipe.categoryId == category!.id).toList());
        break;
      case "all_recipes":
      default:
        category = null;
        recipes = List.from(recipeProvider.recipes);
        break;
    }
    displayedRecipes = List.from(recipes);

    Set<String> uniqueTags = {for (var recipe in recipes) ...recipe.tags};
    tags = uniqueTags.toList()..sort();
  }

  void _toggleTag(String tag){
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }

      if (selectedTags.isEmpty) {
        displayedRecipes = List.from(recipes);
      } else {
        displayedRecipes = recipes.where((recipe) =>
            selectedTags.any((tag) => recipe.tags.contains(tag))).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ActionIconButton(icon: Icons.arrow_back, page: "back", factSize: 0.12,),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Utils.iconDataMap[category?.iconName] ?? Icons.book,
                              size: 30,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                category?.name ?? LocalizationService.translate("all_categories"),
                                style: AppTheme.recipeTitleStyle.copyWith(
                                  fontSize: 30,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              SliverPersistentHeader(
                pinned: true,
                delegate: _TagsHeader(
                  tags: tags,
                  selectedTags: selectedTags,
                  onTagToggle: _toggleTag,
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 16)),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                      child: RecipeCardButton(recipe: displayedRecipes[index]),
                    );
                  },
                  childCount: displayedRecipes.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _TagsHeader extends SliverPersistentHeaderDelegate {
  final List<String> tags;
  final List<String> selectedTags;
  final Function(String) onTagToggle;

  _TagsHeader({
    required this.tags,
    required this.selectedTags,
    required this.onTagToggle,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: tags.map((tag) {
            final isSelected = selectedTags.contains(tag);
            return TagButton(
              tag: tag,
              onTap: onTagToggle,
              isSelected: isSelected,
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
