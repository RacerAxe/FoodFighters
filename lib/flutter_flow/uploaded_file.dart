import 'dart:convert';
import 'dart:typed_data' show Uint8List;

/// Represents an uploaded file with associated metadata.
class FFUploadedFile {
  /// Creates a new [FFUploadedFile] instance.
  ///
  /// All parameters are optional.
  /// - [name]: The name of the uploaded file.
  /// - [bytes]: The binary data of the file.
  /// - [height]: The height of the image, if applicable.
  /// - [width]: The width of the image, if applicable.
  /// - [blurHash]: The BlurHash string for the image, if available.
  const FFUploadedFile({
    this.name,
    this.bytes,
    this.height,
    this.width,
    this.blurHash,
  });

  /// The name of the uploaded file.
  final String? name;

  /// The binary data of the file.
  final Uint8List? bytes;

  /// The height of the image, if applicable.
  final double? height;

  /// The width of the image, if applicable.
  final double? width;

  /// The BlurHash string for the image, if available.
  final String? blurHash;

  /// Returns a string representation of the [FFUploadedFile] instance.
  @override
  String toString() => 'FFUploadedFile('
      'name: $name, '
      'bytes: ${bytes?.length ?? 0}, '
      'height: $height, '
      'width: $width, '
      'blurHash: $blurHash,)';

  /// Serializes the [FFUploadedFile] instance to a JSON string.
  ///
  /// This method converts the object's properties into a JSON-encoded string.
  String serialize() => jsonEncode({
        'name': name,
        'bytes': bytes,
        'height': height,
        'width': width,
        'blurHash': blurHash,
      });

  /// Deserializes a JSON string to create an [FFUploadedFile] instance.
  ///
  /// [val] is the JSON string to deserialize.
  ///
  /// Returns a new [FFUploadedFile] instance with properties populated from the JSON data.
  static FFUploadedFile deserialize(String val) {
    final serializedData = jsonDecode(val) as Map<String, dynamic>;
    return FFUploadedFile(
      name: serializedData['name'] as String? ?? '',
      bytes: serializedData['bytes'] != null
          ? Uint8List.fromList((serializedData['bytes'] as List).cast<int>())
          : null,
      height: serializedData['height'] as double?,
      width: serializedData['width'] as double?,
      blurHash: serializedData['blurHash'] as String?,
    );
  }

  /// Generates a hash code for this [FFUploadedFile] instance.
  ///
  /// The hash code is based on all properties of the instance.
  @override
  int get hashCode => Object.hash(
        name,
        bytes,
        height,
        width,
        blurHash,
      );

  /// Compares this [FFUploadedFile] instance with another object for equality.
  ///
  /// Two [FFUploadedFile] instances are considered equal if all their properties match.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FFUploadedFile &&
          name == other.name &&
          bytes == other.bytes &&
          height == other.height &&
          width == other.width &&
          blurHash == other.blurHash;
}
