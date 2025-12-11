import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../bussiness_logic/profile_cubit.dart';
import '../../bussiness_logic/profile_state.dart';
import '../widget/custom_info_card.dart';

class VehicleInformation extends StatefulWidget {
  const VehicleInformation({super.key});

  @override
  State<VehicleInformation> createState() => _VehicleInformationState();
}

class _VehicleInformationState extends State<VehicleInformation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _vehicleMakeController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _vehicleYearController = TextEditingController();
  final TextEditingController _vehicleColorController = TextEditingController();
  final TextEditingController _vehiclePlateNumberController =
      TextEditingController();
  bool _isEditing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<ProfileCubit>().state;
    if (state is DriverProfileLoadedState) {
      _populateFields(state.response.data);
    } else if (state is ProfileUpdatedState) {
      _populateFields(state.response.data);
    }
  }

  void _populateFields(dynamic profile) {
    _vehicleTypeController.text = profile.vehicleType;
    _vehicleMakeController.text = profile.vehicleMake;
    _vehicleModelController.text = profile.vehicleModel;
    _vehicleYearController.text = profile.vehicleYear.toString();
    _vehicleColorController.text = profile.vehicleColor;
    _vehiclePlateNumberController.text = profile.vehiclePlateNumber;
  }

  @override
  void dispose() {
    _vehicleTypeController.dispose();
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    _vehicleColorController.dispose();
    _vehiclePlateNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
        title: const Text(
          'Vehicle Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<ProfileCubit>().updateDriverVehicleInformation(
                        vehicleType: _vehicleTypeController.text,
                        vehicleMake: _vehicleMakeController.text,
                        vehicleModel: _vehicleModelController.text,
                        vehicleYear: int.parse(_vehicleYearController.text),
                        vehicleColor: _vehicleColorController.text,
                        vehiclePlateNumber: _vehiclePlateNumberController.text,
                      );
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.white),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is DriverProfileLoadedState) {
            _populateFields(state.response.data);
          }
          if (state is ProfileUpdatedState) {
            _populateFields(state.response.data);
            setState(() {
              _isEditing = false;
            });
            Fluttertoast.showToast(
                msg: state.response.message ?? 'Vehicle updated successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColors.primary,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          if (state is ProfileUpdatingErrorState) {
            Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColors.error,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final profile = state is DriverProfileLoadedState
                ? state.response.data
                : state is ProfileUpdatedState
                    ? state.response.data
                    : null;

            if (profile == null) {
              return const Center(
                child: Text('No vehicle information available'),
              );
            }

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Vehicle Image Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
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
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.directions_car,
                              size: 80,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${profile.vehicleMake} ${profile.vehicleModel}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.vehicleType,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Vehicle Details
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Vehicle Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Vehicle Fields
                          if (_isEditing) ...[
                            CustomTextField(
                              controller: _vehicleTypeController,
                              labelText: 'Vehicle Type',
                              prefixIcon: Icons.category,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter vehicle type';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _vehicleMakeController,
                              labelText: 'Vehicle Make',
                              prefixIcon: Icons.business,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter vehicle make';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _vehicleModelController,
                              labelText: 'Vehicle Model',
                              prefixIcon: Icons.directions_car_filled,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter vehicle model';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _vehicleYearController,
                              labelText: 'Vehicle Year',
                              prefixIcon: Icons.calendar_today,
                              keyboardType: TextInputType.number,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter vehicle year';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _vehicleColorController,
                              labelText: 'Vehicle Color',
                              prefixIcon: Icons.palette,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter vehicle color';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _vehiclePlateNumberController,
                              labelText: 'Plate Number',
                              prefixIcon: Icons.confirmation_number,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter plate number';
                                }
                                return null;
                              },
                            ),
                          ] else ...[
                            BuildInfoCard(
                              icon: Icons.calendar_today,
                              title: 'Year',
                              value: profile.vehicleYear.toString(),
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 12),
                            BuildInfoCard(
                              icon: Icons.palette,
                              title: 'Color',
                              value: profile.vehicleColor,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 12),
                            BuildInfoCard(
                              icon: Icons.confirmation_number,
                              title: 'Plate Number',
                              value: profile.vehiclePlateNumber,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 12),
                            BuildInfoCard(
                              icon: Icons.business,
                              title: 'Make',
                              value: profile.vehicleMake,
                              color: Colors.purple,
                            ),
                            const SizedBox(height: 12),
                            BuildInfoCard(
                              icon: Icons.directions_car_filled,
                              title: 'Model',
                              value: profile.vehicleModel,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 12),
                            BuildInfoCard(
                              icon: Icons.category,
                              title: 'Type',
                              value: profile.vehicleType,
                              color: Colors.teal,
                            ),
                          ],

                          const SizedBox(height: 32),

                          // Full Width Info Summary
                          if (!_isEditing)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary.withOpacity(0.1),
                                    AppColors.primary.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: AppColors.primary,
                                        size: 24,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Vehicle Summary',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Your ${profile.vehicleColor} ${profile.vehicleYear} ${profile.vehicleMake} ${profile.vehicleModel} (${profile.vehicleType}) with plate number ${profile.vehiclePlateNumber} is registered and verified.',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: AppColors.textSecondary,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
