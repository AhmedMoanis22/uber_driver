# Error Handling Guide

## Structure

```
lib/core/error/
├── exceptions.dart       # Custom exception classes
├── error_handler.dart    # UI error display handler
└── error_parser.dart     # Error parsing utilities
```

## Usage Examples

### 1. In Controllers/ViewModels

```dart
import 'package:get/get.dart';
import '../../core/error/error_handler.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      // Your API call
      final result = await authRepository.login(email, password);
      ErrorHandler.showSuccess('Login successful!');
      // Navigate to home
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      isLoading.value = false;
    }
  }
}
```

### 2. In Data Sources

```dart
import '../../../../core/error/exceptions.dart';

Future<LoginResponse> login(String email, String password) async {
  try {
    final response = await apiServices.postData(...);
    
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(response.data);
    } else if (response.statusCode == 401) {
      throw AuthException('Invalid credentials');
    } else {
      throw ServerException();
    }
  } catch (e) {
    if (e is AppException) rethrow;
    throw NetworkException();
  }
}
```

### 3. Show Different Message Types

```dart
// Error (red snackbar)
ErrorHandler.showError('Something went wrong');

// Success (green snackbar)
ErrorHandler.showSuccess('Account created successfully!');

// Warning (yellow snackbar)
ErrorHandler.showWarning('Please verify your email');

// Info (blue snackbar)
ErrorHandler.showInfo('New update available');
```

### 4. Custom Exceptions

```dart
// Network error
throw NetworkException('No internet connection');

// Authentication error
throw AuthException('Session expired, please login again');

// Validation error
throw ValidationException('Email format is invalid');

// Not found
throw NotFoundException('User not found');

// Server error
throw ServerException('Internal server error');

// Timeout
throw TimeoutException('Request took too long');
```

## Exception Types

| Exception | When to Use | Default Message |
|-----------|-------------|-----------------|
| `NetworkException` | No internet connection | "No internet connection" |
| `ServerException` | Server errors (5xx) | "Server error occurred" |
| `AuthException` | Auth failures (401, 403) | "Authentication failed" |
| `ValidationException` | Data validation errors | "Validation failed" |
| `NotFoundException` | Resource not found (404) | "Resource not found" |
| `TimeoutException` | Request timeout | "Request timeout" |

## Error Flow

```
API Call → Exception Thrown → Error Parser → Error Handler → Snackbar Display
```

## Best Practices

✅ **Always use try-catch** in async operations
✅ **Throw specific exceptions** instead of generic ones
✅ **Provide meaningful messages** to users
✅ **Handle errors in controllers**, not in UI
✅ **Use ErrorHandler.showSuccess()** for positive feedback
✅ **Log errors** for debugging (can add logging in ErrorHandler)

## Example: Complete Login Flow

```dart
// Controller
class LoginController extends GetxController {
  final AuthRepository repository;
  final isLoading = false.obs;

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      ErrorHandler.showWarning('Please fill all fields');
      return;
    }

    try {
      isLoading.value = true;
      await repository.login(email, password);
      ErrorHandler.showSuccess('Welcome back!');
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      isLoading.value = false;
    }
  }
}

// Data Source
Future<LoginResponse> login(String email, String password) async {
  try {
    final response = await apiServices.postData(...);
    
    switch (response.statusCode) {
      case 200:
      case 201:
        return LoginResponse.fromJson(response.data);
      case 401:
        throw AuthException('Invalid email or password');
      case 404:
        throw NotFoundException('Account not found');
      case 500:
        throw ServerException('Server is down, try again later');
      default:
        throw ServerException();
    }
  } catch (e) {
    if (e is AppException) rethrow;
    throw NetworkException();
  }
}
```
