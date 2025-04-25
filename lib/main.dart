import 'package:cooking_recipe_diary/providers/CategoryProvider.dart';
import 'package:cooking_recipe_diary/providers/LanguageProvider.dart';
import 'package:cooking_recipe_diary/providers/RecipeProvider.dart';
import 'package:cooking_recipe_diary/providers/UserProvider.dart';
import 'package:cooking_recipe_diary/screens/HomeScreen.dart';
import 'package:cooking_recipe_diary/screens/ProfileSelectionScreen.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';
import 'package:cooking_recipe_diary/widgets/icons/SpinningIcon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.loadConfig();

  final prefs = await SharedPreferences.getInstance();
  final profileData = prefs.getString('profile');

  await AppConfig.loadConfig();
  runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RecipeProvider()),
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: MyApp(profileData: profileData),
      ),
  );
}

class MyApp extends StatelessWidget {
  final String? profileData;

  const MyApp({super.key, this.profileData});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return MaterialApp(
          key: ValueKey(languageProvider.locale),
          title: AppConfig.appName,
          theme: AppTheme.themeData,
          debugShowCheckedModeBanner: false,
          home: SplashScreen(profileData: profileData)//profileData == null ? ProfileSelectionScreen() : const HomeScreen(),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  final String? profileData;
  const SplashScreen({super.key, this.profileData});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => widget.profileData == null ? ProfileSelectionScreen() : const HomeScreen(),),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SpinningIcon(
                icon: Icons.restaurant,
                color: AppConfig.primaryColor,
              ),
              SizedBox(height: 16),
              Text(
                AppConfig.appName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConfig.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
