import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cooking_recipe_diary/widgets/dialogs/EditProfilDialog.dart';
import 'package:cooking_recipe_diary/widgets/icons/SpinningIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

import '../../models/UserModel.dart';
import '../../providers/UserProvider.dart';
import '../../screens/ProfileSelectionScreen.dart';
import '../../services/ImageService.dart';
import '../../utils/AppConfig.dart';
import '../buttons/ActionIconButton.dart';
import '../dialogs/LoadingDialog.dart';


class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {


  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.fetchUsers();
        await userProvider.loadProfile();

        if (userProvider.profile == null) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  ProfileSelectionScreen()));
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
    if (_isLoading) {
      return Center(child: SpinningIcon(icon: Icons.restaurant, color: AppConfig.backgroundColor,));
    }

    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.profile!;

    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 30),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: ActionIconButton(icon: Icons.arrow_back, factSize: 0.13, page: "back",),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            CircleAvatar(
              radius: 100,
              backgroundColor: AppConfig.backgroundColor,
              backgroundImage: (user.imageVersion != 0)
                  ? CachedNetworkImageProvider(
                  ImageService.buildImageUrl("users", user.id, version: user.imageVersion))
                  : null,
              child: (user.imageVersion == 0)
                  ? Icon(Icons.account_circle, size: 150, color: AppConfig.primaryColor)
                  : null,
            ),
            Padding(padding: EdgeInsets.all(10)),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppConfig.textColor,
                      ),
                    ),
                  IconButton(
                    icon: Icon(Icons.edit, color: AppConfig.backgroundColor),
                    onPressed: () {
                      _onEditProfile(userProvider, user);
                    },
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
          ],
        ),
      ),
    );
  }

  void _onEditProfile(UserProvider userProvider, User user) async {
    String? currentImagePath;

    if (user.imageVersion != 0) {
      final cacheManager = DefaultCacheManager();
      final fileInfo = await cacheManager.getFileFromCache(
        ImageService.buildImageUrl("users", user.id, version: user.imageVersion),
      );

      if (fileInfo != null) {
        currentImagePath = fileInfo.file.path;
      }
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditProfilDialog(
        currentName: user.name,
        currentImagePath: currentImagePath,
      ),
    );

    if(result !=null) {
      var imageVersion = 0;
      if(result["imagePath"] == currentImagePath) {
        imageVersion = user.imageVersion;
      }else{
        final oldUrl = ImageService.buildImageUrl("users", user.id, version: user.imageVersion);
        await DefaultCacheManager().removeFile(oldUrl);
        if(result["imagePath"] != null ) imageVersion = user.imageVersion + 1;
      }

      LoadingDialog.showLoadingDialog(context, "edit_user");
      try {
        await userProvider.updateUser(
            User(id: user.id, name: result["name"], imageVersion: imageVersion), imageFile: (result["imagePath"] != null) ? File(result["imagePath"]) : null
        );
        await userProvider.saveProfile(User(id: user.id, name: result["name"], imageVersion: imageVersion));

        LoadingDialog.hideLoadingDialog(context);

      }catch(e){
        LoadingDialog.hideLoadingDialog(context);
        LoadingDialog.showError(context, e);
      }

    }
  }

}