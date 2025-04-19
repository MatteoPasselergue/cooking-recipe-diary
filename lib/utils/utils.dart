import 'package:flutter/material.dart';

class Utils {

  static final List<IconData> availableIcons = [
    Icons.ac_unit,
    Icons.fastfood,
    Icons.local_cafe,
    Icons.cake,
    Icons.local_pizza,
    Icons.ramen_dining,
  ];

  static final Map<IconData, String> iconNameMap = {
    Icons.ac_unit: 'ac_unit',
    Icons.fastfood: 'fastfood',
    Icons.local_cafe: 'local_cafe',
    Icons.cake: 'cake',
    Icons.local_pizza: 'local_pizza',
    Icons.ramen_dining: 'ramen_dining',
  };

  static final Map<String, IconData> iconDataMap = {
    'ac_unit': Icons.ac_unit,
    'fastfood': Icons.fastfood,
    'local_cafe': Icons.local_cafe,
    'cake': Icons.cake,
    'local_pizza': Icons.local_pizza,
    'ramen_dining': Icons.ramen_dining,
  };
}