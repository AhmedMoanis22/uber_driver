class RideRequest {
  final String rideId;
  final UserInfo user;
  final LocationInfo pickup;
  final LocationInfo dropoff;
  final double estimatedFare;
  final double estimatedDistance;
  final int estimatedDuration;
  final String vehicleType;

  RideRequest({
    required this.rideId,
    required this.user,
    required this.pickup,
    required this.dropoff,
    required this.estimatedFare,
    required this.estimatedDistance,
    required this.estimatedDuration,
    required this.vehicleType,
  });

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    return RideRequest(
      rideId: json['rideId'] ?? json['_id'] ?? '',
      user: UserInfo.fromJson(json['user'] ?? {}),
      pickup: LocationInfo.fromJson(json['pickup'] ?? {}),
      dropoff: LocationInfo.fromJson(json['dropoff'] ?? {}),
      estimatedFare: (json['estimatedFare'] ?? 0).toDouble(),
      estimatedDistance: (json['estimatedDistance'] ?? 0).toDouble(),
      estimatedDuration: json['estimatedDuration'] ?? 0,
      vehicleType: json['vehicleType'] ?? '',
    );
  }
}

class UserInfo {
  final String firstName;
  final String lastName;
  final String phone;

  UserInfo({
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}

class LocationInfo {
  final String address;
  final List<double> coordinates;

  LocationInfo({
    required this.address,
    required this.coordinates,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    final location = json['location'] ?? {};
    final coords = location['coordinates'] ?? [];

    return LocationInfo(
      address: json['address'] ?? '',
      coordinates: coords is List
          ? coords.map((e) => (e as num).toDouble()).toList()
          : [0.0, 0.0],
    );
  }

  double get latitude => coordinates.length > 1 ? coordinates[1] : 0.0;
  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0.0;
}
