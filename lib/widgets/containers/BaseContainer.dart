import 'package:flutter/material.dart';

import '../../utils/AppConfig.dart';

class BaseContainer extends StatelessWidget {
  final Widget child;

  const BaseContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppConfig.backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }

}