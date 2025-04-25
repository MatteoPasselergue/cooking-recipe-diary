import 'package:cooking_recipe_diary/models/RecipeModel.dart';
import 'package:cooking_recipe_diary/providers/CategoryProvider.dart';
import 'package:cooking_recipe_diary/services/LocalizationService.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';
import 'package:cooking_recipe_diary/widgets/buttons/ActionIconButton.dart';
import 'package:cooking_recipe_diary/widgets/buttons/TagButton.dart';
import 'package:cooking_recipe_diary/widgets/containers/BaseContainer.dart';
import 'package:cooking_recipe_diary/widgets/containers/RecipeImage.dart';
import 'package:cooking_recipe_diary/widgets/containers/ServingsCounterContainer.dart';
import 'package:cooking_recipe_diary/widgets/dialogs/AddEditTagDialog.dart';
import 'package:cooking_recipe_diary/widgets/dropdown/BaseDropdown.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../models/CategoryModel.dart';
import '../../services/ImageService.dart';
import '../../utils/utils.dart';
import '../dialogs/ConfirmationDialog.dart';
import '../snackbar/AppSnackBar.dart';

class EditorHeader extends StatefulWidget {
  final Recipe recipe;
  final Function(Map<String, dynamic> headerData) onSendData;
  final Function() onDelete;
  final Function() onChanged;

  const EditorHeader({super.key, required this.recipe, required this.onSendData, required this.onDelete, required this.onChanged});

  @override
  State<EditorHeader> createState() => _EditorHeaderState();
}

class _EditorHeaderState extends State<EditorHeader> {
  late TextEditingController _nameController;
  late String? imagePath;
  late int imageVersion;
  File? _pickedImage;
  List<String> _tags = [];
  List<Category> _categories = [];

  late int servings;
  late Duration prepTime;
  late Duration restTime;
  late Duration cookTime;
  late Category? category;

  @override
  void initState() {
    imageVersion = widget.recipe.imageVersion;

    super.initState();
    if (widget.recipe.categoryId != 0) {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      category = categoryProvider.categories.firstWhere((c) => c.id == widget.recipe.categoryId);
    } else {
      category = null;
    }

    servings = widget.recipe.servings;
    prepTime = Duration(seconds: widget.recipe.prepTime);
    restTime = Duration(seconds: widget.recipe.restTime);
    cookTime = Duration(seconds: widget.recipe.cookTime);
    imagePath = ImageService.buildImageUrl("recipes", widget.recipe.id, version: widget.recipe.imageVersion);
    _nameController = TextEditingController(text: widget.recipe.name);
    _tags = List<String>.from(widget.recipe.tags);

    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    _categories = categoryProvider.categories;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    widget.onChanged();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        imagePath = pickedFile.path;
      });
    }
  }

  void _deleteImage() {
    setState(() {
      imageVersion = 0;
      _pickedImage = null;
      imagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.6;
    final categoriesId = [0, ..._categories.map((c) => c.id)];
    return Container(
      color: AppConfig.primaryColor,
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16), child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {setState(() {});},
                  controller: _nameController,
                  style: AppTheme.recipeTitleStyle.copyWith(fontSize: 26),
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(8),),
              Row(
                children: [
                  ActionIconButton(factSize: 0.12, icon: Icons.delete, page: null, onTap: deleteRecipe,),
                  ActionIconButton(factSize: 0.12, icon: Icons.check, page: null, onTap: submitData),
                ],
              ),
            ],
          )),
          SingleChildScrollView(scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ..._tags.map((tag) => TagButton(tag: tag, onTap: _editTagDialog)),
                _buildAddTagButton(),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(30),
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: height,
                decoration: AppTheme.recipeCardDecoration,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      (_pickedImage != null) ? Image.file(_pickedImage!, fit: BoxFit.cover) : RecipeImage(id: widget.recipe.id, imageVersion: imageVersion),
                      Container(color: Colors.black.withOpacity(0.2),
                        child: const Center(child: Icon(Icons.edit, color: Colors.white, size: 48,),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_pickedImage != null || widget.recipe.imageVersion != 0)
            TextButton(
              onPressed: _deleteImage,
              child: Text(
                LocalizationService.translate("remove_image"),
                style: AppTheme.textButtonDialogStyle,
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(padding: EdgeInsets.all(6),
                    child: BaseContainer(child: BaseDropdown(onChanged: (id) => _onCategoryChanged(id, _categories), itemBuilder: (id) => _buildCategoryItem(id, _categories), defaultValue: (category != null) ? category!.id : 0, values: categoriesId))),
                Padding(padding: EdgeInsets.all(6),
                    child: BaseContainer(child: ServingsCounterContainer(defaultCounter: servings, onChanged: _onServingsChanged))),
                Padding(padding: EdgeInsets.all(6),
                    child: BaseContainer(child: _buildDurationSelector(Icons.hourglass_full, prepTime,
                            (duration) {
                      setState(() => prepTime = duration);
                    }))),
                Padding(padding: EdgeInsets.all(6), child: BaseContainer(child: _buildDurationSelector(Icons.nightlight_round, restTime,
                        (duration) {
                      setState(() => restTime = duration);
                    }))),
                Padding(padding: EdgeInsets.all(6), child: BaseContainer(child: _buildDurationSelector(Icons.microwave, cookTime,
                        (duration) {
                      setState(() => cookTime = duration);
                    }))),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(10))

        ],
      ),
    );
  }

  Widget _buildAddTagButton() {
    return GestureDetector(
      onTap: () => _editTagDialog(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppConfig.backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add, color: AppConfig.primaryColor),
      ),
    );
  }

  void _onCategoryChanged(int id, List<Category> categories){
    setState(() {
      if(id != 0){
        category =  categories.firstWhere((c) => c.id == id);
        return;
      }
      category = null;
    });
  }

  void _onServingsChanged(int counter){
    setState(() {
      servings = counter;
    });
  }

  Widget _buildCategoryItem(int id, List<Category> categories) {
    return Row(
      children: [
        Padding(padding: const EdgeInsets.only(right: 2), child: Icon(Utils.iconDataMap[_getIconCategoryById(id, categories)] ?? Icons.question_mark, color: AppConfig.primaryColor,),),
        Text(_getCategoryNameById(id, categories), style: TextStyle(fontSize: 14, color: AppConfig.primaryColor, overflow: TextOverflow.ellipsis,), maxLines: 1,),
      ],
    );
  }

  Widget _buildDurationSelector(IconData icon, Duration duration, ValueChanged<Duration> onSelected) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: duration.inHours, minute: duration.inMinutes % 60),
        );
        if (picked != null) {
          final newDuration = Duration(hours: picked.hour, minutes: picked.minute);
          onSelected(newDuration);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppConfig.primaryColor,),
          const SizedBox(width: 4),
          Text("${duration.inHours}h ${duration.inMinutes.remainder(60)}m", style: TextStyle(fontSize: 14, color: AppConfig.primaryColor)),
        ],
      ),
    );
  }

  void _editTagDialog([String? existingTag]) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddEditTagDialog(
        tag: existingTag,
      ),
    );
    if(result != null){
      switch(result["action"]){
        case "delete":
          setState(() {
            _tags.remove(existingTag);
          });
          break;
        case "confirm":
          String newTag = result["tag"];
          if (newTag.isEmpty) return;
          setState(() {
            if (existingTag != null) {
              final index = _tags.indexOf(existingTag);
              if(!_tags.contains(newTag) && index !=-1){
                _tags[index] = newTag;
              }else{
                if(index !=-1){
                  _tags.removeAt(index);
                }
              }
            } else {
              if(!_tags.contains(newTag)){
                _tags.add(newTag);
              }
            }
          });
          break;

      }
    }
  }

  String _getCategoryNameById(int id, List<Category> categories){
    if(id==0) return LocalizationService.translate("no_category");
    final category = categories.firstWhere((c) => c.id == id);
    return category.name;
  }

  String _getIconCategoryById(int id, List<Category> categories){
    if(id==0) return "question_mark";
    final category = categories.firstWhere((c) => c.id == id);
    return category.iconName;
  }

  void submitData() {
    if(_nameController.text.isNotEmpty) {
      final data = {
        "name": _nameController.text.trim(),
        "imagePath": imagePath,
        "tags": _tags,
        "prep": prepTime.inSeconds,
        "cook": cookTime.inSeconds,
        "rest": restTime.inSeconds,
        "category": (category != null) ? category!.id : 0,
        "servings": servings
      };
      widget.onSendData(data);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(AppSnackBar.popMessage("recipe_name_cant_be_empty", error: false));
    }
  }

  void deleteRecipe() async {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return ConfirmationDialog(
            title: LocalizationService.translate("confirm_delete_title_recipe"),
            message: LocalizationService.translate("confirm_delete_message_recipe"),
          );
        },
      );
      if (shouldDelete == true){
        widget.onDelete();
      }
  }
}
