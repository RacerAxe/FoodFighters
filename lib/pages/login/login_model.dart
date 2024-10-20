import '/flutter_flow/flutter_flow_util.dart';
import 'login_widget.dart' show LoginWidget;
import 'package:flutter/material.dart';

/// Model class for the Login page, extending FlutterFlowModel.
class LoginModel extends FlutterFlowModel<LoginWidget> {
  /// State fields for stateful widgets in this page.

  // Email field state
  FocusNode? emailFieldFocusNode;
  TextEditingController? emailFieldTextController;
  String? Function(BuildContext, String?)? emailFieldTextControllerValidator;

  // Password field state
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
    // Dispose of email field resources
    emailFieldFocusNode?.dispose();
    emailFieldTextController?.dispose();

    // Dispose of password field resources
    passwordFieldFocusNode?.dispose();
    passwordFieldTextController?.dispose();
  }
}
