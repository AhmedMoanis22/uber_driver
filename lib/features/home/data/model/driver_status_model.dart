class DriverStatusResponse {
  final bool success;
  final DriverStatusData data;

  DriverStatusResponse({
    required this.success,
    required this.data,
  });

  factory DriverStatusResponse.fromJson(Map<String, dynamic> json) {
    return DriverStatusResponse(
      success: json['success'],
      data: DriverStatusData.fromJson(json['data']),
    );
  }
}

class DriverStatusData {
  final bool isAvailable;
  final CurrentLocation currentLocation;
  final DriverStats stats;
  final ActiveRide? activeRide; // Nullable

  DriverStatusData({
    required this.isAvailable,
    required this.currentLocation,
    required this.stats,
    this.activeRide,
  });

  factory DriverStatusData.fromJson(Map<String, dynamic> json) {
    return DriverStatusData(
      isAvailable: json['isAvailable'],
      currentLocation: CurrentLocation.fromJson(json['currentLocation']),
      stats: DriverStats.fromJson(json['stats']),
      activeRide: json['activeRide'] == null
          ? null
          : ActiveRide.fromJson(json['activeRide']),
    );
  }
}

class CurrentLocation {
  final String type;
  final List<double> coordinates;
  final String address;
  final DateTime lastUpdated;

  CurrentLocation({
    required this.type,
    required this.coordinates,
    required this.address,
    required this.lastUpdated,
  });

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      type: json['type'],
      coordinates:
          List<double>.from(json['coordinates'].map((x) => x.toDouble())),
      address: json['address'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

class DriverStats {
  final double rating;
  final int totalRides;
  final double totalEarnings;

  DriverStats({
    required this.rating,
    required this.totalRides,
    required this.totalEarnings,
  });

  factory DriverStats.fromJson(Map<String, dynamic> json) {
    return DriverStats(
      rating: (json['rating']).toDouble(),
      totalRides: json['totalRides'],
      totalEarnings: (json['totalEarnings']).toDouble(),
    );
  }
}

// OPTIONAL: لو في المستقبل activeRide هيكون object
class ActiveRide {
  final String id;

  ActiveRide({required this.id});

  factory ActiveRide.fromJson(Map<String, dynamic> json) {
    return ActiveRide(
      id: json['_id'],
    );
  }
}
