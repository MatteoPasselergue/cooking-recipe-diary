import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/CategoryModel.dart';
import '../../providers/CategoryProvider.dart';
import '../../services/LocalizationService.dart';
import '../../utils/AppConfig.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import 'LoadingDialog.dart';

class AddCategoryDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddCategoryDialog();
}

class _AddCategoryDialog extends State<AddCategoryDialog> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedIconName = 'question_mark';

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    return AlertDialog(
      backgroundColor: AppConfig.primaryColor,
      title: Text(LocalizationService.translate("add_category"), style: AppTheme.textButtonDialogStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 25),),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: LocalizationService.translate("name_category"),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppConfig.backgroundColor),
                  ),
                ),
                cursorColor: AppConfig.textColor,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: Utils.availableIcons.length,
                  separatorBuilder: (context, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final icon = Utils.availableIcons[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIconName = Utils.iconNameMap[icon]!;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedIconName == Utils.iconNameMap[icon] ? AppConfig.backgroundColor : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, size: 32),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Utils.closeDialog(context),
          child: Text(LocalizationService.translate("cancel"), style: AppTheme.textButtonDialogStyle),
        ),
        TextButton(
          onPressed: () async {
            if (_nameController.text.isNotEmpty) {
              LoadingDialog.showLoadingDialog(context, "add_category");
              try{
                await categoryProvider.addCategory(
                  Category(
                    id: 0,
                    name: _nameController.text,
                    iconName: _selectedIconName,
                  ),
                );

                LoadingDialog.hideLoadingDialog(context);

                Utils.closeDialog(context);
              }catch(e){
                LoadingDialog.hideLoadingDialog(context);
                LoadingDialog.showError(context, e);
              }
            }
          },
          child: Text(LocalizationService.translate("add"), style: AppTheme.textButtonDialogStyle),
        ),
      ],
    );
  }
}
