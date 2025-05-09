import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../services/LocalizationService.dart';
import '../../utils/theme.dart';
import '../snackbar/AppSnackBar.dart';

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
            onPressed: () => Utils.closeDialog(context, data:{"action": "delete"}),
            child: Text(
              LocalizationService.translate("delete"),
              style: AppTheme.textButtonDialogStyle,
            ),
          ),
        TextButton(
          onPressed: () => Utils.closeDialog(context, data:{"action": "cancel"}),
          child: Text(LocalizationService.translate("cancel"), style: AppTheme.textButtonDialogStyle),
        ),
        TextButton(
          onPressed: () {
            final newName = controller.text.trim();
            if(newName.isNotEmpty){
              Utils.closeDialog(context, data: {"action": "confirm", "tag": newName});
            }else{
              ScaffoldMessenger.of(context).showSnackBar(AppSnackBar.popMessage("tag_cant_be_empty", error: false));
            }
          },
          child: Text(LocalizationService.translate("confirm"), style: AppTheme.textButtonDialogStyle,),
        ),
      ],
    );
  }
}