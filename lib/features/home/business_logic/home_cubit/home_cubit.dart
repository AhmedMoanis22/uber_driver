import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_driver/features/home/business_logic/home_cubit/home_state.dart';
import 'package:uber_driver/features/home/data/repo/home_repo.dart';

import '../../../../core/socket/socket_service.dart';
import '../../../../core/storage/secure_storage_helper.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;
  HomeCubit({required this.homeRepo}) : super(HomeInitialState());

  bool isAvailable = false;
  final SocketService _socketService = SocketService();
  String? _driverId;

  // Ride tracking state
  String? currentRideId;
  bool hasActiveRide = false;
  bool hasTripStarted = false;
  bool hasArrivedAtPickup = false;
  bool hasArrivedAtDropoff = false;
  double? dropoffLat;
  double? dropoffLng;
  double tripDistance = 0.0;
  int tripDuration = 0;

  /// Initialize socket connection
  Future<void> initializeSocket(
      Function(Map<String, dynamic>) onRideRequest) async {
    _driverId = await SecureStorageHelper.getUserId();

    if (_driverId != null) {
      _socketService.init(_driverId!);
      _socketService.connect();
      _socketService.onNewRideRequest = onRideRequest;
    }
  }

  /// Handle driver online/offline status change
  void handleDriverStatusChange(bool isOnline) {
    if (_driverId != null) {
      if (isOnline) {
        _socketService.goOnline(_driverId!);
      } else {
        _socketService.goOffline(_driverId!);
      }
    }
  }

  /// Update ride tracking state
  void updateRideTracking({
    String? rideId,
    bool? active,
    bool? started,
    bool? arrivedPickup,
    bool? arrivedDropoff,
    double? dropLat,
    double? dropLng,
    double? distance,
    int? duration,
  }) {
    currentRideId = rideId ?? currentRideId;
    hasActiveRide = active ?? hasActiveRide;
    hasTripStarted = started ?? hasTripStarted;
    hasArrivedAtPickup = arrivedPickup ?? hasArrivedAtPickup;
    hasArrivedAtDropoff = arrivedDropoff ?? hasArrivedAtDropoff;
    dropoffLat = dropLat ?? dropoffLat;
    dropoffLng = dropLng ?? dropoffLng;
    tripDistance = distance ?? tripDistance;
    tripDuration = duration ?? tripDuration;

    emit(RideTrackingState(
      currentRideId: currentRideId,
      hasActiveRide: hasActiveRide,
      hasTripStarted: hasTripStarted,
      hasArrivedAtPickup: hasArrivedAtPickup,
      hasArrivedAtDropoff: hasArrivedAtDropoff,
      dropoffLat: dropoffLat,
      dropoffLng: dropoffLng,
      tripDistance: tripDistance,
      tripDuration: tripDuration,
    ));
  }

  /// Clear ride tracking state
  void clearRideTracking() {
    currentRideId = null;
    hasActiveRide = false;
    hasTripStarted = false;
    hasArrivedAtPickup = false;
    hasArrivedAtDropoff = false;
    dropoffLat = null;
    dropoffLng = null;
    tripDistance = 0.0;
    tripDuration = 0;
    emit(HomeInitialState());
  }

  Future<void> toggleAvailability() async {
    emit(AvailabilityLoadingState());

    // Toggle the status
    final newStatus = !isAvailable;

    final result = await homeRepo.driverAvailabilty(isAvailable: newStatus);

    result.fold(
      (failure) {
        emit(AvailabilityErrorState(failure.message));
        // Re-emit last known state
        if (isClosed) return;
        emit(HomeInitialState());
      },
      (response) {
        isAvailable = response.data.isAvailable;
        emit(AvailabilitySuccessState(response));
      },
    );
  }

  Future<void> fetchDriverStatus() async {
    emit(DriverStatusLoadingState());

    final result = await homeRepo.getDriverStatus();

    result.fold(
      (failure) {
        emit(DriverStatusErrorState(failure.message));
        if (isClosed) return;
        emit(HomeInitialState());
      },
      (response) {
        isAvailable = response.data.isAvailable;
        emit(DriverStatusLoadedState(response));
      },
    );
  }

  Future<void> acceptRide({required String rideId}) async {
    emit(AcceptDeclineRideLoadingState());

    final result = await homeRepo.acceptRide(rideId: rideId);

    result.fold(
      (failure) {
        emit(AcceptDeclineRideErrorState(failure.message));
        if (isClosed) return;
        emit(HomeInitialState());
      },
      (response) {
        emit(AcceptDeclineRideLoadedState(response));
      },
    );
  }

  Future<void> declineRide({required String rideId}) async {
    emit(AcceptDeclineRideLoadingState());

    final result = await homeRepo.declineRide(rideId: rideId);

    result.fold(
      (failure) {
        emit(AcceptDeclineRideErrorState(failure.message));
        if (isClosed) return;
        emit(HomeInitialState());
      },
      (response) {
        emit(AcceptDeclineRideLoadedState(response));
      },
    );
  }

  Future<void> updateRideStatus({
    required String rideId,
    required Map<String, dynamic> statusData,
  }) async {
    final result = await homeRepo.rideStatus(
      rideId: rideId,
      statusData: statusData,
    );
    result.fold(
      (failure) {
        emit(DriverStatusErrorState(failure.message));
        if (isClosed) return;
        emit(HomeInitialState());
      },
      (response) {
        emit(DriveStatusLoadedState(response));
      },
    );
  }

  Future<void> completeRide({
    required String rideId,
    required double actualDistance,
    required int actualDuration,
  }) async {
    emit(CompletedRidesLoadingState());

    final result = await homeRepo.completeRide(
      rideId: rideId,
      completionData: {
        "actualDistance": actualDistance,
        "actualDuration": actualDuration
      },
    );

    result.fold(
      (failure) {
        emit(CompletedRidesErrorState(failure.message));
        if (isClosed) return;
        emit(HomeInitialState());
      },
      (response) {
        emit(CompletedRidesLoadedState(response));
      },
    );
  }

  @override
  Future<void> close() {
    _socketService.disconnect();
    return super.close();
  }
}
