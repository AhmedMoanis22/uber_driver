import 'dart:convert';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class DirectionsService {
  // TODO: Add your Google Maps API key here
  // Get it from: https://console.cloud.google.com/google/maps-apis
  static const String _googleMapsApiKey =
      'AIzaSyAIFlrQoGJvEdkOt2kMvGuTqWO1I-C1MwM';

  final PolylinePoints _polylinePoints = PolylinePoints();

  /// Fetches route from Google Directions API
  /// Returns DirectionsResult with polyline points and route info
  Future<DirectionsResult?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${origin.latitude},${origin.longitude}'
          '&destination=${destination.latitude},${destination.longitude}'
          '&key=$_googleMapsApiKey'
          '&mode=driving';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final polylineString = route['overview_polyline']['points'];

          // Decode polyline
          List<PointLatLng> decodedPoints =
              _polylinePoints.decodePolyline(polylineString);

          // Convert to LatLng
          List<LatLng> polylineCoordinates = decodedPoints
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          // Extract route info
          final leg = route['legs'][0];
          final distance = leg['distance']['text'];
          final duration = leg['duration']['text'];
          final distanceValue = leg['distance']['value']; // in meters
          final durationValue = leg['duration']['value']; // in seconds

          return DirectionsResult(
            polylinePoints: polylineCoordinates,
            distance: distance,
            duration: duration,
            distanceInMeters: distanceValue,
            durationInSeconds: durationValue,
            bounds: _createBounds(polylineCoordinates),
          );
        } else {
          print('❌ Directions API Error: ${data['status']}');
          if (data['error_message'] != null) {
            print('Error message: ${data['error_message']}');
          }
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception fetching directions: $e');
    }

    return null;
  }

  /// Creates bounds from polyline coordinates
  LatLngBounds _createBounds(List<LatLng> points) {
    double minLat = points[0].latitude;
    double maxLat = points[0].latitude;
    double minLng = points[0].longitude;
    double maxLng = points[0].longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}

/// Model class for directions result
class DirectionsResult {
  final List<LatLng> polylinePoints;
  final String distance;
  final String duration;
  final int distanceInMeters;
  final int durationInSeconds;
  final LatLngBounds bounds;

  DirectionsResult({
    required this.polylinePoints,
    required this.distance,
    required this.duration,
    required this.distanceInMeters,
    required this.durationInSeconds,
    required this.bounds,
  });
}
