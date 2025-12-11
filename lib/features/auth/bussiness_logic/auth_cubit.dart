import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_driver/features/auth/bussiness_logic/auth_state.dart';

import '../data/repo/auth_repo.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    final result = await authRepository.login(email: email, password: password);
    result.fold(
      (failure) {
        emit(LoginErrorState(failure.message));
      },
      (loginResponse) {
        emit(LoginSuccessState(loginResponse));
      },
    );
  }

  Future<void> signUp({
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
    emit(SignUpLoadingState());
    final result = await authRepository.signUp(
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
    result.fold(
      (failure) {
        emit(SignUpErrorState(failure.message));
      },
      (signUpResponse) {
        emit(SignUpSuccessState(signUpResponse));
      },
    );
  }

  Future<void> sendOtp({
    required String email,
    required String otp,
  }) async {
    emit(OtpSendingLoadingState());
    final result = await authRepository.sendOtp(email: email, otp: otp);
    result.fold(
      (failure) {
        emit(OtpSendingErrorState(failure.message));
      },
      (message) {
        emit(OtpSendingSuccessState(message));
      },
    );
  }

  Future<void> forgetPassword({
    required String email,
  }) async {
    emit(ForgetPasswordLoadingState());
    final result = await authRepository.forgetPassword(email: email);
    result.fold(
      (failure) {
        emit(ForgetPasswordErrorState(failure.message));
      },
      (message) {
        emit(ForgetPasswordSuccessState(message));
      },
    );
  }

  Future<void> resendOtp({
    required String email,
  }) async {
    emit(ResendOtpLoadingState());
    final result = await authRepository.resendOtp(email: email);
    result.fold(
      (failure) {
        emit(ResendOtpErrorState(failure.message));
      },
      (message) {
        emit(ResendOtpSuccessState(message));
      },
    );
  }

  Future<void> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    emit(OtpSendingLoadingState());
    final result = await authRepository.verifyResetOtp(email: email, otp: otp);
    result.fold(
      (failure) {
        emit(OtpSendingErrorState(failure.message));
      },
      (message) {
        emit(OtpSendingSuccessState(message));
      },
    );
  }

  Future<void> resetPassword({
    required String email,
    required String oTP,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoadingState());
    final result = await authRepository.resetPassword(
        email: email, otp: oTP, newPassword: newPassword);
    result.fold(
      (failure) {
        emit(ResetPasswordErrorState(failure.message));
      },
      (message) {
        emit(ResetPasswordSuccessState(message));
      },
    );
  }
}
