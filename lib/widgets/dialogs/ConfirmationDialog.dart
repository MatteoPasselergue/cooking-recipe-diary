import 'package:flutter/material.dart';

import '../../services/LocalizationService.dart';
import '../../utils/AppConfig.dart';
import '../../utils/utils.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;

  const ConfirmationDialog({Key? key, required this.title, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppConfig.primaryColor,
      title: Text(title, style: TextStyle(color: AppConfig.textColor, fontWeight: FontWeight.bold, fontFamily: "Rokkitt", fontSize: 25)),
      content: Text(message, style: TextStyle(color: AppConfig.textColor)),
      actions: [
        TextButton(
          onPressed: () {
            Utils.closeDialog(context, data: false);
          },
          child: Text(LocalizationService.translate("cancel"), style: TextStyle(color: AppConfig.textColor)),
        ),
        TextButton(
          onPressed: () {
            Utils.closeDialog(context, data: true);
          },
          child: Text(LocalizationService.translate("confirm"), style: TextStyle(color: AppConfig.textColor)),
        ),
      ],
    );
  }
}
