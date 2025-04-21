import 'package:flutter/material.dart';

import '../../services/LocalizationService.dart';
import '../../utils/AppConfig.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;

  const ConfirmationDialog({Key? key, required this.title, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppConfig.primaryColor,
      title: Text(title, style: TextStyle(color: AppConfig.textColor)),
      content: Text(message, style: TextStyle(color: AppConfig.textColor)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(LocalizationService.translate("cancel"), style: TextStyle(color: AppConfig.textColor)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(LocalizationService.translate("confirm"), style: TextStyle(color: AppConfig.textColor)),
        ),
      ],
    );
  }
}
