class UpdateDriverLocationModel {
  final bool success;
  final String message;
  final LocationData data;

  UpdateDriverLocationModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdateDriverLocationModel.fromJson(Map<String, dynamic> json) {
    return UpdateDriverLocationModel(
      success: json['success'],
      message: json['message'],
      data: LocationData.fromJson(json['data']),
    );
  }
}

class LocationData {
  final DriverLocation location;
  final bool isAvailable;

  LocationData({
    required this.location,
    required this.isAvailable,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      location: DriverLocation.fromJson(json['location']),
      isAvailable: json['isAvailable'],
    );
  }
}

class DriverLocation {
  final double latitude;
  final double longitude;
  final String address;
  final DateTime lastUpdated;

  DriverLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.lastUpdated,
  });

  factory DriverLocation.fromJson(Map<String, dynamic> json) {
    return DriverLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
