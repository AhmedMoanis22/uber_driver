import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_driver/features/home/business_logic/home_cubit/home_state.dart';
import 'package:uber_driver/features/home/data/repo/home_repo.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;
  HomeCubit({required this.homeRepo}) : super(HomeInitialState());

  bool isAvailable = false;

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
}
