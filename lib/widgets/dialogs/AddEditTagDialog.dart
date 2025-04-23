import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:flutter/material.dart';
import '../../services/LocalizationService.dart';
import '../../utils/theme.dart';

class AddEditTagDialog extends StatelessWidget {
  final String? tag;
  
  const AddEditTagDialog({super.key, this.tag});

  
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: tag ?? '');

    return AlertDialog(
      backgroundColor: AppConfig.primaryColor,
      title: Text(tag != null ? LocalizationService.translate("edit_tag") : LocalizationService.translate("add_tag"), style: AppTheme.textButtonDialogStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 25),),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: LocalizationService.translate("name_tag")),
      ),
      actions: [
        if (tag != null)
          TextButton(
            onPressed: () => Navigator.pop(context, {"action": "delete"}),
            child: Text(
              LocalizationService.translate("delete"),
              style: AppTheme.textButtonDialogStyle,
            ),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context, {"action": "cancel"}),
          child: Text(LocalizationService.translate("cancel"), style: AppTheme.textButtonDialogStyle),
        ),
        TextButton(
          onPressed: () {
            final newName = controller.text.trim();
            Navigator.pop(context, {"action": "confirm", "tag": newName});
          },
          child: Text(LocalizationService.translate("confirm"), style: AppTheme.textButtonDialogStyle,),
        ),
      ],
    );
  }
}