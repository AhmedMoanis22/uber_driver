import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:uber_driver/features/auth/view/screen/otp_screen.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../bussiness_logic/auth_cubit.dart';
import '../../bussiness_logic/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController vehicleMakeController = TextEditingController();
  final TextEditingController vehicleModelController = TextEditingController();
  final TextEditingController vehicleYearController = TextEditingController();
  final TextEditingController vehicleColorController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  String selectedVehicleType = "Sedan"; // default

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    licenseNumberController.dispose();
    vehicleTypeController.dispose();
    vehicleMakeController.dispose();
    vehicleModelController.dispose();
    vehicleYearController.dispose();
    vehicleColorController.dispose();
    plateNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: BlocProvider(
              create: (context) => getIt<AuthCubit>(),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is SignUpSuccessState) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpScreen(
                          email: emailController.text,
                        ),
                      ),
                    );
                  } else if (state is SignUpErrorState) {
                    Fluttertoast.showToast(
                      msg: state.message,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.local_taxi_rounded,
                              color: AppColors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Join as Driver',
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Create your driver account',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        labelText: 'First Name',
                        prefixIcon: Icons.person_outline,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        controller: firstNameController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Last Name',
                        prefixIcon: Icons.person_outline,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                        controller: lastNameController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        controller: emailController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Phone',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                        controller: phoneController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }

                          return null;
                        },
                        controller: passwordController,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Driver License',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        labelText: 'License Number',
                        prefixIcon: Icons.badge_outlined,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your license number';
                          }
                          return null;
                        },
                        controller: licenseNumberController,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Vehicle Information',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: "Vehicle Type",
                        ),
                        value: selectedVehicleType,
                        items: ["Sedan", "SUV", "Truck", "Van"]
                            .map((type) => DropdownMenuItem(
                                value: type, child: Text(type)))
                            .toList(),
                        onChanged: (value) {
                          selectedVehicleType = value!;
                        },
                        validator: (value) {
                          if (value == null) return "Select a vehicle type";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Vehicle Make',
                        prefixIcon: Icons.car_repair_outlined,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your vehicle make';
                          }
                          return null;
                        },
                        controller: vehicleMakeController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Vehicle Model',
                        prefixIcon: Icons.car_rental_outlined,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your vehicle model';
                          }
                          return null;
                        },
                        controller: vehicleModelController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Vehicle Year',
                        prefixIcon: Icons.calendar_today_outlined,
                        keyboardType: TextInputType.number,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your vehicle year';
                          }
                          return null;
                        },
                        controller: vehicleYearController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Vehicle Color',
                        prefixIcon: Icons.palette_outlined,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your vehicle color';
                          }
                          return null;
                        },
                        controller: vehicleColorController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'Plate Number',
                        prefixIcon: Icons.pin_outlined,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your plate number';
                          }
                          return null;
                        },
                        controller: plateNumberController,
                      ),
                      const SizedBox(height: 30),
                      state is SignUpLoadingState
                          ? const Center(
                              child: CupertinoActivityIndicator(),
                            )
                          : CustomButton(
                              text: 'Create Account',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().signUp(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                        password: passwordController.text,
                                        licenseNumber:
                                            licenseNumberController.text,
                                        vehicleType: selectedVehicleType,
                                        vehicleMake: vehicleMakeController.text,
                                        vehicleModel:
                                            vehicleModelController.text,
                                        vehicleYear: int.parse(
                                            vehicleYearController.text),
                                        vehicleColor:
                                            vehicleColorController.text,
                                        vehiclePlateNumber:
                                            plateNumberController.text,
                                      );
                                }
                              },
                            ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
