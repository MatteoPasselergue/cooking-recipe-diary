import 'package:flutter/material.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';

class PageIconButton extends StatelessWidget {
  final IconData icon;
  final String page;

  const PageIconButton(this.icon, this.page, {super.key});

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.15;

    return Padding(padding: const EdgeInsets.all(5.0) ,child :InkWell(
      onTap: () => _navigate(context),
      child: Container(
        width: size,
        height: size,
        decoration: AppTheme.iconButtonDecoration,
        child: Center(
          child: Icon(
            icon,
            color: AppConfig.primaryColor,
            size: size * 0.5,
          ),
        ),
      ),
    ));
  }

  void _navigate(BuildContext context) {
    Navigator.pushNamed(context, page);
  }
}
