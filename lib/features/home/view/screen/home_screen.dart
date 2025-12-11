import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/socket/models/ride_request_model.dart';
import '../../../../core/socket/socket_service.dart';
import '../../../../core/storage/secure_storage_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../business_logic/home_cubit/home_cubit.dart';
import '../../business_logic/home_cubit/home_state.dart';
import '../../business_logic/map_cubit/map_cubit.dart';
import '../../business_logic/map_cubit/map_state.dart';
import '../widget/driver_stats_card.dart';
import '../widget/ride_request_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SocketService _socketService = SocketService();
  String? _driverId;
  HomeCubit? _homeCubit;
  String? _currentRideId;
  bool _hasActiveRide = false;
  bool _hasTripStarted = false;
  bool _hasArrivedAtPickup = false;
  bool _hasArrivedAtDropoff = false;
  double? _dropoffLat;
  double? _dropoffLng;
  double _tripDistance = 0.0;
  int _tripDuration = 0;

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }

  Future<void> _initializeSocket() async {
    // Get driver ID from secure storage or profile
    _driverId = await SecureStorageHelper.getUserId();

    if (_driverId != null) {
      _socketService.init(_driverId!);
      _socketService.connect();

      // Set up ride request handler
      _socketService.onNewRideRequest = (data) {
        _showRideRequestDialog(data);
      };
    }
  }

  void _showRideRequestDialog(Map<String, dynamic> data) {
    try {
      // Debug: Print the received data
      print('📦 Received ride request data: $data');

      final rideRequest = RideRequest.fromJson(data);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => RideRequestDialog(
          rideRequest: rideRequest,
          onAccept: () {
            Navigator.pop(dialogContext);
            _handleAcceptRide(rideRequest.rideId);
          },
          onDecline: () {
            Navigator.pop(dialogContext);
            if (_homeCubit != null) {
              _homeCubit!.declineRide(rideId: rideRequest.rideId);
            }
            Fluttertoast.showToast(
              msg: 'Ride request declined',
              backgroundColor: AppColors.error,
            );
          },
        ),
      );
    } catch (e, stackTrace) {
      print('❌ Error parsing ride request: $e');
      print('Stack trace: $stackTrace');
      Fluttertoast.showToast(
        msg: 'Error parsing ride request: $e',
        backgroundColor: AppColors.error,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void _handleAcceptRide(String rideId) {
    if (_homeCubit != null) {
      _homeCubit!.acceptRide(rideId: rideId);
    }
  }

  void _handleDriverStatusChange(bool isOnline) {
    if (_driverId != null) {
      if (isOnline) {
        _socketService.goOnline(_driverId!);
      } else {
        _socketService.goOffline(_driverId!);
      }
    }
  }

  void _showCancelConfirmation(HomeCubit homeCubit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: AppColors.error,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Cancel Trip?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure? This may affect your rating.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'No',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (_currentRideId != null) {
                  homeCubit.updateRideStatus(
                    rideId: _currentRideId!,
                    statusData: {'status': 'cancelled'},
                  );
                  setState(() {
                    _hasActiveRide = false;
                    _hasTripStarted = false;
                    _hasArrivedAtPickup = false;
                    _hasArrivedAtDropoff = false;
                    _currentRideId = null;
                    _dropoffLat = null;
                    _dropoffLng = null;
                  });
                  Fluttertoast.showToast(
                    msg: 'Trip cancelled',
                    backgroundColor: AppColors.error,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Yes, Cancel',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<MapCubit>()..getCurrentLocation(),
        ),
        BlocProvider(
          create: (context) => getIt<HomeCubit>()..fetchDriverStatus(),
        ),
      ],
      child: BlocBuilder<MapCubit, MapState>(
        builder: (context, mapState) {
          final mapCubit = context.read<MapCubit>();

          return Scaffold(
            body: BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is AvailabilitySuccessState) {
                  final isOnline = state.response.data.isAvailable;
                  mapCubit.isOnline = isOnline;
                  mapCubit.addCarMarker(isOnline);

                  // Handle socket connection
                  _handleDriverStatusChange(isOnline);

                  // Start or stop location tracking
                  if (state.response.data.isAvailable) {
                    mapCubit.startLocationTracking();
                    context.read<HomeCubit>().fetchDriverStatus();
                  } else {
                    mapCubit.stopLocationTracking();
                  }
                }

                if (state is DriverStatusLoadedState) {
                  final isOnline = state.response.data.isAvailable;
                  mapCubit.isOnline = isOnline;
                  mapCubit.addCarMarker(isOnline);

                  // Handle socket connection
                  _handleDriverStatusChange(isOnline);

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
                    final pickupCoords =
                        rideData.pickup!.location!.coordinates!;
                    final dropoffCoords =
                        rideData.dropoff!.location!.coordinates!;

                    // Store ride ID for status updates
                    _currentRideId = rideData.sId;
                    setState(() {
                      _hasActiveRide = true;
                      _hasTripStarted = false;
                      _hasArrivedAtPickup = false;
                      _dropoffLat = dropoffCoords[1];
                      _dropoffLng = dropoffCoords[0];
                      _tripDistance = rideData.estimatedDistance ?? 0.0;
                      _tripDuration = rideData.estimatedDuration ?? 0;
                    });

                    // Add pickup and dropoff markers
                    mapCubit.addRideMarkers(
                      pickupLat: pickupCoords[1], // latitude is second element
                      pickupLng: pickupCoords[0], // longitude is first element
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
                          // Update ride status to 'arrived' when reaching pickup
                          if (_currentRideId != null && _homeCubit != null) {
                            log('🚗 Updating ride status to arrived for ride: $_currentRideId');
                            _homeCubit!.updateRideStatus(
                              rideId: _currentRideId!,
                              statusData: {'status': 'arrived'},
                            );
                            setState(() {
                              _hasArrivedAtPickup = true;
                            });
                            log('✅ Ride status updated to arrived');
                          }
                        },
                      );
                    });

                    Fluttertoast.showToast(
                      msg: 'Starting navigation to pickup location',
                      backgroundColor: AppColors.success,
                      toastLength: Toast.LENGTH_LONG,
                    );
                  }
                }

                if (state is AcceptDeclineRideErrorState) {
                  Fluttertoast.showToast(
                    msg: state.message,
                    backgroundColor: AppColors.error,
                    toastLength: Toast.LENGTH_LONG,
                  );
                }

                // Handle ride status update response
                if (state is DriveStatusLoadedState) {
                  print('✅ Ride status updated: ${state.message}');
                  Fluttertoast.showToast(
                    msg: 'Status updated: ${state.message}',
                    backgroundColor: AppColors.success,
                  );
                }

                if (state is DriverStatusErrorState) {
                  print('❌ Failed to update ride status: ${state.message}');
                  Fluttertoast.showToast(
                    msg: 'Failed to update status: ${state.message}',
                    backgroundColor: AppColors.error,
                  );
                }
              },
              builder: (context, homeState) {
                final homeCubit = context.read<HomeCubit>();
                // Capture HomeCubit reference for socket callbacks
                _homeCubit ??= homeCubit;

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
                      onMapCreated: (GoogleMapController controller) {
                        mapCubit.setMapController(controller);
                      },
                    ),
                    SafeArea(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.menu),
                                    onPressed: () {
                                      // Open drawer or menu
                                    },
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.person),
                                    onPressed: () {
                                      Get.toNamed(AppRoutes.profile);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),

                          // Driver Stats Card - Show when no active ride
                          if (!_hasActiveRide)
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
                          if (_hasActiveRide && _hasArrivedAtPickup)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              child: Row(
                                children: [
                                  if (!_hasTripStarted)
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_currentRideId != null &&
                                              _dropoffLat != null &&
                                              _dropoffLng != null) {
                                            _homeCubit!.updateRideStatus(
                                              rideId: _currentRideId!,
                                              statusData: {
                                                'status': 'in-progress'
                                              },
                                            );
                                            setState(() {
                                              _hasTripStarted = true;
                                            });

                                            // Start navigation to dropoff location
                                            mapCubit.simulateMovementToPickup(
                                              pickupLat: _dropoffLat!,
                                              pickupLng: _dropoffLng!,
                                              onArrived: () {
                                                setState(() {
                                                  _hasArrivedAtDropoff = true;
                                                });
                                                Fluttertoast.showToast(
                                                  msg: 'Arrived at destination',
                                                  backgroundColor:
                                                      AppColors.success,
                                                );
                                              },
                                            );

                                            Fluttertoast.showToast(
                                              msg:
                                                  'Trip started - Navigating to destination',
                                              backgroundColor:
                                                  AppColors.primary,
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.car_crash_sharp,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'Start',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_currentRideId != null) {
                                            homeCubit.completeRide(
                                              rideId: _currentRideId!,
                                              actualDistance: _tripDistance,
                                              actualDuration: _tripDuration,
                                            );

                                            setState(() {
                                              _hasActiveRide = false;
                                              _hasTripStarted = false;
                                              _hasArrivedAtPickup = false;
                                              _hasArrivedAtDropoff = false;
                                              _currentRideId = null;
                                              _dropoffLat = null;
                                              _dropoffLng = null;
                                              _tripDistance = 0.0;
                                              _tripDuration = 0;
                                            });

                                            // Refresh driver stats and add car marker back (clears other markers)

                                            Fluttertoast.showToast(
                                              msg: 'Trip completed',
                                              backgroundColor:
                                                  AppColors.primary,
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.check, size: 18),
                                            SizedBox(width: 4),
                                            Text(
                                              'Complete',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 8),

                                  // Cancel Button
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _showCancelConfirmation(homeCubit);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.error,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.close,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Online/Offline Toggle Button (only when no active ride)
                          if (!_hasActiveRide)
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: GestureDetector(
                                onTap: () {
                                  homeCubit.toggleAvailability();
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: homeCubit.isAvailable
                                        ? AppColors.success
                                        : AppColors.error,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (homeCubit.isAvailable
                                                ? AppColors.success
                                                : AppColors.error)
                                            .withOpacity(0.4),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    homeCubit.isAvailable
                                        ? Icons.power_settings_new
                                        : Icons.power_settings_new,
                                    size: 40,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
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
      ),
    );
  }
}
