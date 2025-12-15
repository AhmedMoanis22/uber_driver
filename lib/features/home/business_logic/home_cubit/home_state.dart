import '../../data/model/accept_and_decline_ride_model.dart';
import '../../data/model/available_model.dart';
import '../../data/model/driver_status_model.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class AvailabilityLoadingState extends HomeState {}

class AvailabilitySuccessState extends HomeState {
  final DriverAvailabilityResponse response;

  AvailabilitySuccessState(this.response);
}

class AvailabilityErrorState extends HomeState {
  final String message;

  AvailabilityErrorState(this.message);
}

class DriverStatusLoadingState extends HomeState {}

class DriverStatusLoadedState extends HomeState {
  final DriverStatusResponse response;

  DriverStatusLoadedState(this.response);
}

class AcceptDeclineRideLoadingState extends HomeState {}

class AcceptDeclineRideLoadedState extends HomeState {
  final AcceptOrDeclineRideModel response;

  AcceptDeclineRideLoadedState(this.response);
}

class AcceptDeclineRideErrorState extends HomeState {
  final String message;

  AcceptDeclineRideErrorState(this.message);
}

class DriveStatusLoadedState extends HomeState {
  final String message;

  DriveStatusLoadedState(this.message);
}

class DriverStatusErrorState extends HomeState {
  final String message;

  DriverStatusErrorState(this.message);
}

class CompletedRidesLoadingState extends HomeState {}

class CompletedRidesLoadedState extends HomeState {
  final String message;

  CompletedRidesLoadedState(this.message);
}

class CompletedRidesErrorState extends HomeState {
  final String message;

  CompletedRidesErrorState(this.message);
}

// Ride tracking states
class RideTrackingState extends HomeState {
  final String? currentRideId;
  final bool hasActiveRide;
  final bool hasTripStarted;
  final bool hasArrivedAtPickup;
  final bool hasArrivedAtDropoff;
  final double? dropoffLat;
  final double? dropoffLng;
  final double tripDistance;
  final int tripDuration;

  RideTrackingState({
    this.currentRideId,
    this.hasActiveRide = false,
    this.hasTripStarted = false,
    this.hasArrivedAtPickup = false,
    this.hasArrivedAtDropoff = false,
    this.dropoffLat,
    this.dropoffLng,
    this.tripDistance = 0.0,
    this.tripDuration = 0,
  });
}
