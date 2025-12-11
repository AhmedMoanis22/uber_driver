import 'package:uber_driver/features/auth/data/model/login_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {
  final AuthResponse loginResponse;

  LoginSuccessState(this.loginResponse);
}

class LoginErrorState extends AuthState {
  final String message;

  LoginErrorState(this.message);
}

class SignUpLoadingState extends AuthState {}

class SignUpSuccessState extends AuthState {
  final AuthResponse signUpResponse;

  SignUpSuccessState(this.signUpResponse);
}

class SignUpErrorState extends AuthState {
  final String message;

  SignUpErrorState(this.message);
}

class OtpSendingLoadingState extends AuthState {}

class OtpSendingSuccessState extends AuthState {
  final String message;

  OtpSendingSuccessState(this.message);
}

class OtpSendingErrorState extends AuthState {
  final String message;

  OtpSendingErrorState(this.message);
}

class ForgetPasswordLoadingState extends AuthState {}

class ForgetPasswordSuccessState extends AuthState {
  final String message;

  ForgetPasswordSuccessState(this.message);
}

class ForgetPasswordErrorState extends AuthState {
  final String message;

  ForgetPasswordErrorState(this.message);
}

class ResendOtpLoadingState extends AuthState {}

class ResendOtpSuccessState extends AuthState {
  final String message;

  ResendOtpSuccessState(this.message);
}

class ResendOtpErrorState extends AuthState {
  final String message;

  ResendOtpErrorState(this.message);
}

class ResetPasswordLoadingState extends AuthState {}

class ResetPasswordSuccessState extends AuthState {
  final String message;

  ResetPasswordSuccessState(this.message);
}

class ResetPasswordErrorState extends AuthState {
  final String message;

  ResetPasswordErrorState(this.message);
}
