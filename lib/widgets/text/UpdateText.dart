import 'package:flutter/material.dart';

import '../../../services/LocalizationService.dart';
import '../../utils/theme.dart';

class UpdateText extends StatelessWidget {
  final String version;
  final String releaseNotes;

  const UpdateText({super.key, required this.version, required this.releaseNotes});


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(LocalizationService.translate("new_update_title"),
            style: AppTheme.themeData.textTheme.titleMedium,
          ),
        Text("${LocalizationService.translate("app_name")} $version",
          style: AppTheme.themeData.textTheme.titleMedium
        ),
        SizedBox(height: 36,),
        Text(LocalizationService.translate("new_update_content"),
          style: AppTheme.themeData.textTheme.bodyMedium,
        ),
        SizedBox(height: 36,),
        Text(LocalizationService.translate("what_new"),
          style: AppTheme.themeData.textTheme.titleMedium,
        ),
        SizedBox(height: 8,),
        Padding(padding: EdgeInsets.only(left: 16),
          child: Text(releaseNotes,
            style: AppTheme.themeData.textTheme.titleMedium,
          ),
        ),
      ],
    );
  }

}