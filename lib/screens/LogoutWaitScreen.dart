import 'package:cooking_recipe_diary/providers/RecipeProvider.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/widgets/icons/SpinningIcon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';
import 'ProfileSelectionScreen.dart';

class LogoutScreen extends StatefulWidget {
  final bool delete;

  const LogoutScreen({super.key, required this.delete});

  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  void initState() {
    super.initState();
    logout();
  }

  Future<void> logout() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);

    if (widget.delete) {
      await userProvider.deleteUser(userProvider.profile!.id);
      await recipeProvider.removeUserFromRecipes(userProvider.profile!.id);
    }
    await userProvider.deleteProfile();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ProfileSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.primaryColor,
      body: Center(
        child: SpinningIcon(icon: Icons.restaurant, color: AppConfig.backgroundColor,),
      ),
    );
  }
}
