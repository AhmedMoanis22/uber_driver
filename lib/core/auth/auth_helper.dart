import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../storage/secure_storage_helper.dart';

class AuthHelper {
  /// Logout user and clear all stored data
  static Future<void> logout() async {
    await SecureStorageHelper.clearTokens();
    Get.offAllNamed(AppRoutes.login);
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    return await SecureStorageHelper.isLoggedIn();
  }

  /// Get stored token
  static Future<String?> getToken() async {
    return await SecureStorageHelper.getToken();
  }

  /// Get stored refresh token
  static Future<String?> getRefreshToken() async {
    return await SecureStorageHelper.getRefreshToken();
  }
}
