class ApiConstance {
  static const String baseUrl = 'http://192.168.1.13:5000/api/';
  /*auth endpoints*/
  static const String loginEndpoint = 'auth/login';
  static const String signUpEndpoint = 'auth/driver/signup';
  static const String sendOtpEndpoint = 'auth/verify-email';
  static const String verifyResetOtp = 'auth/verify-reset-otp';
  static const String resendOtpEndpoint = 'auth/resend-otp';
  static const String forgetPasswordEndpoint = 'auth/forgot-password';
  static const String resetPasswordEndpoint = 'auth/reset-password';
  /*driver endpoints*/
  static const String driverAvailability = 'driver/availability';
  static const String updateDriverLocation = 'driver/location';
  static const String driverStatus = 'driver/status';
  static const String driverProfile = 'driver/profile';
  static const String updatePersonalInfo = 'driver/profile/personal';
  static const String updateVehicleInfo = 'driver/profile/vehicle';
  static const String acceptAndDeclineRide = 'driver/ride/';
  static const String rideStatus = 'driver/ride/';
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
