import 'dart:convert';

import 'package:flutter/material.dart';

import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';

import '../../flutter_flow/place.dart';
import '../../flutter_flow/uploaded_file.dart';

/// SERIALIZATION HELPERS

/// Converts a DateTimeRange to a string representation.
/// Format: "startMilliseconds|endMilliseconds"
String dateTimeRangeToString(DateTimeRange dateTimeRange) {
  final startStr = dateTimeRange.start.millisecondsSinceEpoch.toString();
  final endStr = dateTimeRange.end.millisecondsSinceEpoch.toString();
  return '$startStr|$endStr';
}

/// Converts an FFPlace object to a JSON string.
String placeToString(FFPlace place) => jsonEncode({
      'latLng': place.latLng.serialize(),
      'name': place.name,
      'address': place.address,
      'city': place.city,
      'state': place.state,
      'country': place.country,
      'zipCode': place.zipCode,
    });

/// Serializes an FFUploadedFile object.
String uploadedFileToString(FFUploadedFile uploadedFile) =>
    uploadedFile.serialize();

/// Delimiter used for separating document IDs in a reference path.
const _kDocIdDelimeter = '|';

/// Serializes a DocumentReference into a string of document IDs.
String _serializeDocumentReference(DocumentReference ref) {
  final docIds = <String>[];
  DocumentReference? currentRef = ref;
  while (currentRef != null) {
    docIds.add(currentRef.id);
    // Get the parent document (catching any errors that arise).
    currentRef = safeGet<DocumentReference?>(() => currentRef?.parent.parent);
  }
  // Reverse the list to get the correct ordering.
  return docIds.reversed.join(_kDocIdDelimeter);
}

/// Serializes a parameter based on its type.
/// 
/// This function handles various parameter types and converts them to string representations.
/// It also supports serializing lists of parameters.
String? serializeParam(
  dynamic param,
  ParamType paramType, {
  bool isList = false,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final serializedValues = (param as Iterable)
          .map((p) => serializeParam(p, paramType, isList: false))
          .where((p) => p != null)
          .map((p) => p!)
          .toList();
      return json.encode(serializedValues);
    }
    String? data;
    switch (paramType) {
      case ParamType.int:
      case ParamType.double:
      case ParamType.String:
        data = param.toString();
        break;
      case ParamType.bool:
        data = param ? 'true' : 'false';
        break;
      case ParamType.DateTime:
        data = (param as DateTime).millisecondsSinceEpoch.toString();
        break;
      case ParamType.DateTimeRange:
        data = dateTimeRangeToString(param as DateTimeRange);
        break;
      case ParamType.LatLng:
        data = (param as LatLng).serialize();
        break;
      case ParamType.Color:
        data = (param as Color).toCssString();
        break;
      case ParamType.FFPlace:
        data = placeToString(param as FFPlace);
        break;
      case ParamType.FFUploadedFile:
        data = uploadedFileToString(param as FFUploadedFile);
        break;
      case ParamType.JSON:
        data = json.encode(param);
        break;
      case ParamType.DocumentReference:
        data = _serializeDocumentReference(param as DocumentReference);
        break;
      case ParamType.Document:
        final reference = (param as FirestoreRecord).reference;
        data = _serializeDocumentReference(reference);
        break;
      case ParamType.DataStruct:
        data = param is BaseStruct ? param.serialize() : null;
        break;
      case ParamType.Enum:
        data = (param is Enum) ? param.serialize() : null;
        break;
      default:
        data = null;
    }
    return data;
  } catch (e) {
    print('Error serializing parameter: $e');
    return null;
  }
}

/// END SERIALIZATION HELPERS

/// DESERIALIZATION HELPERS

/// Converts a string representation back to a DateTimeRange object.
DateTimeRange? dateTimeRangeFromString(String dateTimeRangeStr) {
  final pieces = dateTimeRangeStr.split('|');
  if (pieces.length != 2) {
    return null;
  }
  return DateTimeRange(
    start: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.first)),
    end: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.last)),
  );
}

/// Converts a string representation back to a LatLng object.
LatLng? latLngFromString(String? latLngStr) {
  final pieces = latLngStr?.split(',');
  if (pieces == null || pieces.length != 2) {
    return null;
  }
  return LatLng(
    double.parse(pieces.first.trim()),
    double.parse(pieces.last.trim()),
  );
}

/// Converts a JSON string back to an FFPlace object.
FFPlace placeFromString(String placeStr) {
  final serializedData = jsonDecode(placeStr) as Map<String, dynamic>;
  final data = {
    'latLng': serializedData.containsKey('latLng')
        ? latLngFromString(serializedData['latLng'] as String)
        : const LatLng(0.0, 0.0),
    'name': serializedData['name'] ?? '',
    'address': serializedData['address'] ?? '',
    'city': serializedData['city'] ?? '',
    'state': serializedData['state'] ?? '',
    'country': serializedData['country'] ?? '',
    'zipCode': serializedData['zipCode'] ?? '',
  };
  return FFPlace(
    latLng: data['latLng'] as LatLng,
    name: data['name'] as String,
    address: data['address'] as String,
    city: data['city'] as String,
    state: data['state'] as String,
    country: data['country'] as String,
    zipCode: data['zipCode'] as String,
  );
}

/// Deserializes a string back to an FFUploadedFile object.
FFUploadedFile uploadedFileFromString(String uploadedFileStr) =>
    FFUploadedFile.deserialize(uploadedFileStr);

/// Deserializes a string representation back to a DocumentReference.
DocumentReference _deserializeDocumentReference(
  String refStr,
  List<String> collectionNamePath,
) {
  var path = '';
  final docIds = refStr.split(_kDocIdDelimeter);
  for (int i = 0; i < docIds.length && i < collectionNamePath.length; i++) {
    path += '/${collectionNamePath[i]}/${docIds[i]}';
  }
  return FirebaseFirestore.instance.doc(path);
}

/// Enum representing different parameter types for serialization/deserialization.
enum ParamType {
  int,
  double,
  String,
  bool,
  DateTime,
  DateTimeRange,
  LatLng,
  Color,
  FFPlace,
  FFUploadedFile,
  JSON,
  Document,
  DocumentReference,
  DataStruct,
  Enum,
}

/// Deserializes a parameter based on its type.
/// 
/// This function handles various parameter types and converts string representations
/// back to their original types. It also supports deserializing lists of parameters.
dynamic deserializeParam<T>(
  String? param,
  ParamType paramType,
  bool isList, {
  List<String>? collectionNamePath,
  StructBuilder<T>? structBuilder,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final paramValues = json.decode(param);
      if (paramValues is! Iterable || paramValues.isEmpty) {
        return null;
      }
      return paramValues
          .whereType<String>()
          .map((p) => p)
          .map((p) => deserializeParam<T>(
                p,
                paramType,
                false,
                collectionNamePath: collectionNamePath,
                structBuilder: structBuilder,
              ))
          .where((p) => p != null)
          .map((p) => p! as T)
          .toList();
    }
    switch (paramType) {
      case ParamType.int:
        return int.tryParse(param);
      case ParamType.double:
        return double.tryParse(param);
      case ParamType.String:
        return param;
      case ParamType.bool:
        return param == 'true';
      case ParamType.DateTime:
        final milliseconds = int.tryParse(param);
        return milliseconds != null
            ? DateTime.fromMillisecondsSinceEpoch(milliseconds)
            : null;
      case ParamType.DateTimeRange:
        return dateTimeRangeFromString(param);
      case ParamType.LatLng:
        return latLngFromString(param);
      case ParamType.Color:
        return fromCssColor(param);
      case ParamType.FFPlace:
        return placeFromString(param);
      case ParamType.FFUploadedFile:
        return uploadedFileFromString(param);
      case ParamType.JSON:
        return json.decode(param);
      case ParamType.DocumentReference:
        return _deserializeDocumentReference(param, collectionNamePath ?? []);
      case ParamType.DataStruct:
        final data = json.decode(param) as Map<String, dynamic>? ?? {};
        return structBuilder != null ? structBuilder(data) : null;
      case ParamType.Enum:
        return deserializeEnum<T>(param);
      default:
        return null;
    }
  } catch (e) {
    print('Error deserializing parameter: $e');
    return null;
  }
}

/// Returns a function that retrieves a document based on its ID.
Future<dynamic> Function(String) getDoc(
  List<String> collectionNamePath,
  RecordBuilder recordBuilder,
) {
  return (String ids) => _deserializeDocumentReference(ids, collectionNamePath)
      .get()
      .then((s) => recordBuilder(s));
}

/// Returns a function that retrieves a list of documents based on their IDs.
Future<List<T>> Function(String) getDocList<T>(
  List<String> collectionNamePath,
  RecordBuilder<T> recordBuilder,
) {
  return (String idsList) {
    List<String> docIds = [];
    try {
      final ids = json.decode(idsList) as Iterable;
      docIds = ids.whereType<String>().map((d) => d).toList();
    } catch (_) {}
    return Future.wait(
      docIds.map(
        (ids) => _deserializeDocumentReference(ids, collectionNamePath)
            .get()
            .then((s) => recordBuilder(s)),
      ),
    ).then((docs) => docs.where((d) => d != null).map((d) => d!).toList());
  };
}
