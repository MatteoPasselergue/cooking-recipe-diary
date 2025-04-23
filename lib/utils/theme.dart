import 'package:flutter/material.dart';

import 'AppConfig.dart';

class AppTheme {

  static final BoxDecoration iconButtonDecoration =  BoxDecoration(
    color: AppConfig.backgroundColor,
    borderRadius: BorderRadius.circular(20),
  );

  static final BoxDecoration categoryButtonDecoration = BoxDecoration(
    color: AppConfig.primaryColor,
    borderRadius: BorderRadius.circular(20),
  );

  static final TextStyle textButtonDialogStyle = TextStyle(
      color: AppConfig.textColor,
      fontFamily: 'Quicksand',
      fontSize: 16.0
  );

  static ThemeData get themeData {
    return ThemeData(
      primaryColor: AppConfig.primaryColor,
      hintColor: AppConfig.accentColor,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Rokkitt',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppConfig.textColor,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Rokkitt',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppConfig.textColor,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppConfig.textColor,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppConfig.textColor,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppConfig.textColor,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppConfig.textColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(fontFamily: 'Quicksand', color: AppConfig.textColor),
        labelStyle: TextStyle(fontFamily: 'Quicksand', color: AppConfig.textColor),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppConfig.textColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppConfig.accentColor),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppConfig.accentColor,
        textTheme: ButtonTextTheme.primary,
      ),
      iconTheme: IconThemeData(
        color: AppConfig.textColor,
      ),
      timePickerTheme: TimePickerThemeData(
        dialTextStyle: recipeTitleStyle,
        helpTextStyle: recipeTitleStyle.copyWith(fontSize: 26),
        backgroundColor: AppConfig.primaryColor,
        dialBackgroundColor: AppConfig.backgroundColor,
        hourMinuteTextColor: AppConfig.textColor,
        dialTextColor: AppConfig.textColor,
        dialHandColor: AppConfig.primaryColor,
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hourMinuteColor: AppConfig.primaryColor,
        cancelButtonStyle: TextButton.styleFrom(backgroundColor: AppConfig.backgroundColor, textStyle: textButtonDialogStyle, foregroundColor: AppConfig.primaryColor),
        confirmButtonStyle: TextButton.styleFrom(backgroundColor: AppConfig.backgroundColor, textStyle: textButtonDialogStyle, foregroundColor: AppConfig.primaryColor)
      ),
    );
  }

  static final recipeCardDecoration = BoxDecoration(
    color: AppConfig.backgroundColor,
    borderRadius: BorderRadius.circular(16),
  );

  static final recipeTitleStyle = TextStyle(
    fontFamily: 'Rokkitt',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppConfig.textColor,
  );
}
