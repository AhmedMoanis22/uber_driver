import '../../../../core/network/api_constant.dart';
import '../../../../core/network/api_services.dart';
import '../model/login_model.dart';

class AuthRemoteDataSource {
  final ApiServices apiServices;
  AuthRemoteDataSource({required this.apiServices});

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await apiServices.postData(
      urll: ApiConstance.loginEndpoint,
      data: {
        'email': email,
        'password': password,
      },
    );

    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> signUp({
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
    final response = await apiServices.postData(
      urll: ApiConstance.signUpEndpoint,
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'password': password,
        'licenseNumber': licenseNumber,
        'vehicleType': vehicleType,
        'vehicleMake': vehicleMake,
        'vehicleModel': vehicleModel,
        'vehicleYear': vehicleYear,
        'vehicleColor': vehicleColor,
        'vehiclePlateNumber': vehiclePlateNumber,
      },
    );

    return AuthResponse.fromJson(response.data);
  }

  Future<String> sendOtp({
    required String email,
    required String otp,
  }) async {
    final response = await apiServices.postData(
      urll: ApiConstance.sendOtpEndpoint,
      data: {
        'email': email,
        'otp': otp,
      },
    );

    return response.data['message'];
  }

  Future<String> forgetPassword({
    required String email,
  }) async {
    final response = await apiServices.postData(
      urll: ApiConstance.forgetPasswordEndpoint,
      data: {
        'email': email,
      },
    );

    return response.data['message'];
  }

  Future<String> resendOtp({
    required String email,
  }) async {
    final response = await apiServices.postData(
      urll: ApiConstance.resendOtpEndpoint,
      data: {
        'email': email,
      },
    );

    return response.data['message'];
  }

  Future<String> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    final response = await apiServices.postData(
      urll: ApiConstance.verifyResetOtp,
      data: {
        'email': email,
        'otp': otp,
      },
    );

    return response.data['message'];
  }

  Future<String> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final response = await apiServices.postData(
      urll: ApiConstance.resetPasswordEndpoint,
      data: {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      },
    );

    return response.data['message'];
  }
}
