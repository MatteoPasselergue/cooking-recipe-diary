import 'package:flutter/material.dart';

import '../../utils/AppConfig.dart';

class TagButton extends StatelessWidget {
  final String tag;
  final Function(String)? onTap;
  final bool isSelected;

  const TagButton({super.key, required this.tag, this.onTap, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          if(onTap != null) onTap!(tag);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppConfig.primaryColor : AppConfig.backgroundColor,
            border: Border.all(
              color: isSelected ? AppConfig.backgroundColor : AppConfig.primaryColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tag,
            style: TextStyle(color: isSelected ? AppConfig.backgroundColor : AppConfig.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

}