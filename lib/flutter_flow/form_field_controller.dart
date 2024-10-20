import 'package:flutter/foundation.dart';

/// A controller for managing form field values.
///
/// This class extends [ValueNotifier] to provide a way to manage and notify
/// listeners about changes to a form field's value.
class FormFieldController<T> extends ValueNotifier<T?> {
  /// Creates a [FormFieldController] with an initial value.
  ///
  /// The [initialValue] is used to set the initial state and for resetting.
  FormFieldController(this.initialValue) : super(initialValue);

  /// The initial value of the form field.
  final T? initialValue;

  /// Resets the form field to its initial value.
  void reset() => value = initialValue;

  /// Notifies listeners that the value has been updated.
  void update() => notifyListeners();
}

/// A specialized controller for form fields that use lists.
///
/// This controller is designed to handle lists in form fields, particularly
/// for multiselect scenarios, to avoid pass-by-reference issues that could
/// unintentionally modify the initial value.
class FormListFieldController<T> extends FormFieldController<List<T>> {
  /// Creates a [FormListFieldController] with an initial list value.
  ///
  /// The [initialValue] is copied to avoid direct reference to the original list.
  FormListFieldController(super.initialValue)
      : _initialListValue = List<T>.from(initialValue ?? []);

  /// A private copy of the initial list value.
  final List<T>? _initialListValue;

  @override
  /// Resets the form field to a new copy of its initial list value.
  ///
  /// This ensures that the reset value is not affected by any modifications
  /// made to the current value.
  void reset() => value = List<T>.from(_initialListValue ?? []);
}
