import 'package:cooking_recipe_diary/providers/CategoryProvider.dart';
import 'package:cooking_recipe_diary/screens/RecipeScreen.dart';
import 'package:cooking_recipe_diary/widgets/dialogs/CategorySelectionDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/CategoryModel.dart';
import '../models/RecipeModel.dart';
import '../providers/RecipeProvider.dart';
import '../services/LocalizationService.dart';
import '../utils/AppConfig.dart';
import '../utils/utils.dart';
import '../widgets/buttons/TagButton.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = '';
  List<String> selectedTags = [];
  Category? selectedCategory;

  List<Recipe> allRecipes = [];
  List<Recipe> filteredRecipes = [];

  List<String> tags = [];
  List<Category> categories = [];

  final Category noCategory = Category(id: 0, name: LocalizationService.translate("no_category"), iconName: "question_mark");


  @override
  void initState() {
    super.initState();
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    allRecipes = recipeProvider.recipes;
    categories = [noCategory, ...categoryProvider.categories];


    Set<String> uniqueTags = {for (var recipe in allRecipes) ...recipe.tags};
    tags = uniqueTags.toList()..sort();

    filteredRecipes = List.from(allRecipes);
  }

  void _filterRecipes() {
    setState(() {
      filteredRecipes = allRecipes.where((recipe) {
        final matchesSearch = searchQuery.isEmpty ||
            recipe.name.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesTags = selectedTags.isEmpty ||
            recipe.tags.any((tag) => selectedTags.contains(tag));
        final matchesCategory = selectedCategory == null ||
            recipe.categoryId == selectedCategory!.id;
        return matchesSearch && matchesTags && matchesCategory;
      }).toList();
    });
  }

  void _toggleTag(String tag) {
    setState(() {
      selectedTags.contains(tag)
          ? selectedTags.remove(tag)
          : selectedTags.add(tag);
      _filterRecipes();
    });
  }

  void _onSelected(Category? category) {
    setState(() {
      selectedCategory = category;
      final recipesForCategory = selectedCategory == null
          ? allRecipes
          : allRecipes.where((r) => r.categoryId == selectedCategory!.id).toList();
      tags = { for (var r in recipesForCategory) ...r.tags }.toList()..sort();
      selectedTags.removeWhere((t) => !tags.contains(t));
      _filterRecipes();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          decoration: InputDecoration(
            hintText: LocalizationService.translate("search_recipes"),
            prefixIcon: const Icon(Icons.search),
          ),
          onChanged: (value) {
            searchQuery = value;
            _filterRecipes();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              showDialog(
              context: context,
              builder: (context) => CategorySelectionDialog(categories: categories, onSelected: _onSelected, selectedCategory: selectedCategory),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.transparent,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: tags.map((tag) {
                  final isSelected = selectedTags.contains(tag);
                  return TagButton(
                    tag: tag,
                    isSelected: isSelected,
                    onTap: _toggleTag,
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (ctx, i) {
                final recipe = filteredRecipes[i];
                final category = categories.firstWhere(
                        (cat) => cat.id == recipe.categoryId,);
                return ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeScreen(recipe: recipe),),);
                  },
                  leading: Icon(Utils.iconDataMap[category.iconName]),
                  title: Text(recipe.name),
                  subtitle: Text(category.name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}