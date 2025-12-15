import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as getx;
import 'package:uber_driver/features/auth/view/screen/forget_password_screen.dart';
import 'package:uber_driver/features/profile/view/screen/driver_profile_screen.dart';
import 'package:uber_driver/features/profile/view/screen/edit_profile_screen.dart';

import '../../features/auth/view/screen/login_screen.dart';
import '../../features/auth/view/screen/sign_up_screen.dart';
import '../../features/home/business_logic/home_cubit/home_cubit.dart';
import '../../features/home/business_logic/map_cubit/map_cubit.dart';
import '../../features/home/view/screen/home_screen.dart';
import '../../features/on_boarding/view/screen/on_boarding_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../di/dependency_injection.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    getx.GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: getx.Transition.fade,
    ),
    getx.GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      transition: getx.Transition.fadeIn,
    ),
    getx.GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      transition: getx.Transition.rightToLeft,
    ),
    getx.GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      transition: getx.Transition.rightToLeft,
    ),
    getx.GetPage(
      name: AppRoutes.home,
      page: () => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<MapCubit>()..getCurrentLocation(),
          ),
          BlocProvider(
            create: (context) => getIt<HomeCubit>()..fetchDriverStatus(),
          ),
        ],
        child: const HomeScreen(),
      ),
      transition: getx.Transition.fadeIn,
    ),
    getx.GetPage(
      name: AppRoutes.forgetPassword,
      page: () => const ForgetPasswordScreen(),
      transition: getx.Transition.rightToLeft,
    ),
    getx.GetPage(
      name: AppRoutes.profile,
      page: () => const DriverProfileScreen(),
      transition: getx.Transition.rightToLeft,
    ),
    getx.GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      transition: getx.Transition.rightToLeft,
    ),
  ];
}
