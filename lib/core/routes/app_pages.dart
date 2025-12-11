import 'package:get/get.dart';
import 'package:uber_driver/features/auth/view/screen/forget_password_screen.dart';
import 'package:uber_driver/features/profile/view/screen/driver_profile_screen.dart';
import 'package:uber_driver/features/profile/view/screen/edit_profile_screen.dart';

import '../../features/auth/view/screen/login_screen.dart';
import '../../features/auth/view/screen/sign_up_screen.dart';
import '../../features/home/view/screen/home_screen.dart';
import '../../features/on_boarding/view/screen/on_boarding_screen.dart';
import '../../features/splash/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.forgetPassword,
      page: () => const ForgetPasswordScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const DriverProfileScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
