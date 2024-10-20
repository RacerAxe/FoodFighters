import '/flutter_flow/flutter_flow_util.dart';
import 'forgot_password_widget.dart' show ForgotPasswordWidget;
import 'package:flutter/material.dart';

/// Model class for the ForgotPassword page, extending FlutterFlowModel.
class ForgotPasswordModel extends FlutterFlowModel<ForgotPasswordWidget> {
  /// State fields for stateful widgets in this page.

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  
  /// Validator function for the email address text field.
  /// Returns an error message string if validation fails, otherwise null.
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;

  /// Initializes the model.
  /// This method is called when the widget is inserted into the widget tree.
  @override
  void initState(BuildContext context) {
    // Add any necessary initialization logic here
  }

  /// Disposes of resources used by the model.
  /// This method is called when the widget is removed from the widget tree.
  @override
  void dispose() {
    // Dispose of focus nodes and text controllers to prevent memory leaks
    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();
  }
}
