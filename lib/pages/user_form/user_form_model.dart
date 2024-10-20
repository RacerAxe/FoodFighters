import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'user_form_widget.dart' show UserFormWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

/// Model class for the User Form page, extending FlutterFlowModel.
class UserFormModel extends FlutterFlowModel<UserFormWidget> {
  /// Local state fields for this page.
  double? heightState;
  double? weightState;
  String? dobState;
  String? genderState;
  String? exerciseState;
  String? foodPrefState;
  String? foodAllergyState;
  String? fitnessGoalState;

  /// State fields for stateful widgets in this page.

  // Form key for form validation
  final formKey = GlobalKey<FormState>();

  // Stores action output result for [Firestore Query - Query a collection] action in User_Form widget.
  UserPrefRecord? userPrefDoc;

  // State fields for fullName widget
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameTextController;
  String? Function(BuildContext, String?)? fullNameTextControllerValidator;

  /// Validator for the full name field
  String? _fullNameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter the patients full name.';
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
      return 'Please enter the height of the user.';
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
      return 'Please enter the weight for the user';
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
      return 'Please enter the date of birth of the user.';
    }
    if (val.length < 10) {
      return 'Please enter a valid date of birth (MM/DD/YYYY).';
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

  /// Initialize the model.
  @override
  void initState(BuildContext context) {
    fullNameTextControllerValidator = _fullNameTextControllerValidator;
    heightTextControllerValidator = _heightTextControllerValidator;
    weightTextControllerValidator = _weightTextControllerValidator;
    dateOfBirthTextControllerValidator = _dateOfBirthTextControllerValidator;
  }

  /// Dispose of the model resources.
  @override
  void dispose() {
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
