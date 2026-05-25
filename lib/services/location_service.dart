import 'package:logger/logger.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  final Logger _logger = Logger();

  // Calculate distance between two coordinates using Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    try {
      final latLng1 = LatLng(lat1, lon1);
      final latLng2 = LatLng(lat2, lon2);
      final distance = const Distance().as(
        LengthUnit.Kilometer,
        latLng1,
        latLng2,
      );
      _logger.i('Distance calculated: ${distance.toStringAsFixed(2)} km');
      return distance;
    } catch (e) {
      _logger.e('Calculate distance error: $e');
      return 0.0;
    }
  }

  // Get all locations within a radius
  List<Map<String, dynamic>> getLocationsWithinRadius({
    required double centerLat,
    required double centerLon,
    required double radiusInKm,
    required List<Map<String, dynamic>> locations,
  }) {
    try {
      final withinRadius = <Map<String, dynamic>>[];
      for (var location in locations) {
        final distance = calculateDistance(
          centerLat,
          centerLon,
          location['latitude'] as double,
          location['longitude'] as double,
        );
        if (distance <= radiusInKm) {
          withinRadius.add({...location, 'distance': distance});
        }
      }
      _logger.i('Found ${withinRadius.length} locations within $radiusInKm km');
      return withinRadius;
    } catch (e) {
      _logger.e('Get locations within radius error: $e');
      return [];
    }
  }

  // Sort locations by distance
  List<Map<String, dynamic>> sortByDistance(
    double centerLat,
    double centerLon,
    List<Map<String, dynamic>> locations,
  ) {
    try {
      final sorted =
          locations.map((location) {
            final distance = calculateDistance(
              centerLat,
              centerLon,
              location['latitude'] as double,
              location['longitude'] as double,
            );
            return {...location, 'distance': distance};
          }).toList()..sort(
            (a, b) =>
                (a['distance'] as double).compareTo(b['distance'] as double),
          );
      _logger.i('Locations sorted by distance');
      return sorted;
    } catch (e) {
      _logger.e('Sort by distance error: $e');
      return locations;
    }
  }

  // Validate coordinates
  bool validateCoordinates(double latitude, double longitude) {
    try {
      if (latitude >= -90 &&
          latitude <= 90 &&
          longitude >= -180 &&
          longitude <= 180) {
        _logger.i('Coordinates valid: $latitude, $longitude');
        return true;
      }
      _logger.w('Invalid coordinates: $latitude, $longitude');
      return false;
    } catch (e) {
      _logger.e('Validate coordinates error: $e');
      return false;
    }
  }

  // Format address from coordinates (reverse geocoding would be needed in production)
  String formatLocation(String? address, double? latitude, double? longitude) {
    if (address != null && address.isNotEmpty) {
      return address;
    }
    if (latitude != null && longitude != null) {
      return '$latitude, $longitude';
    }
    return 'Location not available';
  }

  // Determine location category based on distance from city center
  String getLocationCategory(double distance, {double cityRadius = 25}) {
    if (distance <= 5) {
      return 'In-city';
    } else if (distance <= cityRadius) {
      return 'Near-city';
    } else {
      return 'Outskirts';
    }
  }
}
