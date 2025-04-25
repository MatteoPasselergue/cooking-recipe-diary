import 'package:flutter/material.dart';

import '../../models/CategoryModel.dart';
import '../../services/LocalizationService.dart';
import '../../utils/AppConfig.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';

class CategorySelectionDialog  extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final Function(Category?) onSelected;

  const CategorySelectionDialog({super.key, required this.categories, required this.onSelected, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppConfig.primaryColor,
      title: Text(LocalizationService.translate("filter_by_category"), style: AppTheme.recipeTitleStyle.copyWith(fontSize: 25),),
      content: DropdownButton<Category>(
        dropdownColor: AppConfig.primaryColor,
        isExpanded: true,
        value: selectedCategory,
        items: [
          DropdownMenuItem<Category>(
            value: null,
            child: Text(LocalizationService.translate("all_categories")),
          ),
          ...categories.map((cat) => DropdownMenuItem(
            value: cat,
            child: Text(cat.name),
          )),
        ],
        onChanged: (value) {
          onSelected(value);
          Utils.closeDialog(context);
        },
      ),
    );
  }

}