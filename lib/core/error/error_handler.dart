import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../theme/app_colors.dart';
import 'api_error_model.dart';

class ErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(message: "Connection to server failed");
        case DioExceptionType.cancel:
          return ApiErrorModel(message: "Request to the server was cancelled");
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(message: "Connection timeout with the server");
        case DioExceptionType.unknown:
          return ApiErrorModel(
              message:
                  "Connection to the server failed due to internet connection");
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
              message: "Receive timeout in connection with the server");
        case DioExceptionType.badResponse:
          return _handleError(error.response?.data);
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(
              message: "Send timeout in connection with the server");
        case DioExceptionType.badCertificate:
          return ApiErrorModel(message: "Bad certificate");
      }
    } else {
      return ApiErrorModel(message: "Unknown error occurred");
    }
  }

  static ApiErrorModel _handleError(dynamic data) {
    return ApiErrorModel(
      message: data['message'] ?? "Unknown error occurred",
      code: data['code'],
      errors: data['data'],
    );
  }

  /// Private helper method to display toast messages with common configuration
  static void _showToast({
    required String message,
    required Color backgroundColor,
    required Color textColor,
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  static void showError(String message) {
    _showToast(
      message: message,
      backgroundColor: AppColors.error,
      textColor: AppColors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void showSuccess(String message) {
    _showToast(
      message: message,
      backgroundColor: AppColors.success,
      textColor: AppColors.white,
    );
  }

  static void showWarning(String message) {
    _showToast(
      message: message,
      backgroundColor: AppColors.warning,
      textColor: AppColors.textPrimary,
    );
  }

  static void showInfo(String message) {
    _showToast(
      message: message,
      backgroundColor: AppColors.info,
      textColor: AppColors.white,
    );
  }
}
