/// Represents a geographical point on Earth using latitude and longitude coordinates.
class LatLng {
  /// Creates a new [LatLng] instance with the given [latitude] and [longitude].
  const LatLng(this.latitude, this.longitude);

  /// The latitude coordinate in degrees.
  final double latitude;

  /// The longitude coordinate in degrees.
  final double longitude;

  @override
  String toString() => 'LatLng(lat: $latitude, lng: $longitude)';

  /// Serializes the [LatLng] instance to a string representation.
  ///
  /// Returns a string in the format "latitude,longitude".
  String serialize() => '$latitude,$longitude';

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLng &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;
}
