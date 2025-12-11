import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/driver_profile_model.dart';
import '../data/repo/driver_profile_repo.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final DriverProfileRepo driverProfileRepo;
  ProfileCubit({required this.driverProfileRepo})
      : super(ProfileInitialState());
  late DriverData driverdata;

  Future<void> fetchDriverProfile() async {
    emit(ProfileLoadingState());
    final result = await driverProfileRepo.getDriverProfile();

    result.fold(
      (failure) {
        emit(ProfileErrorState(message: failure.message));
      },
      (response) {
        driverdata = response.data;
        emit(DriverProfileLoadedState(response: response));
      },
    );
  }

  Future<void> updateDriverProfileInformation({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String profileImage,
  }) async {
    emit(ProfileUpdatingState());

    final result = await driverProfileRepo.updateDriverProfile(profileData: {
      "firstName": firstName,
      "lastName": lastName,
      "phone": phone,
      "email": email,
      "profileImage": profileImage,
    });

    result.fold(
      (failure) {
        emit(ProfileUpdatingErrorState(message: failure.message));
      },
      (response) {
        driverdata = response.data;
        emit(ProfileUpdatedState(response: response));
      },
    );
  }

  Future<void> updateDriverVehicleInformation({
    required String vehicleType,
    required String vehicleMake,
    required String vehicleModel,
    required int vehicleYear,
    required String vehicleColor,
    required String vehiclePlateNumber,
  }) async {
    emit(ProfileUpdatingState());

    final result = await driverProfileRepo.updateVehicleInfo(vehicleData: {
      "vehicleType": vehicleType,
      "vehicleMake": vehicleMake,
      "vehicleModel": vehicleModel,
      "vehicleYear": vehicleYear,
      "vehicleColor": vehicleColor,
      "vehiclePlateNumber": vehiclePlateNumber
    });

    result.fold(
      (failure) {
        emit(ProfileUpdatingErrorState(message: failure.message));
      },
      (response) {
        driverdata = response.data;
        emit(ProfileUpdatedState(response: response));
      },
    );
  }
}
