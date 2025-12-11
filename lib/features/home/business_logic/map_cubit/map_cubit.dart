import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/repo/home_repo.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required this.homeRepo}) : super(MapInitialState());
  final HomeRepo homeRepo;

  GoogleMapController? mapController;
  Position? currentPosition;
  bool isOnline = false;
  Set<Marker> markers = {};
  var locationSubscription;
  var simulationSubscription;
  bool isSimulating = false;

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> addCarMarker(bool isOnline) async {
    if (currentPosition == null) return;

    markers.clear();

    if (isOnline) {
      final carIcon = await _getCarIcon();

      markers.add(
        Marker(
          markerId: const MarkerId('driver_location'),
          position: LatLng(
            currentPosition!.latitude,
            currentPosition!.longitude,
          ),
          icon: carIcon,
          rotation: 0,
          anchor: const Offset(0.5, 0.5),
          flat: true,
          infoWindow: const InfoWindow(
            title: 'You',
            snippet: 'Online',
          ),
        ),
      );
    }

    emit(MapLoadedState(currentPosition!));
  }

  Future<BitmapDescriptor> _getCarIcon() async {
    return BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/images/car.png',
    );
  }

  // Add pickup and dropoff markers for accepted ride
  Future<void> addRideMarkers({
    required double pickupLat,
    required double pickupLng,
    required String pickupAddress,
    required double dropoffLat,
    required double dropoffLng,
    required String dropoffAddress,
  }) async {
    markers.clear();

    // Keep the car marker if online
    if (isOnline && currentPosition != null) {
      final carIcon = await _getCarIcon();
      markers.add(
        Marker(
          markerId: const MarkerId('driver_location'),
          position: LatLng(
            currentPosition!.latitude,
            currentPosition!.longitude,
          ),
          icon: carIcon,
          rotation: 0,
          anchor: const Offset(0.5, 0.5),
          flat: true,
          infoWindow: const InfoWindow(
            title: 'You',
            snippet: 'Your current location',
          ),
        ),
      );
    }

    // Add pickup marker
    markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(pickupLat, pickupLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: 'Pickup Location',
          snippet: pickupAddress,
        ),
      ),
    );

    // Add dropoff marker
    markers.add(
      Marker(
        markerId: const MarkerId('dropoff'),
        position: LatLng(dropoffLat, dropoffLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Dropoff Location',
          snippet: dropoffAddress,
        ),
      ),
    );

    // Update the map to show all markers
    if (currentPosition != null) {
      emit(MapLoadedState(currentPosition!));
    }

    // Calculate bounds to show all markers
    _animateToBounds(
      driverLat: currentPosition?.latitude ?? pickupLat,
      driverLng: currentPosition?.longitude ?? pickupLng,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropoffLat: dropoffLat,
      dropoffLng: dropoffLng,
    );
  }

  // Animate camera to show all markers
  void _animateToBounds({
    required double driverLat,
    required double driverLng,
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
  }) {
    // Calculate bounds
    double minLat =
        [driverLat, pickupLat, dropoffLat].reduce((a, b) => a < b ? a : b);
    double maxLat =
        [driverLat, pickupLat, dropoffLat].reduce((a, b) => a > b ? a : b);
    double minLng =
        [driverLng, pickupLng, dropoffLng].reduce((a, b) => a < b ? a : b);
    double maxLng =
        [driverLng, pickupLng, dropoffLng].reduce((a, b) => a > b ? a : b);

    // Add padding
    final latPadding = (maxLat - minLat) * 0.3;
    final lngPadding = (maxLng - minLng) * 0.3;

    final bounds = LatLngBounds(
      southwest: LatLng(minLat - latPadding, minLng - lngPadding),
      northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
    );

    mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
  }

  Future<void> getCurrentLocation() async {
    emit(MapLoadingState());

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(const MapErrorState('Location services are disabled'));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(const MapErrorState('Location permission denied'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
            const MapErrorState('Location permissions are permanently denied'));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition = position;
      emit(MapLoadedState(position));

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );
    } catch (e) {
      emit(MapErrorState('Failed to get location: ${e.toString()}'));
    }
  }

  // Start tracking and updating location to database
  void startLocationTracking() {
    locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      currentPosition = position;

      print(
          '📍 Current Location: Lat: ${position.latitude}, Long: ${position.longitude}');

      // Update car marker on map
      if (isOnline) {
        addCarMarker(true);
      }

      // Update location in database
      _updateLocationInDatabase(position);

      // Move camera smoothly
      mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    });
  }

  // Stop tracking location
  void stopLocationTracking() {
    locationSubscription?.cancel();
    locationSubscription = null;
  }

  // Private method to update database (silent, no loading states)
  Future<void> _updateLocationInDatabase(Position position) async {
    print(
        '📍 Updating location to database: ${position.latitude}, ${position.longitude}');

    final result = await homeRepo.updateDriverLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      address: 'Current location',
    );

    result.fold(
      (failure) => print('❌ Failed to update location: ${failure.message}'),
      (response) => print('✅ Location updated successfully in database'),
    );
  }

  // Manual update if needed
  Future<void> updateDriverLocation({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    final result = await homeRepo.updateDriverLocation(
        latitude: latitude, longitude: longitude, address: address);

    result.fold(
      (failure) {
        print('Failed to update location: ${failure.message}');
      },
      (response) {
        print('Location updated successfully');
      },
    );
  }

  // Simulate car movement to pickup location
  Future<void> simulateMovementToPickup({
    required double pickupLat,
    required double pickupLng,
    required VoidCallback onArrived,
  }) async {
    if (currentPosition == null || isSimulating) return;

    isSimulating = true;
    stopLocationTracking(); // Stop real tracking during simulation

    final startLat = currentPosition!.latitude;
    final startLng = currentPosition!.longitude;

    // Calculate steps (smaller steps = smoother animation)
    const totalSteps = 100; // 100 steps for smooth animation
    const stepDuration = Duration(milliseconds: 100); // Update every 100ms

    int currentStep = 0;

    simulationSubscription = Stream.periodic(stepDuration, (count) => count)
        .take(totalSteps + 1)
        .listen((step) async {
      currentStep = step;

      // Calculate current position using linear interpolation
      final progress = step / totalSteps;
      final currentLat = startLat + (pickupLat - startLat) * progress;
      final currentLng = startLng + (pickupLng - startLng) * progress;

      // Update current position
      currentPosition = Position(
        latitude: currentLat,
        longitude: currentLng,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );

      // Update car marker
      await _updateCarMarkerPosition(currentLat, currentLng);

      // Update location in database only every 10 steps (once per second) to avoid rate limiting
      if (currentStep % 10 == 0 || currentStep == totalSteps) {
        _updateLocationInDatabase(currentPosition!);
      }

      // Move camera to follow the car
      mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(currentLat, currentLng),
        ),
      );

      print(
          '🚗 Simulating movement: Step $currentStep/$totalSteps - Lat: $currentLat, Lng: $currentLng');

      // When reached destination
      if (currentStep == totalSteps) {
        print('✅ Reached pickup location!');
        stopSimulation();
        // Call the callback when arrived
        onArrived.call();
      }
    });
  }

  // Update car marker position during simulation
  Future<void> _updateCarMarkerPosition(double lat, double lng) async {
    if (!isOnline) return;

    final carIcon = await _getCarIcon();

    // Find and update car marker
    markers.removeWhere((marker) => marker.markerId.value == 'driver_location');

    markers.add(
      Marker(
        markerId: const MarkerId('driver_location'),
        position: LatLng(lat, lng),
        icon: carIcon,
        rotation: 0,
        anchor: const Offset(0.5, 0.5),
        flat: true,
        infoWindow: const InfoWindow(
          title: 'You',
          snippet: 'Driving to pickup',
        ),
      ),
    );

    emit(MapLoadedState(currentPosition!));
  }

  // Stop simulation
  void stopSimulation() {
    simulationSubscription?.cancel();
    simulationSubscription = null;
    isSimulating = false;
    print('🛑 Simulation stopped');
  }

  @override
  Future<void> close() {
    stopLocationTracking();
    stopSimulation();
    mapController?.dispose();
    return super.close();
  }
}
