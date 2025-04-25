import 'dart:io';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/LocalizationService.dart';
import '../../utils/utils.dart';

class AddProfileDialog extends StatefulWidget {
  @override
  _AddProfileDialogState createState() => _AddProfileDialogState();
}

class _AddProfileDialogState extends State<AddProfileDialog> {
  final TextEditingController _nameController = TextEditingController();
  String? _imagePath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _imagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppConfig.primaryColor,
      title: Text(LocalizationService.translate("add_profile"), style: AppTheme.textButtonDialogStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 25)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                backgroundColor: AppConfig.backgroundColor,
                radius: 40,
                backgroundImage: _imagePath != null
                    ? FileImage(File(_imagePath!))
                    : null,
                child: _imagePath == null
                    ? Icon(Icons.add_a_photo, size: 40, color: AppConfig.primaryColor,)
                    : null,
              ),
            ),
            SizedBox(height: 20),
            if (_imagePath != null)
              TextButton(
                onPressed: _removeImage,
                child: Text(LocalizationService.translate("remove_image"), style: AppTheme.textButtonDialogStyle),
              ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: LocalizationService.translate("username"),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppConfig.backgroundColor),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Utils.closeDialog(context);
          },
          child: Text(LocalizationService.translate("cancel"), style: AppTheme.textButtonDialogStyle),
        ),
        TextButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isNotEmpty) {
              Utils.closeDialog(context, data:{
                'name': name,
                'imagePath': _imagePath,
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(LocalizationService.translate("error_missing_username"))),
              );
            }
          },
          child: Text(LocalizationService.translate("confirm"), style: AppTheme.textButtonDialogStyle),
        ),
      ],
    );
  }
}
