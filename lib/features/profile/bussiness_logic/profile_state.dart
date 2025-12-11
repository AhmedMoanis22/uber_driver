import '../data/model/driver_profile_model.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class DriverProfileLoadedState extends ProfileState {
  final DriverProfileResponse response;

  DriverProfileLoadedState({required this.response});
}

class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState({required this.message});
}

class ProfileUpdatingState extends ProfileState {}

class ProfileUpdatedState extends ProfileState {
  final DriverProfileResponse response;

  ProfileUpdatedState({required this.response});
}

class ProfileUpdatingErrorState extends ProfileState {
  final String message;

  ProfileUpdatingErrorState({required this.message});
}
