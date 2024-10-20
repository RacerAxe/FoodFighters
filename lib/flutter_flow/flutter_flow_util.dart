import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:from_css_color/from_css_color.dart';
import 'dart:math' show pow, pi, sin;
import 'package:intl/intl.dart';
import 'package:json_path/json_path.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

// Export commonly used utilities and models
export 'lat_lng.dart';
export 'place.dart';
export 'uploaded_file.dart';
export 'flutter_flow_model.dart';
export 'dart:math' show min, max;
export 'dart:typed_data' show Uint8List;
export 'dart:convert' show jsonEncode, jsonDecode;
export 'package:intl/intl.dart';
export 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, FirebaseFirestore;
export 'package:page_transition/page_transition.dart';
export 'nav/nav.dart';

/// Returns the value if it's not null or empty, otherwise returns the default value.
T valueOrDefault<T>(T? value, T defaultValue) =>
    (value is String && value.isEmpty) || value == null ? defaultValue : value;

/// Formats a DateTime object according to the specified format and locale.
String dateTimeFormat(String format, DateTime? dateTime, {String? locale}) {
  if (dateTime == null) {
    return '';
  }
  if (format == 'relative') {
    return timeago.format(dateTime, locale: locale, allowFromNow: true);
  }
  return DateFormat(format, locale).format(dateTime);
}

/// Launches a URL in the default browser.
Future launchURL(String url) async {
  var uri = Uri.parse(url);
  try {
    await launchUrl(uri);
  } catch (e) {
    throw 'Could not launch $uri: $e';
  }
}

/// Converts a CSS color string to a Color object.
Color colorFromCssString(String color, {Color? defaultColor}) {
  try {
    return fromCssColor(color);
  } catch (_) {}
  return defaultColor ?? Colors.black;
}

/// Enum for different number formatting types.
enum FormatType {
  decimal,
  percent,
  scientific,
  compact,
  compactLong,
  custom,
}

/// Enum for decimal separator types.
enum DecimalType {
  automatic,
  periodDecimal,
  commaDecimal,
}

/// Formats a number according to the specified format type and options.
String formatNumber(
  num? value, {
  required FormatType formatType,
  DecimalType? decimalType,
  String? currency,
  bool toLowerCase = false,
  String? format,
  String? locale,
}) {
  if (value == null) {
    return '';
  }
  var formattedValue = '';
  switch (formatType) {
    case FormatType.decimal:
      switch (decimalType!) {
        case DecimalType.automatic:
          formattedValue = NumberFormat.decimalPattern().format(value);
          break;
        case DecimalType.periodDecimal:
          if (currency != null) {
            formattedValue = NumberFormat('#,##0.00', 'en_US').format(value);
          } else {
            formattedValue = NumberFormat.decimalPattern('en_US').format(value);
          }
          break;
        case DecimalType.commaDecimal:
          if (currency != null) {
            formattedValue = NumberFormat('#,##0.00', 'es_PA').format(value);
          } else {
            formattedValue = NumberFormat.decimalPattern('es_PA').format(value);
          }
          break;
      }
      break;
    case FormatType.percent:
      formattedValue = NumberFormat.percentPattern().format(value);
      break;
    case FormatType.scientific:
      formattedValue = NumberFormat.scientificPattern().format(value);
      if (toLowerCase) {
        formattedValue = formattedValue.toLowerCase();
      }
      break;
    case FormatType.compact:
      formattedValue = NumberFormat.compact().format(value);
      break;
    case FormatType.compactLong:
      formattedValue = NumberFormat.compactLong().format(value);
      break;
    case FormatType.custom:
      final hasLocale = locale != null && locale.isNotEmpty;
      formattedValue =
          NumberFormat(format, hasLocale ? locale : null).format(value);
  }

  if (formattedValue.isEmpty) {
    return value.toString();
  }

  if (currency != null) {
    final currencySymbol = currency.isNotEmpty
        ? currency
        : NumberFormat.simpleCurrency().format(0.0).substring(0, 1);
    formattedValue = '$currencySymbol$formattedValue';
  }

  return formattedValue;
}

/// Returns the current timestamp.
DateTime get getCurrentTimestamp => DateTime.now();

/// Converts seconds since epoch to DateTime.
DateTime dateTimeFromSecondsSinceEpoch(int seconds) {
  return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
}

/// Extension to convert DateTime to seconds since epoch.
extension DateTimeConversionExtension on DateTime {
  int get secondsSinceEpoch => (millisecondsSinceEpoch / 1000).round();
}

/// Extension to add comparison operators to DateTime.
extension DateTimeComparisonOperators on DateTime {
  bool operator <(DateTime other) => isBefore(other);
  bool operator >(DateTime other) => isAfter(other);
  bool operator <=(DateTime other) => this < other || isAtSameMomentAs(other);
  bool operator >=(DateTime other) => this > other || isAtSameMomentAs(other);
}

/// Casts a dynamic value to the specified type T.
T? castToType<T>(dynamic value) {
  if (value == null) {
    return null;
  }
  switch (T) {
    case double:
      // Doubles may be stored as ints in some cases.
      return value.toDouble() as T;
    case int:
      // Likewise, ints may be stored as doubles. If this is the case
      // (i.e. no decimal value), return the value as an int.
      if (value is num && value.toInt() == value) {
        return value.toInt() as T;
      }
      break;
    default:
      break;
  }
  return value as T;
}

/// Retrieves a value from a JSON response using a JSON path.
dynamic getJsonField(
  dynamic response,
  String jsonPath, [
  bool isForList = false,
]) {
  final field = JsonPath(jsonPath).read(response);
  if (field.isEmpty) {
    return null;
  }
  if (field.length > 1) {
    return field.map((f) => f.value).toList();
  }
  final value = field.first.value;
  if (isForList) {
    return value is! Iterable
        ? [value]
        : (value is List ? value : value.toList());
  }
  return value;
}

/// Gets the bounding box of a widget.
Rect? getWidgetBoundingBox(BuildContext context) {
  try {
    final renderBox = context.findRenderObject() as RenderBox?;
    return renderBox!.localToGlobal(Offset.zero) & renderBox.size;
  } catch (_) {
    return null;
  }
}

/// Platform checks
bool get isAndroid => !kIsWeb && Platform.isAndroid;
bool get isiOS => !kIsWeb && Platform.isIOS;
bool get isWeb => kIsWeb;

/// Breakpoint constants
const kBreakpointSmall = 479.0;
const kBreakpointMedium = 767.0;
const kBreakpointLarge = 991.0;

/// Checks if the current width is considered mobile.
bool isMobileWidth(BuildContext context) =>
    MediaQuery.sizeOf(context).width < kBreakpointSmall;

/// Determines visibility based on screen size.
bool responsiveVisibility({
  required BuildContext context,
  bool phone = true,
  bool tablet = true,
  bool tabletLandscape = true,
  bool desktop = true,
}) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < kBreakpointSmall) {
    return phone;
  } else if (width < kBreakpointMedium) {
    return tablet;
  } else if (width < kBreakpointLarge) {
    return tabletLandscape;
  } else {
    return desktop;
  }
}

/// Regular expressions for various text validations
const kTextValidatorUsernameRegex = r'^[a-zA-Z][a-zA-Z0-9_-]{2,16}$';
const kTextValidatorEmailRegex =
    "^(?:[a-zA-Z0-9!#\$%&\'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#\$%&\'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])\$";
const kTextValidatorWebsiteRegex =
    r'(https?:\/\/)?(www\.)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,10}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)|(https?:\/\/)?(www\.)?(?!ww)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,10}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)';

/// Extension for TextEditingController to handle null cases
extension FFTextEditingControllerExt on TextEditingController? {
  String get text => this == null ? '' : this!.text;
  set text(String newText) => this?.text = newText;
}

/// Extension for Iterable to add sorting functionality
extension IterableExt<T> on Iterable<T> {
  List<T> sortedList<S extends Comparable>(
      {S Function(T)? keyOf, bool desc = false}) {
    final sortedAscending = toList()
      ..sort(keyOf == null ? null : ((a, b) => keyOf(a).compareTo(keyOf(b))));
    if (desc) {
      return sortedAscending.reversed.toList();
    }
    return sortedAscending;
  }

  List<S> mapIndexed<S>(S Function(int, T) func) => toList()
      .asMap()
      .map((index, value) => MapEntry(index, func(index, value)))
      .values
      .toList();
}

/// Extension to convert a string to a DocumentReference
extension StringDocRef on String {
  DocumentReference get ref => FirebaseFirestore.instance.doc(this);
}

/// Sets the dark mode setting for the app
void setDarkModeSetting(BuildContext context, ThemeMode themeMode) =>
    MyApp.of(context).setThemeMode(themeMode);

/// Shows a snackbar with an optional loading indicator
void showSnackbar(
  BuildContext context,
  String message, {
  bool loading = false,
  int duration = 4,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (loading)
            const Padding(
              padding: EdgeInsetsDirectional.only(end: 10.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          Text(message),
        ],
      ),
      duration: Duration(seconds: duration),
    ),
  );
}

/// Extension for String to handle overflow
extension FFStringExt on String {
  String maybeHandleOverflow({int? maxChars, String replacement = ''}) =>
      maxChars != null && length > maxChars
          ? replaceRange(maxChars, null, replacement)
          : this;
}

/// Extension to filter out null values from a list
extension ListFilterExt<T> on Iterable<T?> {
  List<T> get withoutNulls => where((s) => s != null).map((e) => e!).toList();
}

/// Extension to filter out null values from a map
extension MapFilterExtensions<T> on Map<String, T?> {
  Map<String, T> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value as T)),
      );
}

/// Extension to check if a list contains a map
extension MapListContainsExt on List<dynamic> {
  bool containsMap(dynamic map) => map is Map
      ? any((e) => e is Map && const DeepCollectionEquality().equals(e, map))
      : contains(map);
}

/// Extension to add dividers and padding to a list of widgets
extension ListDivideExt<T extends Widget> on Iterable<T> {
  Iterable<MapEntry<int, Widget>> get enumerate => toList().asMap().entries;

  List<Widget> divide(Widget t, {bool Function(int)? filterFn}) => isEmpty
      ? []
      : (enumerate
          .map((e) => [e.value, if (filterFn == null || filterFn(e.key)) t])
          .expand((i) => i)
          .toList()
        ..removeLast());

  List<Widget> around(Widget t) => addToStart(t).addToEnd(t);

  List<Widget> addToStart(Widget t) =>
      enumerate.map((e) => e.value).toList()..insert(0, t);

  List<Widget> addToEnd(Widget t) =>
      enumerate.map((e) => e.value).toList()..add(t);

  List<Padding> paddingTopEach(double val) =>
      map((w) => Padding(padding: EdgeInsets.only(top: val), child: w))
          .toList();
}

/// Extension for StatefulWidget to safely set state
extension StatefulWidgetExtensions on State<StatefulWidget> {
  /// Check if the widget exists before safely setting state.
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(fn);
    }
  }
}

/// Fixes the status bar color on iOS 16 and below
Brightness? _lastBrightness;
void fixStatusBarOniOS16AndBelow(BuildContext context) {
  if (!isiOS) {
    return;
  }
  final brightness = Theme.of(context).brightness;
  if (_lastBrightness != brightness) {
    _lastBrightness = brightness;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: brightness,
        systemStatusBarContrastEnforced: true,
      ),
    );
  }
}

/// Extension to get unique elements from a list based on a key
extension ListUniqueExt<T> on Iterable<T> {
  List<T> unique(dynamic Function(T) getKey) {
    var distinctSet = <dynamic>{};
    var distinctList = <T>[];
    for (var item in this) {
      if (distinctSet.add(getKey(item))) {
        distinctList.add(item);
      }
    }
    return distinctList;
  }
}

/// Rounds a double to a specified number of decimal points
String roundTo(double value, int decimalPoints) {
  final power = pow(10, decimalPoints);
  return ((value * power).round() / power).toString();
}

/// Computes the X alignment for a gradient based on an angle
double computeGradientAlignmentX(double evaluatedAngle) {
  evaluatedAngle %= 360;
  final rads = evaluatedAngle * pi / 180;
  double x;
  if (evaluatedAngle < 45 || evaluatedAngle > 315) {
    x = sin(2 * rads);
  } else if (45 <= evaluatedAngle && evaluatedAngle <= 135) {
    x = 1;
  } else if (135 <= evaluatedAngle && evaluatedAngle <= 225) {
    x = sin(-2 * rads);
  } else {
    x = -1;
  }
  return double.parse(roundTo(x, 2));
}

/// Computes the Y alignment for a gradient based on an angle
double computeGradientAlignmentY(double evaluatedAngle) {
  evaluatedAngle %= 360;
  final rads = evaluatedAngle * pi / 180;
  double y;
  if (evaluatedAngle < 45 || evaluatedAngle > 315) {
    y = -1;
  } else if (45 <= evaluatedAngle && evaluatedAngle <= 135) {
    y = sin(-2 * rads);
  } else if (135 <= evaluatedAngle && evaluatedAngle <= 225) {
    y = 1;
  } else {
    y = sin(2 * rads);
  }
  return double.parse(roundTo(y, 2));
}
