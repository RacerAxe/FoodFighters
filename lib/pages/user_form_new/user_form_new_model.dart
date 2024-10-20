import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'user_form_new_widget.dart' show UserFormNewWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

/// Model class for the User Form New page, extending FlutterFlowModel.
class UserFormNewModel extends FlutterFlowModel<UserFormNewWidget> {
  /// State fields for stateful widgets in this page.

  // Form key for form validation
  final formKey = GlobalKey<FormState>();

  // State fields for fullName widget
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameTextController;
  String? Function(BuildContext, String?)? fullNameTextControllerValidator;

  /// Validator for the full name field
  String? _fullNameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter the patient\'s full name.';
    }
    return null;
  }

  // State fields for Height widget
  FocusNode? heightFocusNode;
  TextEditingController? heightTextController;
  String? Function(BuildContext, String?)? heightTextControllerValidator;

  /// Validator for the height field
  String? _heightTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter the patient\'s height.';
    }
    return null;
  }

  // State fields for weight widget
  FocusNode? weightFocusNode;
  TextEditingController? weightTextController;
  String? Function(BuildContext, String?)? weightTextControllerValidator;

  /// Validator for the weight field
  String? _weightTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter the patient\'s weight.';
    }
    return null;
  }

  // State fields for dateOfBirth widget
  FocusNode? dateOfBirthFocusNode;
  TextEditingController? dateOfBirthTextController;
  final dateOfBirthMask = MaskTextInputFormatter(mask: '##/##/####');
  String? Function(BuildContext, String?)? dateOfBirthTextControllerValidator;

  /// Validator for the date of birth field
  String? _dateOfBirthTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter the patient\'s date of birth.';
    }
    return null;
  }

  // State fields for GenderDropDown widget
  String? genderDropDownValue;
  FormFieldController<String>? genderDropDownValueController;

  // State fields for ActivityLevelDropDown widget
  String? activityLevelDropDownValue;
  FormFieldController<String>? activityLevelDropDownValueController;

  // State fields for FoodPreferenceDropDown widget
  String? foodPreferenceDropDownValue;
  FormFieldController<String>? foodPreferenceDropDownValueController;

  // State fields for AllergyDropDown widget
  String? allergyDropDownValue;
  FormFieldController<String>? allergyDropDownValueController;

  // State fields for FitnessGoalDropDown widget
  String? fitnessGoalDropDownValue;
  FormFieldController<String>? fitnessGoalDropDownValueController;

  /// Initialize the model
  @override
  void initState(BuildContext context) {
    // Set up validators for text fields
    fullNameTextControllerValidator = _fullNameTextControllerValidator;
    heightTextControllerValidator = _heightTextControllerValidator;
    weightTextControllerValidator = _weightTextControllerValidator;
    dateOfBirthTextControllerValidator = _dateOfBirthTextControllerValidator;
  }

  /// Clean up the model when it's no longer needed
  @override
  void dispose() {
    // Dispose of focus nodes and text controllers to prevent memory leaks
    fullNameFocusNode?.dispose();
    fullNameTextController?.dispose();

    heightFocusNode?.dispose();
    heightTextController?.dispose();

    weightFocusNode?.dispose();
    weightTextController?.dispose();

    dateOfBirthFocusNode?.dispose();
    dateOfBirthTextController?.dispose();
  }
}
