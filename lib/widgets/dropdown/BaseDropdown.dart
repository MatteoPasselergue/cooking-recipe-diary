import 'package:flutter/material.dart';

import '../../utils/AppConfig.dart';

class BaseDropdown extends StatelessWidget {
  final Function(int) onChanged;
  final Widget Function(int) itemBuilder;
  final int defaultValue;
  final List<int> values;

  const BaseDropdown({super.key, required this.onChanged, required this.itemBuilder, required this.defaultValue, required this.values});

  @override
  Widget build(BuildContext context) {
    int value = defaultValue;

    return DropdownButton<int>(
      icon: const SizedBox.shrink(),
      dropdownColor: AppConfig.backgroundColor,
      value: value,
      underline: const SizedBox(),
      items: values.map((id) {
        return DropdownMenuItem<int>(
          value: id,
          child: itemBuilder.call(id),
        );
      }).toList(),
      onChanged: (newValue) {
          onChanged(newValue!);
        },
    );
  }


}