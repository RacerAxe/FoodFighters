import '/flutter_flow/flutter_flow_util.dart';
import 'enter_ingredients_widget.dart' show EnterIngredientsWidget;
import 'package:flutter/material.dart';

/// Model class for the EnterIngredients page, extending FlutterFlowModel.
class EnterIngredientsModel extends FlutterFlowModel<EnterIngredientsWidget> {
  /// State fields for stateful widgets in this page.

  // PrepTime widget state
  FocusNode? prepTimeFocusNode;
  TextEditingController? prepTimeTextController;
  String? Function(BuildContext, String?)? prepTimeTextControllerValidator;

  // CookTime widget state
  FocusNode? cookTimeFocusNode;
  TextEditingController? cookTimeTextController;
  String? Function(BuildContext, String?)? cookTimeTextControllerValidator;

  // File upload state
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // InputIngredients widget state
  FocusNode? inputIngredientsFocusNode;
  TextEditingController? inputIngredientsTextController;
  String? Function(BuildContext, String?)?
      inputIngredientsTextControllerValidator;

  // Action output results
  String? recipeDataStr; // Stores result from [Gemini - Text From Image] action
  String? outputIMG; // Stores result from [Custom Action - generateImage] action

  @override
  void initState(BuildContext context) {
    // Initialize any necessary state here
  }

  @override
  void dispose() {
    // Dispose of focus nodes and text controllers
    prepTimeFocusNode?.dispose();
    prepTimeTextController?.dispose();

    cookTimeFocusNode?.dispose();
    cookTimeTextController?.dispose();

    inputIngredientsFocusNode?.dispose();
    inputIngredientsTextController?.dispose();
  }
}
