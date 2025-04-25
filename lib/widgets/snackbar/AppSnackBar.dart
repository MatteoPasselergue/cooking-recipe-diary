import 'package:cooking_recipe_diary/services/LocalizationService.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  static SnackBar popMessage(String key, {bool error = false}){
    return SnackBar(
        backgroundColor: AppConfig.backgroundColor,
        content: Text((error) ? LocalizationService.translateError(key) : LocalizationService.translate(key), style: AppTheme.textButtonDialogStyle.copyWith(fontSize: 16),));
  }
}