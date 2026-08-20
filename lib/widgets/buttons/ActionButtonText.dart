import 'package:flutter/material.dart';

import '../../../services/LocalizationService.dart';
import '../../utils/theme.dart';

class ActionButtonText extends StatelessWidget {
  final String label;
  final Function() onTap;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;

  const ActionButtonText({super.key, required this.label, required this.onTap, this.fontSize, this.fontFamily, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Center(child: GestureDetector(
      onTap: onTap,
      child: Text(LocalizationService.translate(label),
          style: AppTheme.themeData.textTheme.titleMedium,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

}