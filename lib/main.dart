import 'package:cooking_recipe_diary/providers/CategoryProvider.dart';
import 'package:cooking_recipe_diary/providers/LanguageProvider.dart';
import 'package:cooking_recipe_diary/providers/RecipeProvider.dart';
import 'package:cooking_recipe_diary/providers/TagProvider.dart';
import 'package:cooking_recipe_diary/screens/HomeScreen.dart';
import 'package:cooking_recipe_diary/services/LocalizationService.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizationService.load('fr_FR');
  await AppConfig.loadConfig();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => TagProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
