import 'package:cooking_recipe_diary/models/CategoryModel.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/CategoryProvider.dart';
import '../../../services/LocalizationService.dart';
import '../../../utils/utils.dart';
import 'AddCategoryDialog.dart';
import 'EditCategoryDialog.dart';

class CategoryButtons extends StatefulWidget {
  @override
  _CategoryButtonsState createState() => _CategoryButtonsState();
}

class _CategoryButtonsState extends State<CategoryButtons> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      try {
        await Provider
            .of<CategoryProvider>(context, listen: false)
            .fetchCategories();
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 4,
      ),
      itemCount: categoryProvider.categories.length + 1,
      itemBuilder: (context, index) {
        if (index < categoryProvider.categories.length && categoryProvider.categories.isNotEmpty) {
          final category = categoryProvider.categories[index];
          return CategoryButton(category);
        } else {
          return AddCategoryButton();
        }
      },
    );
  }
}

class CategoryButton extends StatelessWidget {
  final Category category;

  CategoryButton(this.category);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (_) => EditCategoryDialog(category: category),
        );
      },
      onTap: () {/*TODO*/},
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: AppTheme.categoryButtonDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(right: 2), child: Icon(Utils.iconDataMap[category.iconName] ?? Icons.help_outline)),
            Flexible(child: Text(category.name, overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false)),
          ],
        ),
      ),
    );
  }
}

class AddCategoryButton extends StatelessWidget {
  const AddCategoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AddCategoryDialog(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: AppTheme.categoryButtonDecoration,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(right: 2), child: Icon(Icons.add)),
            Flexible(child: Text(LocalizationService.translate("add_category"),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,)),
          ],
        ),
      ),
    );
  }
}




