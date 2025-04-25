import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/LocalizationService.dart';
import '../../utils/theme.dart';
import '../snackbar/AppSnackBar.dart';

class AddEditStepDialog extends StatelessWidget {
  final String? step;

  const AddEditStepDialog({super.key, this.step});

  @override
  Widget build(BuildContext context) {
    final TextEditingController stepController = TextEditingController(text: step ?? '');
    return AlertDialog(
      backgroundColor: AppConfig.primaryColor,
      title: Text(step != null ? LocalizationService.translate("edit_step") : LocalizationService.translate("add_step"), style: AppTheme.textButtonDialogStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 25),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: stepController,
            decoration: InputDecoration(
              hintText: LocalizationService.translate("step_content"),
            ),
          ),
        ],
      ),
      actions: [
        if (step != null)
          TextButton(
            onPressed: () {
              Utils.closeDialog(context, data: {"action": "delete"});
            },
            child: Text(LocalizationService.translate("delete"),
                style: AppTheme.textButtonDialogStyle),
          ),
        TextButton(
          onPressed: () => Utils.closeDialog(context, data: {"action": "cancel"}),
          child: Text(LocalizationService.translate("cancel"),
              style: AppTheme.textButtonDialogStyle),
        ),
        TextButton(
          onPressed: () {
            final String content = stepController.text.trim();

            if (content.isNotEmpty) {
              Utils.closeDialog(context, data: {
                "action": "confirm",
                "step": content,
              });
            }else{
              ScaffoldMessenger.of(context).showSnackBar(AppSnackBar.popMessage("step_cant_be_empty", error: false));
            }
          },
          child: Text(LocalizationService.translate("confirm"),
              style: AppTheme.textButtonDialogStyle),
        ),
      ],
    );
  }
}
