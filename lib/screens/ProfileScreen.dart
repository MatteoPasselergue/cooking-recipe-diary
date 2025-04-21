import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:flutter/material.dart';

import '../widgets/profile/ProfileBodyContainer.dart';
import '../widgets/profile/ProfileHeaderContainer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppConfig.primaryColor,
      body: Column(
        children: [
          ProfileHeaderContainer(),
          ProfileBodyContainer(),
        ],
      ),
    );
  }
}
