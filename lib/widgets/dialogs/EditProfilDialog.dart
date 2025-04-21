import 'dart:io';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/LocalizationService.dart';

class EditProfilDialog extends StatefulWidget {
  final String? currentName;
  final String? currentImagePath;

  const EditProfilDialog({super.key, required this.currentName, required this.currentImagePath});

  @override
  _EditProfilDialogState createState() => _EditProfilDialogState();
}

class _EditProfilDialogState extends State<EditProfilDialog> {
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

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName ?? '';
    _imagePath = widget.currentImagePath;
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
      title: Text(LocalizationService.translate("edit_profile")),
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
            Navigator.pop(context);
          },
          child: Text(LocalizationService.translate("cancel"), style: AppTheme.textButtonDialogStyle),
        ),
        TextButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isNotEmpty) {
              Navigator.pop(context, {
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
