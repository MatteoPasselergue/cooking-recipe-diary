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
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.8;

    return Scaffold(
      backgroundColor: AppConfig.primaryColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: headerHeight,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: HomeHeader(),
              title: const Text(''),
            ),
            automaticallyImplyLeading: false,
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 10,
              color: Colors.transparent,
            ),
          ),
          SliverToBoxAdapter(
            child: HomeBody(),
          ),
        ],
      ),
    );
  }
}
