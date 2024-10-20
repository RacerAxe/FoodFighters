import '/flutter_flow/flutter_flow_util.dart';
import 'registeration_widget.dart' show RegisterationWidget;
import 'package:flutter/material.dart';

/// Model class for the Registration page, extending FlutterFlowModel.
class RegisterationModel extends FlutterFlowModel<RegisterationWidget> {
  /// State fields for stateful widgets in this page.

  // Display Name Field
  FocusNode? displayNameFieldFocusNode;
  TextEditingController? displayNameFieldTextController;
  String? Function(BuildContext, String?)? displayNameFieldTextControllerValidator;

  // Email Field
  FocusNode? emailFieldFocusNode;
  TextEditingController? emailFieldTextController;
  String? Function(BuildContext, String?)? emailFieldTextControllerValidator;

  // Password Field
  FocusNode? passwordFieldFocusNode;
  TextEditingController? passwordFieldTextController;
  late bool passwordFieldVisibility;
  String? Function(BuildContext, String?)? passwordFieldTextControllerValidator;

  /// Initialize the model.
  @override
  void initState(BuildContext context) {
    passwordFieldVisibility = false;
  }

  /// Dispose of the model resources.
  @override
  void dispose() {
    // Dispose of focus nodes and text controllers
    displayNameFieldFocusNode?.dispose();
    displayNameFieldTextController?.dispose();

    emailFieldFocusNode?.dispose();
    emailFieldTextController?.dispose();

    passwordFieldFocusNode?.dispose();
    passwordFieldTextController?.dispose();
  }
}
