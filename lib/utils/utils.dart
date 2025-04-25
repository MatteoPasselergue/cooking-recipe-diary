import 'package:flutter/material.dart';

class Utils {

  static final List<IconData> availableIcons = [
    Icons.question_mark,
    Icons.dinner_dining,
    Icons.set_meal,
    Icons.ramen_dining,
    Icons.breakfast_dining,
    Icons.bakery_dining,
    Icons.lunch_dining,
    Icons.soup_kitchen,
    Icons.cake,
    Icons.local_bar,
    Icons.outdoor_grill,
    Icons.emoji_food_beverage,
    Icons.whatshot,
    Icons.ac_unit,
    Icons.celebration,
    Icons.grass,
    Icons.public,
    Icons.icecream,
    Icons.restaurant,
    Icons.kitchen,
    Icons.dining,
    Icons.fastfood,
    Icons.local_pizza,
  ];

  static final Map<IconData, String> iconNameMap = {
    Icons.question_mark: 'question_mark',
    Icons.dinner_dining: 'dinner_dining',
    Icons.set_meal: 'set_meal',
    Icons.ramen_dining: 'ramen_dining',
    Icons.breakfast_dining: 'breakfast_dining',
    Icons.bakery_dining: 'bakery_dining',
    Icons.lunch_dining: 'lunch_dining',
    Icons.soup_kitchen: 'soup_kitchen',
    Icons.cake: 'cake',
    Icons.local_bar: 'local_bar',
    Icons.outdoor_grill: 'outdoor_grill',
    Icons.emoji_food_beverage: 'emoji_food_beverage',
    Icons.whatshot: 'whatshot',
    Icons.ac_unit: 'ac_unit',
    Icons.celebration: 'celebration',
    Icons.grass: 'grass',
    Icons.public: 'public',
    Icons.icecream: 'icecream',
    Icons.restaurant: 'restaurant',
    Icons.kitchen: 'kitchen',
    Icons.dining: 'dining',
    Icons.fastfood: 'fastfood',
    Icons.local_pizza: 'local_pizza',
  };

  static final Map<String, IconData> iconDataMap = {
    'question_mark': Icons.question_mark,
    'dinner_dining': Icons.dinner_dining,
    'set_meal': Icons.set_meal,
    'ramen_dining': Icons.ramen_dining,
    'breakfast_dining': Icons.breakfast_dining,
    'bakery_dining': Icons.bakery_dining,
    'lunch_dining': Icons.lunch_dining,
    'soup_kitchen': Icons.soup_kitchen,
    'cake': Icons.cake,
    'local_bar': Icons.local_bar,
    'outdoor_grill': Icons.outdoor_grill,
    'emoji_food_beverage': Icons.emoji_food_beverage,
    'whatshot': Icons.whatshot,
    'ac_unit': Icons.ac_unit,
    'celebration': Icons.celebration,
    'grass': Icons.grass,
    'public': Icons.public,
    'icecream': Icons.icecream,
    'restaurant': Icons.restaurant,
    'kitchen': Icons.kitchen,
    'dining': Icons.dining,
    'fastfood': Icons.fastfood,
    'local_pizza': Icons.local_pizza,
  };

  static void closeDialog(BuildContext context, {Object? data = null}) {
    FocusScope.of(context).unfocus();
    if(data != null){
      Navigator.of(context).pop(data);
    }else {
      Navigator.of(context).pop();
    }
  }


}