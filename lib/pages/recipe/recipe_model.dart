import '/flutter_flow/flutter_flow_util.dart';
import 'recipe_widget.dart' show RecipeWidget;
import 'package:flutter/material.dart';

/// RecipeModel extends FlutterFlowModel to manage state for the RecipeWidget.
class RecipeModel extends FlutterFlowModel<RecipeWidget> {
  /// State fields for stateful widgets in this page.

  /// Stores the recipe data as a string, generated from an image using Gemini AI.
  /// This is the output of the [Gemini - Text From Image] action in the btn_regenerate widget.
  String? recipeDataStr;

  /// Stores the URL or path of the generated image.
  /// This is the output of the [Custom Action - generateImage] action in the btn_regenerate widget.
  String? outputIMG;

  /// Initializes the model. Currently empty, but can be used for any necessary setup.
  @override
  void initState(BuildContext context) {}

  /// Cleans up resources when the model is no longer needed.
  /// Currently empty, but can be used for cleanup operations if needed.
  @override
  void dispose() {}
}
