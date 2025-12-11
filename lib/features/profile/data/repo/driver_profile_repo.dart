import 'package:dartz/dartz.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../data_source/driver_profile_data_source.dart';
import '../model/driver_profile_model.dart';

class DriverProfileRepo {
  final ProfileDataSource profileDataSource;

  DriverProfileRepo({required this.profileDataSource});

  Future<Either<Failure, DriverProfileResponse>> getDriverProfile() async {
    try {
      final remoteData = await profileDataSource.getDriverProfile();

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }

  Future<Either<Failure, DriverProfileResponse>> updateDriverProfile({
    required Map<String, dynamic> profileData,
  }) async {
    try {
      final remoteData = await profileDataSource.updateDriverPersonalInfo(
          profileData: profileData);

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }

  Future<Either<Failure, DriverProfileResponse>> updateVehicleInfo({
    required Map<String, dynamic> vehicleData,
  }) async {
    try {
      final remoteData = await profileDataSource.updateDriverVehicleInfo(
          vehicleData: vehicleData);

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }
}
