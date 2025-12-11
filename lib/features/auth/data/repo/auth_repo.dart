import 'package:dartz/dartz.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../data_source/auth_remote_data_source.dart';
import '../model/login_model.dart';

class AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepository({required this.authRemoteDataSource});

  Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final remoteData = await authRemoteDataSource.login(
        email: email,
        password: password,
      );

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }

  Future<Either<Failure, AuthResponse>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String licenseNumber,
    required String vehicleType,
    required String vehicleMake,
    required String vehicleModel,
    required int vehicleYear,
    required String vehicleColor,
    required String vehiclePlateNumber,
  }) async {
    try {
      final remoteData = await authRemoteDataSource.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
        licenseNumber: licenseNumber,
        vehicleType: vehicleType,
        vehicleMake: vehicleMake,
        vehicleModel: vehicleModel,
        vehicleYear: vehicleYear,
        vehicleColor: vehicleColor,
        vehiclePlateNumber: vehiclePlateNumber,
      );

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }

  Future<Either<Failure, String>> sendOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final remoteData = await authRemoteDataSource.sendOtp(
        email: email,
        otp: otp,
      );

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }

  Future<Either<Failure, String>> forgetPassword({
    required String email,
  }) async {
    try {
      final remoteData = await authRemoteDataSource.forgetPassword(
        email: email,
      );

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }

  Future<Either<Failure, String>> resendOtp({
    required String email,
  }) async {
    try {
      final remoteData = await authRemoteDataSource.resendOtp(
        email: email,
      );

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }

  Future<Either<Failure, String>> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final remoteData = await authRemoteDataSource.verifyResetOtp(
        email: email,
        otp: otp,
      );

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }

  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  }) async {
    try {
      final remoteData = await authRemoteDataSource.resetPassword(
        email: email,
        newPassword: newPassword,
        otp: otp,
      );

      return Right(remoteData);
    } catch (e) {
      final apiError = ErrorHandler.handle(e);
      return Left(ServerFailure(apiError.getAllErrorMessages()));
    }
  }
}
