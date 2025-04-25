import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/widgets/icons/SpinningIcon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/UserModel.dart';
import '../providers/UserProvider.dart';
import '../services/ImageService.dart';
import '../services/LocalizationService.dart';
import '../widgets/dialogs/AddProfilDialog.dart';
import '../widgets/dialogs/LoadingDialog.dart';
import 'HomeScreen.dart';

class ProfileSelectionScreen extends StatefulWidget {
  @override
  _ProfileSelectionScreenState createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {

  FixedExtentScrollController _controller = FixedExtentScrollController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.fetchUsers();
        await userProvider.loadProfile();

        if (userProvider.profile != null) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HomeScreen()));
        }

      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (_isLoading) {
      return SpinningIcon(icon: Icons.restaurant, color: AppConfig.primaryColor,);
    }

    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(30)),
          Text(
            LocalizationService.translate("choose_profile"),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Center(
              child: ListWheelScrollView.useDelegate(
                controller: _controller,
                itemExtent: 200, // hauteur de chaque item
                physics: FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                perspective: 0.000001,
                diameterRatio: 150,
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    if (index < 0 || index >= userProvider.users.length+1) return null;

                    bool isSelected = index == _selectedIndex;
                    double size = isSelected ? 120 : 100;
                    double fontSize = isSelected ? 25 : 21;

                    if (index == 0) {
                      return GestureDetector(
                        onTap: isSelected ?() => _onAddProfile(userProvider) : null,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: size / 2,
                              backgroundColor: AppConfig.primaryColor,
                              child: Icon(Icons.add, size: size / 2, color: AppConfig.backgroundColor,),
                            ),
                            Padding(padding: EdgeInsets.all(4)),
                            Text(
                              LocalizationService.translate("add_profile"),
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    final user = userProvider.users[index-1];
                    return GestureDetector(
                      onTap: isSelected ? () => _onProfileSelected(userProvider, user) : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: size / 2,
                            backgroundColor: AppConfig.primaryColor,
                            backgroundImage: (user.imageVersion != 0)
                                ? CachedNetworkImageProvider(ImageService.buildImageUrl("users", user.id, version: user.imageVersion))
                                : null,
                            child: (user.imageVersion == 0)
                                ? Icon(Icons.account_circle, size: size, color: AppConfig.backgroundColor)
                                : null,
                          ),
                          const Padding(padding: EdgeInsets.all(4)),
                          Text(
                            user.name,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );

                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAddProfile(UserProvider userProvider) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddProfileDialog(),
    );

    if(result !=null) {

      LoadingDialog.showLoadingDialog(context, "add_user");

      try{
        await userProvider.addUser(
            User(
                id: 0,
                name: result["name"],
                imageVersion: (result["imagePath"] != null) ? 1 : 0),
            imageFile: (result["imagePath"] != null)
                ? File(result["imagePath"])
                : null);

        LoadingDialog.hideLoadingDialog(context);

        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));

      }catch(e){
        LoadingDialog.hideLoadingDialog(context);
        LoadingDialog.showError(context, "$e");
      }
    }
  }

  void _onProfileSelected(UserProvider userProvider, User user) async {
    LoadingDialog.showLoadingDialog(context, "save_profile");

    try {
      await userProvider.saveProfile(user);

      LoadingDialog.hideLoadingDialog(context);

      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));

    }catch (e){
      LoadingDialog.hideLoadingDialog(context);
      LoadingDialog.showError(context, "$e");
    }
  }
}

