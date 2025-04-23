import 'package:flutter/material.dart';

import '../../utils/AppConfig.dart';

class TagButton extends StatelessWidget {
  final String tag;
  final Function(String)? onTap;

  const TagButton({super.key, required this.tag, this.onTap});

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
            color: AppConfig.backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tag,
            style: TextStyle(color: AppConfig.primaryColor),
          ),
        ),
      ),
    );
  }

}