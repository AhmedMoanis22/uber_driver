import '../../../../core/network/api_constant.dart';
import '../../../../core/network/api_services.dart';
import '../model/driver_profile_model.dart';

class ProfileDataSource {
  final ApiServices apiServices;

  ProfileDataSource({required this.apiServices});

  Future<DriverProfileResponse> getDriverProfile() async {
    final response = await apiServices.getData(
      urll: ApiConstance.driverProfile,
    );

    return DriverProfileResponse.fromJson(response.data);
  }

  Future<DriverProfileResponse> updateDriverPersonalInfo({
    required Map<String, dynamic> profileData,
  }) async {
    final response = await apiServices.putData(
      urll: ApiConstance.updatePersonalInfo,
      data: profileData,
    );

    return DriverProfileResponse.fromJson(response.data);
  }

  Future<DriverProfileResponse> updateDriverVehicleInfo({
    required Map<String, dynamic> vehicleData,
  }) async {
    final response = await apiServices.putData(
      urll: ApiConstance.updateVehicleInfo,
      data: vehicleData,
    );

    return DriverProfileResponse.fromJson(response.data);
  }
}
