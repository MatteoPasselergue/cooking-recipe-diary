import 'dart:math';

import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/widgets/bodies/HomeBody.dart';
import 'package:cooking_recipe_diary/widgets/headers/HomeHeader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/UserProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final screenH     = MediaQuery.of(context).size.height;
    final screenW     = MediaQuery.of(context).size.width;
    final shortest    = MediaQuery.of(context).size.shortestSide;
    final orient      = MediaQuery.of(context).orientation;

    double headerHeight;
    if (shortest < 600) {
      headerHeight = (orient == Orientation.portrait)
          ? screenH * 0.8
          : screenW * 0.8;
    } else {
      headerHeight = (orient == Orientation.portrait)
          ? screenW * 1.3
          : screenH * 1.3;
    }

    return Scaffold(
      backgroundColor: AppConfig.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: headerHeight,
                child: HomeHeader(),
              ),
              HomeBody(),
            ],
          ),
        ),
      ),
    );
  }
}
