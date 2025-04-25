import 'package:cooking_recipe_diary/services/LocalizationService.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:flutter/material.dart';

import '../../utils/theme.dart';

class AddImportRecipeDialog extends StatelessWidget {
  final TextEditingController urlController = TextEditingController();

  AddImportRecipeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppConfig.primaryColor,
      title: Text(LocalizationService.translate("new_recipe_choice"), style: AppTheme.textButtonDialogStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 25)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(LocalizationService.translate("create_from_scratch")),
            onTap: () {
              Navigator.of(context).pop({"action": "add"});
            },
          ),
          Divider(color: AppConfig.backgroundColor,),
          ListTile(
            onTap: () async {
              final result = await showDialog<Map<String, String>>(context: context,
                builder: (context) => _importDialog(context)
              );
              if(result !=null && result["url"] != null ){
                Navigator.of(context).pop({"action": "import", "url": result["url"]});
              }else Navigator.of(context).pop();
            },
            title: Text(LocalizationService.translate("import_from_url")),
          )
        ],
      ),
    );
  }
  Widget _importDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppConfig.primaryColor,
      title: Text(
        LocalizationService.translate("import_from_url"),
        style: AppTheme.textButtonDialogStyle.copyWith(
            fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: urlController,
            decoration: InputDecoration(
              hintText: LocalizationService.translate("enter_recipe_url"),
            ),
            keyboardType: TextInputType.url,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(LocalizationService.translate("cancel"),
            style: AppTheme.textButtonDialogStyle,
          ),
        ),
        TextButton(
          onPressed: () {
            String url = urlController.text;
            if(url.isNotEmpty){
              Navigator.of(context).pop({"url": url});
            }
          },
          child: Text(LocalizationService.translate("confirm"),
            style: AppTheme.textButtonDialogStyle,
          ),
        ),
      ],
    );
  }
}