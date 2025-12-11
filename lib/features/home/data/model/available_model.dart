class DriverAvailabilityResponse {
  final bool success;
  final String message;
  final DriverStatusData data;

  DriverAvailabilityResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DriverAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return DriverAvailabilityResponse(
      success: json['success'],
      message: json['message'],
      data: DriverStatusData.fromJson(json['data']),
    );
  }
}

class DriverStatusData {
  final bool isAvailable;
  final DriverInfo driver;

  DriverStatusData({
    required this.isAvailable,
    required this.driver,
  });

  factory DriverStatusData.fromJson(Map<String, dynamic> json) {
    return DriverStatusData(
      isAvailable: json['isAvailable'],
      driver: DriverInfo.fromJson(json['driver']),
    );
  }
}

class DriverInfo {
  final String id;
  final String name;
  final String vehicleType;

  DriverInfo({
    required this.id,
    required this.name,
    required this.vehicleType,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      id: json['id'],
      name: json['name'],
      vehicleType: json['vehicleType'],
    );
  }
}
