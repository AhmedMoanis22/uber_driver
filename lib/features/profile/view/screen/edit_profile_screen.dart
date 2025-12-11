import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../bussiness_logic/profile_cubit.dart';
import '../../bussiness_logic/profile_state.dart';
import '../widget/custom_info_card.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _profileImageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String? _serverImageUrl;
  bool _isEditing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load data immediately if already available
    final state = context.read<ProfileCubit>().state;
    if (state is DriverProfileLoadedState) {
      _populateFields(state.response.data);
    } else if (state is ProfileUpdatedState) {
      _populateFields(state.response.data);
    }
  }

  void _populateFields(dynamic profile) {
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _addressController.text = profile.currentLocation.address;
    _profileImageController.text = profile.profileImage ?? '';

    setState(() {
      _serverImageUrl = profile.profileImage;
    });
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _profileImageController.text = image.path;
        });
      }
    } catch (e) {
      log('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _profileImageController.dispose();
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
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<ProfileCubit>().updateDriverProfileInformation(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        phone: _phoneController.text,
                        email: _emailController.text,
                        profileImage: _profileImageController.text,
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
              icon: const Icon(Icons.edit),
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
                msg: state.response.message ?? 'Profile updated successfully',
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Picture Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: _pickImageFromGallery,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: AppColors.white,
                                backgroundImage: _getImageProvider(),
                                child: _selectedImage == null &&
                                        _serverImageUrl == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 70,
                                        color: AppColors.primary,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Change Photo',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Fields
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildSectionTitle('Personal Information'),
                      const SizedBox(height: 16),
                      if (_isEditing) ...[
                        CustomTextField(
                          controller: _firstNameController,
                          labelText: 'First Name',
                          prefixIcon: Icons.person_outline,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your First name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _lastNameController,
                          labelText: 'Last Name',
                          prefixIcon: Icons.person_outline,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _phoneController,
                          labelText: 'Phone Number',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ] else ...[
                        BuildInfoCard(
                          icon: Icons.person_outline,
                          title: 'First Name',
                          value: _firstNameController.text,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        BuildInfoCard(
                          icon: Icons.person_outline,
                          title: 'Last Name',
                          value: _lastNameController.text,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 12),
                        BuildInfoCard(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          value: _emailController.text,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 12),
                        BuildInfoCard(
                          icon: Icons.phone_outlined,
                          title: 'Phone Number',
                          value: _phoneController.text,
                          color: Colors.purple,
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  ImageProvider? _getImageProvider() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    }

    if (_serverImageUrl != null && _serverImageUrl!.isNotEmpty) {
      if (_serverImageUrl!.startsWith('http://') ||
          _serverImageUrl!.startsWith('https://')) {
        return NetworkImage(_serverImageUrl!);
      } else if (_serverImageUrl!.startsWith('/') ||
          _serverImageUrl!.contains('file://')) {
        final cleanPath = _serverImageUrl!.replaceFirst('file://', '');
        return FileImage(File(cleanPath));
      }
    }

    return null;
  }
}
