import 'package:dartz/dartz.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../data_source/home_data_source.dart';
import '../model/accept_and_decline_ride_model.dart';
import '../model/available_model.dart';
import '../model/driver_status_model.dart';
import '../model/update_driver_location_model.dart';

class HomeRepo {
  final HomeRemoteDataSource homeRemoteDataSource;
  HomeRepo({required this.homeRemoteDataSource});

  Future<Either<Failure, DriverAvailabilityResponse>> driverAvailabilty({
    required bool isAvailable,
  }) async {
    try {
      final remoteData = await homeRemoteDataSource.driverAvailability(
        isAvailable: isAvailable,
      );

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }

  Future<Either<Failure, UpdateDriverLocationModel>> updateDriverLocation({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      final remoteData = await homeRemoteDataSource.updateDriverLocaation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }

  Future<Either<Failure, DriverStatusResponse>> getDriverStatus() async {
    try {
      final remoteData = await homeRemoteDataSource.getDriverStatus();

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }

  Future<Either<Failure, AcceptOrDeclineRideModel>> acceptRide(
      {required String rideId}) async {
    try {
      final remoteData = await homeRemoteDataSource.acceptRide(rideId: rideId);
      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }

  Future<Either<Failure, AcceptOrDeclineRideModel>> declineRide(
      {required String rideId}) async {
    try {
      final remoteData = await homeRemoteDataSource.declineRide(rideId: rideId);
      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }

  Future<Either<Failure, String>> rideStatus({
    required String rideId,
    required Map<String, dynamic> statusData,
  }) async {
    try {
      final remoteData = await homeRemoteDataSource.rideStatus(
        rideId: rideId,
        statusData: statusData,
      );

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }

  Future<Either<Failure, String>> completeRide({
    required String rideId,
    required Map<String, dynamic> completionData,
  }) async {
    try {
      final remoteData = await homeRemoteDataSource.completeRide(
        rideId: rideId,
        completionData: completionData,
      );

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }
}
