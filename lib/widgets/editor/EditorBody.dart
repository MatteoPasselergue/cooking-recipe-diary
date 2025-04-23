import 'package:cooking_recipe_diary/models/RecipeModel.dart';
import 'package:cooking_recipe_diary/utils/AppConfig.dart';
import 'package:cooking_recipe_diary/utils/theme.dart';
import 'package:cooking_recipe_diary/widgets/containers/StepContainer.dart';
import 'package:cooking_recipe_diary/widgets/dialogs/AddEditIngredientDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/LocalizationService.dart';
import '../containers/IngredientContainer.dart';
import '../dialogs/AddEditStepDialog.dart';
import '../home/WavePainter.dart';

class EditorBody extends StatefulWidget {
  final Recipe recipe;
  final Function() onChanged;

  const EditorBody({super.key, required this.recipe, required this.onChanged});

  @override
  State<EditorBody> createState() => EditorBodyState();
}

class EditorBodyState extends State<EditorBody> {
  late List<String> steps;
  late List<Ingredient> ingredients;

  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    steps = List.from(widget.recipe.steps);
    ingredients = List.from(widget.recipe.ingredients);
    _noteController = TextEditingController(text: widget.recipe.note);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> ingredientsButton = [
      ...ingredients.map((ingredient) => IngredientContainer(ingredient: ingredient, onTap: _editIngredient)),
      _buildAddButton("ingredient"),
    ];
    List<Widget> stepsButton = [
      ...steps.asMap().entries.map((entry) => StepContainer(step: entry.value, position: entry.key + 1, onTap: _editStep,)),
    ];
    return Expanded(
        child: Column(
            children: [
              CustomPaint(
                size: Size(MediaQuery
                    .of(context)
                    .size
                    .width, 10),
                painter: WavePainter(waveColor: AppConfig.backgroundColor),
              ),
              Expanded(
                  child: Container(
                    width: double.infinity,
                    color: AppConfig.backgroundColor,
                    child: Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 6), child: Column(
                      children: [
                        Padding(padding: EdgeInsets.all(10), child: Align(alignment: Alignment.centerLeft,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {});
                                },
                              controller: _noteController,
                              cursorColor: AppConfig.textColor,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: LocalizationService.translate("note"),
                              ),
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                            )
                        ),),
                        Padding(padding: EdgeInsets.only(left: 10), child: Align(alignment: Alignment.centerLeft, child: Text(LocalizationService.translate("ingredients"), style: AppTheme.recipeTitleStyle.copyWith(fontSize: 30),))),
                        Padding(padding: EdgeInsets.all(5)),
                        Wrap(spacing: 8, runSpacing:  8,
                          children: ingredientsButton,),
                        Padding(padding: EdgeInsets.all(10)),
                        Padding(padding: EdgeInsets.only(left: 10), child: Align(alignment: Alignment.centerLeft, child: Text(LocalizationService.translate("steps"), style: AppTheme.recipeTitleStyle.copyWith(fontSize: 30),))),
                        ...stepsButton,
                        _buildAddButton("step")
                      ]),
                    ),
                  ))
            ]
        )
    );
  }

  Widget _buildAddButton(String type){
    return GestureDetector(
      onTap: () async {
        switch(type){
          case "ingredient":
            _editIngredient();
            break;
          case "step":
            _editStep();
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppConfig.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add, color: AppConfig.backgroundColor),
      ),
    );
  }

  void _editIngredient([Ingredient? ingredient]) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddEditIngredientDialog(ingredient: ingredient,),
    );
    if(result != null){
      switch(result["action"]){
        case "delete":
          setState(() {
            ingredients.remove(ingredient);
          });
          break;
        case "confirm":
          Ingredient newIngredient = result["ingredient"];
          setState(() {
            if (ingredient != null) {
              final index = ingredients.indexOf(ingredient);
              if(!ingredients.contains(newIngredient) && index !=-1){
                ingredients[index] = newIngredient;
              }else{
                if(index !=-1){
                  ingredients.removeAt(index);
                }
              }
            } else {
              if(!ingredients.contains(newIngredient)){
                ingredients.add(newIngredient);
              }
            }
          });
          break;
      }
    }
  }

  void _editStep([String? step]) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddEditStepDialog(step: step),
    );
    if(result != null){
      switch(result["action"]){
        case "delete":
          setState(() {
            steps.remove(step);
          });
          break;
        case "confirm":
          String newStep = result["step"];
          setState(() {
            if (step != null) {
              final index = steps.indexOf(step);
              if (index != -1) {
                if (newStep.trim().isEmpty) {
                  steps.removeAt(index);
                } else {
                  steps[index] = newStep;
                }
              }
            } else {
              if (newStep.trim().isNotEmpty && !steps.contains(newStep)) {
                steps.add(newStep);
              }
            }
          });
          break;
      }
    }
  }

  Map<String, dynamic> getData() {
    return {
      "ingredients": ingredients,
      "steps": steps,
      "note": _noteController.text.trim()
    };
  }
}