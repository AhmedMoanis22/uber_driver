import '../../../../core/network/api_constant.dart';
import '../../../../core/network/api_services.dart';
import '../model/accept_and_decline_ride_model.dart';
import '../model/available_model.dart';
import '../model/driver_status_model.dart';
import '../model/update_driver_location_model.dart';

class HomeRemoteDataSource {
  final ApiServices apiServices;
  HomeRemoteDataSource({required this.apiServices});

  Future<DriverAvailabilityResponse> driverAvailability({
    required bool isAvailable,
  }) async {
    final response = await apiServices.putData(
      urll: ApiConstance.driverAvailability,
      data: {
        'isAvailable': isAvailable,
      },
    );

    return DriverAvailabilityResponse.fromJson(response.data);
  }

  Future<UpdateDriverLocationModel> updateDriverLocaation({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    final response = await apiServices.putData(
      urll: ApiConstance.updateDriverLocation,
      data: {"latitude": latitude, "longitude": longitude, "address": address},
    );

    return UpdateDriverLocationModel.fromJson(response.data);
  }

  Future<DriverStatusResponse> getDriverStatus() async {
    final response = await apiServices.getData(
      urll: ApiConstance.driverStatus,
    );

    return DriverStatusResponse.fromJson(response.data);
  }

  Future<AcceptOrDeclineRideModel> acceptRide({required String rideId}) async {
    final response = await apiServices.postData(
      urll: '${ApiConstance.acceptAndDeclineRide}/$rideId/accept',
      data: {},
    );

    return AcceptOrDeclineRideModel.fromJson(response.data);
  }

  Future<AcceptOrDeclineRideModel> declineRide({required String rideId}) async {
    final response = await apiServices.postData(
      urll: '${ApiConstance.acceptAndDeclineRide}/$rideId/decline',
      data: {},
    );

    return AcceptOrDeclineRideModel.fromJson(response.data);
  }

  Future<String> rideStatus({
    required String rideId,
    required Map<String, dynamic> statusData,
  }) async {
    final url = '${ApiConstance.rideStatus}$rideId/status';
    print('📡 Calling ride status API: $url');
    print('📦 Sending data: $statusData');

    final response = await apiServices.putData(
      urll: url,
      data: statusData,
    );

    print('✅ Response received: ${response.data}');
    return response.data['message']?.toString() ?? 'Status updated';
  }

  Future<String> completeRide({
    required String rideId,
    required Map<String, dynamic> completionData,
  }) async {
    final response = await apiServices.postData(
      urll: '${ApiConstance.rideStatus}/$rideId/complete',
      data: completionData,
    );

    return response.data['message']?.toString() ?? 'Ride completed';
  }
}
