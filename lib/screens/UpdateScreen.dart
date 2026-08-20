import 'package:flutter/material.dart';

import '../services/LocalizationService.dart';
import '../services/UpdateService.dart';
import '../widgets/buttons/ActionButtonText.dart';
import '../widgets/text/UpdateText.dart';

class UpdateScreen extends StatefulWidget {
  final String latestVersion;
  final String downloadUrl;
  final String releaseNotes;

  const UpdateScreen({
    super.key,
    required this.latestVersion,
    required this.downloadUrl,
    required this.releaseNotes,
  });

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  bool isDownloading = false;
  double progress = 0;

  void startDownload() async {
    setState(() {
      isDownloading = true;
    });

    await UpdateService.startUpdate(
      widget.downloadUrl,
      onProgress: (value) {
        setState(() {
          progress = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 16), child: Column(
              children: [
                SizedBox(height: 36,),
                UpdateText(version: widget.latestVersion, releaseNotes: widget.releaseNotes),
                SizedBox(height: 72,),
                (!isDownloading) ?
                ActionButtonText(label: LocalizationService.translate("download_and_install"), onTap: startDownload, fontSize: 20,)
                    : Column(
                  children: [
                    LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(12),
                        minHeight: 8,
                        value: progress,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text("${(progress * 100).toInt()}%"),
                    SizedBox(height: MediaQuery.paddingOf(context).bottom+36)
                  ],
                )

              ],
            )),
          )
      )
    );
  }
}