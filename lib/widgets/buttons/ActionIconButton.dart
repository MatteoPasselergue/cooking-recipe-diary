import 'package:cooking_recipe_diary/providers/UserProvider.dart';
import 'package:cooking_recipe_diary/screens/ProfileScreen.dart';
import 'package:cooking_recipe_diary/screens/SearchScreen.dart';
import 'package:cooking_recipe_diary/widgets/dialogs/AddImportRecipeDialog.dart';
import 'package:cooking_recipe_diary/widgets/dialogs/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';
import 'package:provider/provider.dart';

import '../../providers/RecipeProvider.dart';
import '../../screens/RecipeEditorScreen.dart';

class ActionIconButton extends StatelessWidget {
  final IconData icon;
  final double factSize;
  final String? page;
  final Function()? onTap;

  const ActionIconButton({super.key, required this.icon, required this.factSize, this.page, this.onTap});

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * factSize;

    return Padding(padding: const EdgeInsets.all(5.0) ,child :InkWell(
      onTap: () {
        if(onTap != null) onTap!();
        if(page != null) _navigate(context);
      },
      child: Container(
        width: size,
        height: size,
        decoration: AppTheme.iconButtonDecoration,
        child: Center(
          child: Icon(
            icon,
            color: AppConfig.primaryColor,
            size: size * 0.5,
          ),
        ),
      ),
    ));
  }

  void _navigate(BuildContext context) async {
    switch(page){
      case "profile":
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),),);
        break;
      case "search":
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),),);
        break;
      case "add":
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final result = await showDialog(context: context, builder: (_) => AddImportRecipeDialog());

        if(result != null && result["action"] != null){
          switch(result["action"]){
            case "add":
              LoadingDialog.showLoadingDialog(context, "add_recipe");
              try{
                final newRecipe = await Provider.of<RecipeProvider>(context, listen: false).createEmptyRecipe(userProvider.profile!.id);

                LoadingDialog.hideLoadingDialog(context);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RecipeEditorScreen(recipe: newRecipe),
                  ),
                );

              }catch (e){
                LoadingDialog.hideLoadingDialog(context);
                LoadingDialog.showError(context, "$e");
              }
              break;
            case "import":
              LoadingDialog.showLoadingDialog(context, "import");
              try{
                final newRecipe = await Provider.of<RecipeProvider>(context, listen: false).importRecipe(userProvider.profile!.id, result["url"]);

                LoadingDialog.hideLoadingDialog(context);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RecipeEditorScreen(recipe: newRecipe),
                  ),
                );
              }catch (e){
                LoadingDialog.hideLoadingDialog(context);
                LoadingDialog.showError(context, "$e");
              }

          }
        }
        break;
    }
  }
}
