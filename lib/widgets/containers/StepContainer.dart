import 'package:flutter/material.dart';

import '../../utils/AppConfig.dart';
import '../../utils/theme.dart';

class StepContainer extends StatelessWidget {
  final String step;
  final Function(String)? onTap;
  final int position;
  
  const StepContainer({super.key, required this.step, required this.position, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () { if(onTap != null) onTap!(step); },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConfig.primaryColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  position.toString(),
                  style: AppTheme.recipeTitleStyle.copyWith(fontSize: 16),
                ),
              ),
            ),
           Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
           Expanded(child: Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(
             color: AppConfig.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(step, style: AppTheme.textButtonDialogStyle,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}