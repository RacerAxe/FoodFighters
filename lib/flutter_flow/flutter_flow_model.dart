import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

/// Wraps a widget with a FlutterFlowModel and provides it to the widget tree.
///
/// [T] is the type of FlutterFlowModel to be used.
/// [model] is the instance of the FlutterFlowModel.
/// [child] is the widget to be wrapped.
/// [updateCallback] is called when the model updates.
/// [updateOnChange] determines if the page should update on model changes.
Widget wrapWithModel<T extends FlutterFlowModel>({
  required T model,
  required Widget child,
  required VoidCallback updateCallback,
  bool updateOnChange = false,
}) {
  // Configure the model's update behavior
  model.setOnUpdate(
    onUpdate: updateCallback,
    updateOnChange: updateOnChange,
  );
  // Prevent premature disposal of component models
  model.disposeOnWidgetDisposal = false;
  // Provide the model to the widget tree
  return Provider<T>.value(
    value: model,
    child: child,
  );
}

/// Creates and initializes a FlutterFlowModel for a given context.
///
/// [T] is the type of FlutterFlowModel to be created.
/// [context] is the BuildContext where the model will be used.
/// [defaultBuilder] is a function that creates a new instance of the model.
T createModel<T extends FlutterFlowModel>(
  BuildContext context,
  T Function() defaultBuilder,
) {
  final model = context.read<T?>() ?? defaultBuilder();
  model._init(context);
  return model;
}

/// Abstract base class for FlutterFlow models.
abstract class FlutterFlowModel<W extends Widget> {
  bool _isInitialized = false;
  W? _widget;
  BuildContext? _context;
  bool disposeOnWidgetDisposal = true;
  bool updateOnChange = false;
  VoidCallback _updateCallback = () {};

  /// Initialize the model's state.
  void initState(BuildContext context);

  /// Internal initialization method.
  void _init(BuildContext context) {
    if (!_isInitialized) {
      initState(context);
      _isInitialized = true;
    }
    if (context.widget is W) _widget = context.widget as W;
    _context = context;
  }

  /// The widget associated with this model.
  W? get widget => _widget;

  /// The context associated with this model.
  BuildContext? get context => _context;

  /// Dispose of the model's resources.
  void dispose();

  /// Conditionally dispose of the model based on [disposeOnWidgetDisposal].
  void maybeDispose() {
    if (disposeOnWidgetDisposal) {
      dispose();
    }
    _widget = null;
  }

  /// Trigger an update if [updateOnChange] is true.
  void onUpdate() => updateOnChange ? _updateCallback() : () {};

  /// Configure the model's update behavior.
  FlutterFlowModel setOnUpdate({
    bool updateOnChange = false,
    required VoidCallback onUpdate,
  }) =>
      this
        .._updateCallback = onUpdate
        ..updateOnChange = updateOnChange;

  /// Update the page and trigger the update callback.
  void updatePage(VoidCallback callback) {
    callback();
    _updateCallback();
  }
}

/// Manages dynamic models for FlutterFlow widgets.
class FlutterFlowDynamicModels<T extends FlutterFlowModel> {
  FlutterFlowDynamicModels(this.defaultBuilder);

  final T Function() defaultBuilder;
  final Map<String, T> _childrenModels = {};
  final Map<String, int> _childrenIndexes = {};
  Set<String>? _activeKeys;

  /// Get or create a model for a given key and index.
  T getModel(String uniqueKey, int index) {
    _updateActiveKeys(uniqueKey);
    _childrenIndexes[uniqueKey] = index;
    return _childrenModels[uniqueKey] ??= defaultBuilder();
  }

  /// Get values from all models, sorted by index.
  List<S> getValues<S>(S? Function(T) getValue) {
    return _childrenIndexes.entries
        .sorted((a, b) => a.value.compareTo(b.value))
        .where((e) => _childrenModels[e.key] != null)
        .map((e) => getValue(_childrenModels[e.key]!) ?? _getDefaultValue<S>()!)
        .toList();
  }

  /// Get a value from the model at a specific index.
  S? getValueAtIndex<S>(int index, S? Function(T) getValue) {
    final uniqueKey =
        _childrenIndexes.entries.firstWhereOrNull((e) => e.value == index)?.key;
    return getValueForKey(uniqueKey, getValue);
  }

  /// Get a value from the model with a specific key.
  S? getValueForKey<S>(String? uniqueKey, S? Function(T) getValue) {
    final model = _childrenModels[uniqueKey];
    return model != null ? getValue(model) : null;
  }

  /// Dispose of all child models.
  void dispose() => _childrenModels.values.forEach((model) => model.dispose());

  /// Update the set of active keys and schedule cleanup of unused models.
  void _updateActiveKeys(String uniqueKey) {
    final shouldResetActiveKeys = _activeKeys == null;
    _activeKeys ??= {};
    _activeKeys!.add(uniqueKey);

    if (shouldResetActiveKeys) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _childrenIndexes.removeWhere((k, _) => !_activeKeys!.contains(k));
        _childrenModels.keys
            .toSet()
            .difference(_activeKeys!)
            .forEach((k) => _childrenModels.remove(k)?.maybeDispose());
        _activeKeys = null;
      });
    }
  }
}

/// Get a default value for a given type.
T? _getDefaultValue<T>() {
  switch (T) {
    case int:
      return 0 as T;
    case double:
      return 0.0 as T;
    case String:
      return '' as T;
    case bool:
      return false as T;
    default:
      return null as T;
  }
}

/// Extension to convert a text validation function to a simpler form.
extension TextValidationExtensions on String? Function(BuildContext, String?)? {
  String? Function(String?)? asValidator(BuildContext context) =>
      this != null ? (val) => this!(context, val) : null;
}
