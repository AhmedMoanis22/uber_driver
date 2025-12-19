class DriverProfileResponse {
  final bool success;
  final String? message;
  final DriverData data;

  DriverProfileResponse({
    required this.success,
    this.message,
    required this.data,
  });

  factory DriverProfileResponse.fromJson(Map<String, dynamic> json) {
    return DriverProfileResponse(
      success: json['success'],
      message: json['message'],
      data: DriverData.fromJson(json['data']),
    );
  }
}

class DriverData {
  final CurrentLocation currentLocation;
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String status;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String? profileImage;
  final String? dateOfBirth;
  final String licenseNumber;
  final String vehicleType;
  final String vehicleMake;
  final String vehicleModel;
  final int vehicleYear;
  final String vehicleColor;
  final String vehiclePlateNumber;
  final bool isAvailable;
  final double rating;
  final int totalRides;
  final double totalEarnings;
  final String createdAt;
  final String updatedAt;
  final int v;
  final String fullName;
  final String vehicleInfo;

  DriverData({
    required this.currentLocation,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.status,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.profileImage,
    required this.dateOfBirth,
    required this.licenseNumber,
    required this.vehicleType,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.vehicleColor,
    required this.vehiclePlateNumber,
    required this.isAvailable,
    required this.rating,
    required this.totalRides,
    required this.totalEarnings,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.fullName,
    required this.vehicleInfo,
  });

  factory DriverData.fromJson(Map<String, dynamic> json) {
    return DriverData(
      currentLocation: CurrentLocation.fromJson(json['currentLocation']),
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      status: json['status'],
      isEmailVerified: json['isEmailVerified'],
      isPhoneVerified: json['isPhoneVerified'],
      profileImage: json['profileImage'],
      dateOfBirth: json['dateOfBirth'],
      licenseNumber: json['licenseNumber'],
      vehicleType: json['vehicleType'],
      vehicleMake: json['vehicleMake'],
      vehicleModel: json['vehicleModel'],
      vehicleYear: json['vehicleYear'],
      vehicleColor: json['vehicleColor'],
      vehiclePlateNumber: json['vehiclePlateNumber'],
      isAvailable: json['isAvailable'],
      rating: (json['rating']).toDouble(),
      totalRides: json['totalRides'],
      totalEarnings: (json['totalEarnings'] ?? 0).toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      fullName: json['fullName'],
      vehicleInfo: json['vehicleInfo'],
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
      coordinates: List<double>.from(
        json['coordinates'].map((x) => x.toDouble()),
      ),
      address: json['address'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
