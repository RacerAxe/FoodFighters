import 'lat_lng.dart';

/// Represents a place with geographical and address information.
///
/// This class encapsulates various details about a location, including its
/// coordinates, name, and address components.
class FFPlace {
  /// Creates a new [FFPlace] instance.
  ///
  /// All parameters are optional and have default values.
  /// 
  /// - [latLng]: The geographical coordinates of the place. Defaults to (0.0, 0.0).
  /// - [name]: The name of the place. Defaults to an empty string.
  /// - [address]: The street address of the place. Defaults to an empty string.
  /// - [city]: The city where the place is located. Defaults to an empty string.
  /// - [state]: The state or province where the place is located. Defaults to an empty string.
  /// - [country]: The country where the place is located. Defaults to an empty string.
  /// - [zipCode]: The postal or zip code of the place. Defaults to an empty string.
  const FFPlace({
    this.latLng = const LatLng(0.0, 0.0),
    this.name = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.zipCode = '',
  });

  /// The geographical coordinates of the place.
  final LatLng latLng;

  /// The name of the place.
  final String name;

  /// The street address of the place.
  final String address;

  /// The city where the place is located.
  final String city;

  /// The state or province where the place is located.
  final String state;

  /// The country where the place is located.
  final String country;

  /// The postal or zip code of the place.
  final String zipCode;

  /// Returns a string representation of the [FFPlace] instance.
  ///
  /// This method provides a formatted multi-line string containing all the
  /// properties of the place.
  @override
  String toString() => '''FFPlace(
        latLng: $latLng,
        name: $name,
        address: $address,
        city: $city,
        state: $state,
        country: $country,
        zipCode: $zipCode,
      )''';

  /// Generates a hash code for this [FFPlace] instance.
  ///
  /// The hash code is based on the [latLng] property, which is considered
  /// the unique identifier for a place.
  @override
  int get hashCode => latLng.hashCode;

  /// Compares this [FFPlace] instance with another object for equality.
  ///
  /// Two [FFPlace] instances are considered equal if all their properties match.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FFPlace &&
          runtimeType == other.runtimeType &&
          latLng == other.latLng &&
          name == other.name &&
          address == other.address &&
          city == other.city &&
          state == other.state &&
          country == other.country &&
          zipCode == other.zipCode;
}
