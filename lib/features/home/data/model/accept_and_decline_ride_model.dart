class AcceptOrDeclineRideModel {
  final bool success;
  final String? message;
  final RideData? data;

  AcceptOrDeclineRideModel({
    required this.success,
    this.message,
    this.data,
  });

  factory AcceptOrDeclineRideModel.fromJson(Map<String, dynamic> json) =>
      AcceptOrDeclineRideModel(
        success: json['success'] == true,
        message: json['message'] as String?,
        data: json['data'] == null ? null : RideData.fromJson(json['data']),
      );
}

class RideData {
  final PlacePoint? pickup;
  final PlacePoint? dropoff;
  final String? sId;
  final RideUser? user;
  final RideDriver? driver;
  final String? status;
  final double? estimatedFare;
  final double? finalFare;
  final String? paymentMethod;
  final String? paymentStatus;
  final double? estimatedDistance;
  final int? estimatedDuration;
  final double? actualDistance;
  final int? actualDuration;
  final String? vehicleType;
  final double? userRating;
  final double? driverRating;
  final String? userReview;
  final String? driverReview;
  final DateTime? acceptedAt;
  final DateTime? arrivedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancelledBy;
  final String? cancellationReason;
  final DateTime? requestedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  RideData({
    this.pickup,
    this.dropoff,
    this.sId,
    this.user,
    this.driver,
    this.status,
    this.estimatedFare,
    this.finalFare,
    this.paymentMethod,
    this.paymentStatus,
    this.estimatedDistance,
    this.estimatedDuration,
    this.actualDistance,
    this.actualDuration,
    this.vehicleType,
    this.userRating,
    this.driverRating,
    this.userReview,
    this.driverReview,
    this.acceptedAt,
    this.arrivedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancelledBy,
    this.cancellationReason,
    this.requestedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory RideData.fromJson(Map<String, dynamic> json) => RideData(
        pickup:
            json['pickup'] == null ? null : PlacePoint.fromJson(json['pickup']),
        dropoff: json['dropoff'] == null
            ? null
            : PlacePoint.fromJson(json['dropoff']),
        sId: json['_id'] as String?,
        user: json['user'] == null ? null : RideUser.fromJson(json['user']),
        driver:
            json['driver'] == null ? null : RideDriver.fromJson(json['driver']),
        status: json['status'] as String?,
        estimatedFare: _toDouble(json['estimatedFare']),
        finalFare: _toDouble(json['finalFare']),
        paymentMethod: json['paymentMethod'] as String?,
        paymentStatus: json['paymentStatus'] as String?,
        estimatedDistance: _toDouble(json['estimatedDistance']),
        estimatedDuration: _toInt(json['estimatedDuration']),
        actualDistance: _toDouble(json['actualDistance']),
        actualDuration: _toInt(json['actualDuration']),
        vehicleType: json['vehicleType'] as String?,
        userRating: _toDouble(json['userRating']),
        driverRating: _toDouble(json['driverRating']),
        userReview: json['userReview'] as String?,
        driverReview: json['driverReview'] as String?,
        acceptedAt: _parseDate(json['acceptedAt']),
        arrivedAt: _parseDate(json['arrivedAt']),
        startedAt: _parseDate(json['startedAt']),
        completedAt: _parseDate(json['completedAt']),
        cancelledAt: _parseDate(json['cancelledAt']),
        cancelledBy: json['cancelledBy'] as String?,
        cancellationReason: json['cancellationReason'] as String?,
        requestedAt: _parseDate(json['requestedAt']),
        createdAt: _parseDate(json['createdAt']),
        updatedAt: _parseDate(json['updatedAt']),
        v: _toInt(json['__v']),
      );

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    try {
      return DateTime.parse(v as String);
    } catch (_) {
      return null;
    }
  }
}

class PlacePoint {
  final GeoPoint? location;
  final String? address;

  PlacePoint({this.location, this.address});

  factory PlacePoint.fromJson(Map<String, dynamic> json) => PlacePoint(
        location: json['location'] == null
            ? null
            : GeoPoint.fromJson(json['location']),
        address: json['address'] as String?,
      );
}

class GeoPoint {
  final String? type;
  final List<double>? coordinates;

  GeoPoint({this.type, this.coordinates});

  factory GeoPoint.fromJson(Map<String, dynamic> json) => GeoPoint(
        type: json['type'] as String?,
        coordinates: _coordsFromJson(json['coordinates']),
      );

  static List<double>? _coordsFromJson(dynamic v) {
    if (v == null) return null;
    if (v is List) {
      return v
          .map((e) {
            if (e is double) return e;
            if (e is int) return e.toDouble();
            if (e is String) return double.tryParse(e) ?? 0.0;
            return 0.0;
          })
          .cast<double>()
          .toList();
    }
    return null;
  }
}

class RideUser {
  final String? sId;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? fullName;
  final String? id;

  RideUser({
    this.sId,
    this.firstName,
    this.lastName,
    this.phone,
    this.fullName,
    this.id,
  });

  factory RideUser.fromJson(Map<String, dynamic> json) => RideUser(
        sId: json['_id'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
        fullName: json['fullName'] as String?,
        id: json['id'] as String?,
      );
}

class RideDriver {
  final GeoPoint? currentLocation;
  final String? sId;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? vehicleType;
  final String? vehicleMake;
  final String? vehicleModel;
  final String? vehicleColor;
  final String? vehiclePlateNumber;
  final String? fullName;
  final String? vehicleInfo;
  final String? id;

  RideDriver({
    this.currentLocation,
    this.sId,
    this.firstName,
    this.lastName,
    this.phone,
    this.vehicleType,
    this.vehicleMake,
    this.vehicleModel,
    this.vehicleColor,
    this.vehiclePlateNumber,
    this.fullName,
    this.vehicleInfo,
    this.id,
  });

  factory RideDriver.fromJson(Map<String, dynamic> json) => RideDriver(
        currentLocation: json['currentLocation'] == null
            ? null
            : GeoPoint.fromJson(json['currentLocation']),
        sId: json['_id'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
        vehicleType: json['vehicleType'] as String?,
        vehicleMake: json['vehicleMake'] as String?,
        vehicleModel: json['vehicleModel'] as String?,
        vehicleColor: json['vehicleColor'] as String?,
        vehiclePlateNumber: json['vehiclePlateNumber'] as String?,
        fullName: json['fullName'] as String?,
        vehicleInfo: json['vehicleInfo'] as String?,
        id: json['id'] as String?,
      );
}
