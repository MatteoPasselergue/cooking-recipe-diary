import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/UserProvider.dart';
import '../../screens/ProfileSelectionScreen.dart';

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

    if(widget.delete){
      await userProvider.deleteUser(userProvider.profile!.id);
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
      backgroundColor: AppConfig.backgroundColor,
      body: Center(
        child: CircularProgressIndicator(color: AppConfig.primaryColor,),
      ),
    );
  }
}
