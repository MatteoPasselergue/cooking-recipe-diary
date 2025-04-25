import 'package:cooking_recipe_diary/widgets/icons/SpinningIcon.dart';
import 'package:cooking_recipe_diary/services/LocalizationService.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';
import 'package:flutter/material.dart';


class LoadingDialog {
  static Future<void> showLoadingDialog(BuildContext context, String type) {

    String message = LocalizationService.translate("be_patient_message");
    switch(type){
      case "import":
        message = "$message\n  ${LocalizationService.translate("importation_waiting_message")}";
        break;
      case "add_recipe":
        message = "$message\n ${LocalizationService.translate("add_recipe_waiting_message")}";
        break;
      case "edit_recipe":
        message = "$message\n ${LocalizationService.translate("edit_recipe_waiting_message")}";
        break;
      case "remove_recipe":
        message = "$message\n ${LocalizationService.translate("remove_recipe_waiting_message")}";
        break;
      case "add_user":
        message = "$message\n ${LocalizationService.translate("add_user_waiting_message")}";
        break;
      case "save_profile":
        message = "$message\n ${LocalizationService.translate("save_profile_waiting_message")}";
        break;
      case "edit_user":
        message = "$message\n ${LocalizationService.translate("edit_user_waiting_message")}";
        break;
      case "add_category":
        message = "$message\n ${LocalizationService.translate("add_category_waiting_message")}";
        break;
      case "remove_category":
        message = "$message\n ${LocalizationService.translate("remove_category_waiting_message")}";
        break;
      case "edit_category":
        message = "$message\n ${LocalizationService.translate("edit_category_waiting_message")}";
        break;
    }


    return showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: AppConfig.backgroundColor,
          content: Padding(padding: EdgeInsets.all(5), child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              SpinningIcon(
                icon: Icons.restaurant, // 🍴
                color: AppConfig.primaryColor,
                size: 48,
              ),
              const SizedBox(height: 24),
              Text(
                message,
                style: AppTheme.textButtonDialogStyle,
                textAlign: TextAlign.center,
              ),
            ],
          )),
        ),
      ),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static void showError(BuildContext context, String errorCode) {
    /*TODO*/
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorCode)),
    );
  }

}
