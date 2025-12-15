import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/socket/models/ride_request_model.dart';
import '../../business_logic/home_cubit/home_cubit.dart';
import '../../business_logic/home_cubit/home_state.dart';
import '../../business_logic/map_cubit/map_cubit.dart';
import '../../business_logic/map_cubit/map_state.dart';
import '../widget/cancel_trip_dialog.dart';
import '../widget/driver_stats_card.dart';
import '../widget/home_app_bar.dart';
import '../widget/online_toggle_button.dart';
import '../widget/ride_request_dialog.dart';
import '../widget/trip_action_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize socket after the first frame when context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final homeCubit = context.read<HomeCubit>();
        homeCubit.initializeSocket(
          (data) => _showRideRequestDialog(context, data),
        );
      }
    });
  }

  void _showRideRequestDialog(BuildContext context, Map<String, dynamic> data) {
    try {
      log('📦 Received ride request data: $data');

      final rideRequest = RideRequest.fromJson(data);
      final homeCubit = context.read<HomeCubit>();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => RideRequestDialog(
          rideRequest: rideRequest,
          onAccept: () {
            Navigator.pop(dialogContext);
            homeCubit.acceptRide(rideId: rideRequest.rideId);
          },
          onDecline: () {
            Navigator.pop(dialogContext);
            homeCubit.declineRide(rideId: rideRequest.rideId);
            ErrorHandler.showError('Ride request declined');
          },
        ),
      );
    } catch (e, stackTrace) {
      log('❌ Error parsing ride request: $e');
      log('Stack trace: $stackTrace');
      ErrorHandler.showError('Error parsing ride request: $e');
    }
  }

  void _showCancelConfirmation(BuildContext context, HomeCubit homeCubit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CancelTripDialog(
          onConfirm: () {
            if (homeCubit.currentRideId != null) {
              homeCubit.updateRideStatus(
                rideId: homeCubit.currentRideId!,
                statusData: {'status': 'cancelled'},
              );
              homeCubit.clearRideTracking();
              ErrorHandler.showError('Trip cancelled');
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, mapState) {
        final mapCubit = context.read<MapCubit>();
        final homeCubit = context.read<HomeCubit>();

        return Scaffold(
          body: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state is AvailabilitySuccessState) {
                final isOnline = state.response.data.isAvailable;
                mapCubit.isOnline = isOnline;
                mapCubit.addCarMarker(isOnline);

                // Handle socket connection
                homeCubit.handleDriverStatusChange(isOnline);

                // Start or stop location tracking
                if (state.response.data.isAvailable) {
                  mapCubit.startLocationTracking();
                  homeCubit.fetchDriverStatus();
                } else {
                  mapCubit.stopLocationTracking();
                }
              }

              if (state is DriverStatusLoadedState) {
                final isOnline = state.response.data.isAvailable;
                mapCubit.isOnline = isOnline;
                mapCubit.addCarMarker(isOnline);

                // Handle socket connection
                homeCubit.handleDriverStatusChange(isOnline);

                // Start or stop location tracking
                if (isOnline) {
                  mapCubit.startLocationTracking();
                }
              }

              // Handle ride acceptance
              if (state is AcceptDeclineRideLoadedState) {
                final rideData = state.response.data;
                if (rideData != null &&
                    rideData.pickup != null &&
                    rideData.dropoff != null &&
                    rideData.pickup!.location?.coordinates != null &&
                    rideData.dropoff!.location?.coordinates != null) {
                  final pickupCoords = rideData.pickup!.location!.coordinates!;
                  final dropoffCoords =
                      rideData.dropoff!.location!.coordinates!;

                  // Update ride tracking in cubit
                  homeCubit.updateRideTracking(
                    rideId: rideData.sId,
                    active: true,
                    started: false,
                    arrivedPickup: false,
                    dropLat: dropoffCoords[1],
                    dropLng: dropoffCoords[0],
                    distance: rideData.estimatedDistance ?? 0.0,
                    duration: rideData.estimatedDuration ?? 0,
                  );

                  // Add pickup and dropoff markers
                  mapCubit.addRideMarkers(
                    pickupLat: pickupCoords[1],
                    pickupLng: pickupCoords[0],
                    pickupAddress:
                        rideData.pickup!.address ?? 'Pickup location',
                    dropoffLat: dropoffCoords[1],
                    dropoffLng: dropoffCoords[0],
                    dropoffAddress:
                        rideData.dropoff!.address ?? 'Dropoff location',
                  );

                  // Start simulating movement to pickup location
                  Future.delayed(const Duration(seconds: 5), () {
                    mapCubit.simulateMovementToPickup(
                      pickupLat: pickupCoords[1],
                      pickupLng: pickupCoords[0],
                      onArrived: () {
                        if (homeCubit.currentRideId != null) {
                          log('🚗 Updating ride status to arrived for ride: ${homeCubit.currentRideId}');
                          homeCubit.updateRideStatus(
                            rideId: homeCubit.currentRideId!,
                            statusData: {'status': 'arrived'},
                          );
                          homeCubit.updateRideTracking(arrivedPickup: true);
                          log('✅ Ride status updated to arrived');
                        }
                      },
                    );
                  });

                  ErrorHandler.showSuccess(
                      'Starting navigation to pickup location');
                }
              }

              if (state is AcceptDeclineRideErrorState) {
                ErrorHandler.showError(state.message);
              }

              // Handle ride status update response
              if (state is DriveStatusLoadedState) {
                log('✅ Ride status updated: ${state.message}');
                ErrorHandler.showSuccess('Status updated: ${state.message}');
              }

              if (state is DriverStatusErrorState) {
                log('❌ Failed to update ride status: ${state.message}');
                ErrorHandler.showError(
                    'Failed to update status: ${state.message}');
              }

              // Handle ride completion
              if (state is CompletedRidesLoadedState) {
                log('✅ Ride completed: ${state.message}');
                mapCubit.clearMarkersAndPolylines();
                if (mapCubit.isOnline) {
                  mapCubit.startLocationTracking();
                }
              }
            },
            builder: (context, homeState) {
              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: mapCubit.currentPosition != null
                          ? LatLng(mapCubit.currentPosition!.latitude,
                              mapCubit.currentPosition!.longitude)
                          : const LatLng(37.7749, -122.4194), // Default to SF
                      zoom: 14,
                    ),
                    myLocationEnabled: !homeCubit.isAvailable,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    markers: mapCubit.markers,
                    polylines: mapCubit.polylines,
                    onMapCreated: (GoogleMapController controller) {
                      mapCubit.setMapController(controller);
                    },
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        const HomeAppBar(),
                        const Spacer(),

                        // Driver Stats Card - Show when no active ride
                        if (!homeCubit.hasActiveRide)
                          BlocBuilder<HomeCubit, HomeState>(
                              builder: (context, state) {
                            if (state is DriverStatusLoadedState) {
                              return DriverStatsCard(
                                stats: state.response.data.stats,
                              );
                            }

                            return const SizedBox.shrink();
                          }),

                        // Trip Action Buttons (only show when arrived at pickup)
                        if (homeCubit.hasActiveRide &&
                            homeCubit.hasArrivedAtPickup)
                          TripActionButtons(
                            hasTripStarted: homeCubit.hasTripStarted,
                            onStartTrip: () {
                              if (homeCubit.currentRideId != null &&
                                  homeCubit.dropoffLat != null &&
                                  homeCubit.dropoffLng != null) {
                                homeCubit.updateRideStatus(
                                  rideId: homeCubit.currentRideId!,
                                  statusData: {'status': 'in-progress'},
                                );
                                homeCubit.updateRideTracking(started: true);

                                // Start navigation to dropoff location
                                mapCubit.simulateMovementToPickup(
                                  pickupLat: homeCubit.dropoffLat!,
                                  pickupLng: homeCubit.dropoffLng!,
                                  onArrived: () {
                                    homeCubit.updateRideTracking(
                                        arrivedDropoff: true);
                                    ErrorHandler.showSuccess(
                                        'Arrived at destination');
                                  },
                                );

                                ErrorHandler.showInfo(
                                    'Trip started - Navigating to destination');
                              }
                            },
                            onCompleteTrip: () {
                              if (homeCubit.currentRideId != null) {
                                homeCubit.completeRide(
                                  rideId: homeCubit.currentRideId!,
                                  actualDistance: homeCubit.tripDistance,
                                  actualDuration: homeCubit.tripDuration,
                                );

                                homeCubit.clearRideTracking();

                                ErrorHandler.showSuccess('Trip completed');
                              }
                            },
                            onCancelTrip: () {
                              _showCancelConfirmation(context, homeCubit);
                            },
                          ),

                        // Online/Offline Toggle Button (only when no active ride)
                        if (!homeCubit.hasActiveRide)
                          OnlineToggleButton(
                            isOnline: homeCubit.isAvailable,
                            onToggle: () {
                              homeCubit.toggleAvailability();
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
