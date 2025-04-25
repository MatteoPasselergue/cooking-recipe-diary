import 'package:cooking_recipe_diary/models/RecipeModel.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/LocalizationService.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';

class AddEditIngredientDialog extends StatelessWidget {
  final Ingredient? ingredient;

  const AddEditIngredientDialog({super.key, this.ingredient});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(
        text: ingredient?.name ?? '');
    final TextEditingController unitController = TextEditingController(
        text: ingredient?.unit ?? '');
    final TextEditingController quantityController = TextEditingController(
        text: ingredient?.quantity.toString() ?? '');

    return AlertDialog(
      backgroundColor: AppConfig.primaryColor,
      title: Text(ingredient != null
          ? LocalizationService.translate("edit_ingredient")
          : LocalizationService.translate("add_ingredient"),
        style: AppTheme.textButtonDialogStyle.copyWith(
            fontWeight: FontWeight.bold, fontSize: 25),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                  ],
                  decoration: InputDecoration(
                    hintText: LocalizationService.translate("ingredient_quantity"),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(8)),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: unitController,
                  decoration: InputDecoration(
                    hintText: LocalizationService.translate("ingredient_unit"),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(8)),

            ],
          ),
          TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: LocalizationService.translate("ingredient_name"),
              ),
            ),
        ],
      ),
      actions: [
        if (ingredient != null)
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
            final String name = nameController.text.trim();
            final String unit = unitController.text.trim();
            final String quantityText = quantityController.text.trim();
            final double? quantity = double.tryParse(quantityText);

            if (name.isEmpty) {
              Navigator.of(context).pop();
              return;
            }

            Utils.closeDialog(context, data: {
              "action": "confirm",
              "ingredient": Ingredient(
                  name: name, quantity: quantity ?? 0, unit: unit),
            });
          },
          child: Text(LocalizationService.translate("confirm"),
              style: AppTheme.textButtonDialogStyle),
        ),
      ],
    );
  }
}
