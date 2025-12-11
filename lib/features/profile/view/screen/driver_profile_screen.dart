import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:uber_driver/features/profile/bussiness_logic/profile_cubit.dart';
import 'package:uber_driver/features/profile/bussiness_logic/profile_state.dart';
import 'package:uber_driver/features/profile/view/screen/edit_profile_screen.dart';
import 'package:uber_driver/features/profile/view/screen/vehicle_information.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/secure_storage_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../widget/custom_profile_menu_item.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  late final ProfileCubit _profileCubit;

  @override
  void initState() {
    super.initState();
    _profileCubit = getIt<ProfileCubit>();
    _profileCubit.fetchDriverProfile();
  }

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileCubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState || state is ProfileUpdatingState) {
              return const Center(child: CupertinoActivityIndicator());
            }

            if (state is ProfileErrorState) {
              return Center(child: Text(state.message));
            }

            if (state is ProfileUpdatingErrorState) {
              return Center(child: Text(state.message));
            }

            final profile = (state is DriverProfileLoadedState
                ? state.response.data
                : state is ProfileUpdatedState
                    ? state.response.data
                    : _profileCubit.driverdata);

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  backgroundColor: AppColors.primary,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.white,
                              backgroundImage: profile.profileImage != null
                                  ? _getImageProvider(profile.profileImage!)
                                  : null,
                              child: profile.profileImage == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: AppColors.textSecondary,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            profile.fullName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                profile.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${profile.totalRides} Trips',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Account Section
                        const Text(
                          'Account',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ProfileMenuItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          subtitle: 'Update your information',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                        value: _profileCubit,
                                        child: const EditProfileScreen())));
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.directions_car_outlined,
                          title: 'Vehicle Information',
                          subtitle: 'Manage your vehicle details',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                        value: _profileCubit,
                                        child: const VehicleInformation())));
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.description_outlined,
                          title: 'Documents',
                          subtitle: 'License, insurance, registration',
                          onTap: () {
                            // Navigate to documents
                          },
                        ),

                        const SizedBox(height: 24),

                        // Earnings Section
                        const Text(
                          'Earnings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ProfileMenuItem(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'Wallet',
                          subtitle: 'View your balance and transactions',
                          onTap: () {
                            // Navigate to wallet
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.history,
                          title: 'Trip History',
                          subtitle: 'View all completed trips',
                          onTap: () {
                            // Navigate to trip history
                          },
                        ),

                        const SizedBox(height: 24),

                        // Settings Section
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ProfileMenuItem(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          subtitle: 'Manage notification preferences',
                          onTap: () {
                            // Navigate to notifications settings
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.language,
                          title: 'Language',
                          subtitle: 'English',
                          onTap: () {
                            // Navigate to language settings
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          subtitle: 'Get help and contact support',
                          onTap: () {
                            // Navigate to help
                          },
                        ),

                        const SizedBox(height: 24),

                        // Logout Button
                        ProfileMenuItem(
                          icon: Icons.logout,
                          title: 'Logout',
                          subtitle: 'Sign out of your account',
                          iconColor: AppColors.error,
                          titleColor: AppColors.error,
                          onTap: () async {
                            // Show confirmation dialog
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text(
                                  'Are you sure you want to logout?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text(
                                      'Logout',
                                      style: TextStyle(color: AppColors.error),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await SecureStorageHelper.clearTokens();
                              Get.offAllNamed(AppRoutes.login);
                            }
                          },
                        ),

                        const SizedBox(height: 32),

                        // Version
                        Center(
                          child: Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary.withOpacity(0.6),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(String imagePath) {
    // Check if it's a network URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    }
    // Check if it's a local file path
    else if (imagePath.startsWith('/') || imagePath.contains('file://')) {
      // Remove file:// prefix if exists
      final cleanPath = imagePath.replaceFirst('file://', '');
      return FileImage(File(cleanPath));
    }
    // Default to network (could be a relative path on server)
    else {
      return NetworkImage(imagePath);
    }
  }
}
