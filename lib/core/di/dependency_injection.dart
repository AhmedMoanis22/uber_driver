// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:uber_driver/features/profile/bussiness_logic/profile_cubit.dart';

import '../../features/auth/bussiness_logic/auth_cubit.dart';
import '../../features/auth/data/data_source/auth_remote_data_source.dart';
import '../../features/auth/data/repo/auth_repo.dart';
import '../../features/home/business_logic/home_cubit/home_cubit.dart';
import '../../features/home/business_logic/map_cubit/map_cubit.dart';
import '../../features/home/data/data_source/home_data_source.dart';
import '../../features/home/data/repo/home_repo.dart';
import '../../features/profile/data/data_source/driver_profile_data_source.dart';
import '../../features/profile/data/repo/driver_profile_repo.dart';
import '../network/api_factory.dart';
import '../network/api_services.dart';

final getIt = GetIt.instance;

Future<void> setupGetit() async {
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<ApiServices>(() => ApiServices(dio: dio));

/* Auth Feature Dependencies */
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(apiServices: getIt()));

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(
        authRemoteDataSource: getIt(),
      ));
  getIt.registerFactory<AuthCubit>(() => AuthCubit(authRepository: getIt()));

  /* Home Feature Dependencies */

  getIt.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSource(apiServices: getIt()));
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(
        homeRemoteDataSource: getIt(),
      ));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(homeRepo: getIt()));

  getIt.registerFactory<MapCubit>(() => MapCubit(homeRepo: getIt()));

  /* Profile Feature Dependencies */

  getIt.registerLazySingleton<ProfileDataSource>(
      () => ProfileDataSource(apiServices: getIt()));
  getIt.registerLazySingleton<DriverProfileRepo>(() => DriverProfileRepo(
        profileDataSource: getIt(),
      ));
  getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(driverProfileRepo: getIt()));
}
