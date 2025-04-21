import 'package:cooking_recipe_diary/screens/ProfileSelectionScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/LanguageProvider.dart';
import '../../providers/UserProvider.dart';
import '../../services/LocalizationService.dart';
import '../../utils/AppConfig.dart';
import '../dialogs/ConfirmationDialog.dart';
import '../home/WavePainter.dart';
import 'LogoutWaitScreen.dart';

class ProfileBodyContainer extends StatefulWidget {
  @override
  _ProfileBodyContainerState createState() => _ProfileBodyContainerState();
}

class _ProfileBodyContainerState extends State<ProfileBodyContainer> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Expanded(
      child: Column(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 10),
            painter: WavePainter(waveColor: AppConfig.backgroundColor),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: AppConfig.backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.all(10)),
                  ListTile(
                    leading: Icon(Icons.language, color: AppConfig.primaryColor),
                    title: Text(
                      LocalizationService.translate("lang"),
                      style: TextStyle(color: AppConfig.textColor),
                    ),
                    trailing: DropdownButton<String>(
                      value: languageProvider.locale,
                      underline: SizedBox(),
                      items: languageProvider.availableLocales.map((localeMap) {
                        return DropdownMenuItem(
                          value: localeMap['code'],
                          child: Text(localeMap['name'] ?? localeMap['code']!),
                        );
                      }).toList(),
                      onChanged: (newLocale) {
                        if (newLocale != null) {
                          languageProvider.setLocale(newLocale);
                        }
                      },
                    ),
                  ),
                  Spacer(),
                  Divider(color: AppConfig.primaryColor),
                  ListTile(
                    leading: Icon(Icons.logout, color: AppConfig.primaryColor),
                    title: Text(
                      LocalizationService.translate("logout"),
                      style: TextStyle(color: AppConfig.textColor),
                    ),
                    onTap: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmationDialog(
                            title: LocalizationService.translate("confirm_logout_title"),
                            message: LocalizationService.translate("confirm_logout_message"),
                          );
                        },
                      );
                      if(shouldLogout == true){
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LogoutScreen(delete: false,)),
                        );
                      }
                    },
                  ),
                  Divider(color: AppConfig.primaryColor),
                  ListTile(
                    leading: Icon(Icons.delete, color: AppConfig.primaryColor),
                    title: Text(
                      LocalizationService.translate("delete_profile"),
                      style: TextStyle(color: AppConfig.textColor, fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmationDialog(
                            title: LocalizationService.translate("confirm_delete_title"),
                            message: LocalizationService.translate("confirm_delete_message"),
                          );
                        },
                      );
                      if (shouldDelete == true){
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LogoutScreen(delete: true,)),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
