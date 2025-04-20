import 'package:cooking_recipe_diary/providers/CategoryProvider.dart';
import 'package:cooking_recipe_diary/providers/LanguageProvider.dart';
import 'package:cooking_recipe_diary/providers/RecipeProvider.dart';
import 'package:cooking_recipe_diary/providers/TagProvider.dart';
import 'package:cooking_recipe_diary/providers/UserProvider.dart';
import 'package:cooking_recipe_diary/screens/HomeScreen.dart';
import 'package:cooking_recipe_diary/screens/ProfileSelectionScreen.dart';
import 'package:cooking_recipe_diary/services/LocalizationService.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final profileData = prefs.getString('profile');

  await LocalizationService.load('fr_FR');
  await AppConfig.loadConfig();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => TagProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MyApp(profileData: profileData),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? profileData;

  const MyApp({Key? key, this.profileData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      home: profileData == null ? ProfileSelectionScreen() : const HomeScreen(),
      //home: ProfileSelectionScreen(),
    );
  }
}
