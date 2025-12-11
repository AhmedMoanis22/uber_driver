import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_driver/features/home/data/model/update_driver_location_model.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitialState extends MapState {}

class MapLoadingState extends MapState {}

class MapLoadedState extends MapState {
  final Position position;

  const MapLoadedState(this.position);

  @override
  List<Object?> get props => [position];
}

class MapErrorState extends MapState {
  final String message;

  const MapErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateDriverLocationStateLoading extends MapState {
  const UpdateDriverLocationStateLoading();

  @override
  List<Object?> get props => [];
}

class UpdateDriverLocationStateSuccess extends MapState {
  final UpdateDriverLocationModel updateDriverLocationModel;
  const UpdateDriverLocationStateSuccess(this.updateDriverLocationModel);

  @override
  List<Object?> get props => [updateDriverLocationModel];
}

class UpdateDriverLocationStateError extends MapState {
  final String message;

  const UpdateDriverLocationStateError(this.message);

  @override
  List<Object?> get props => [message];
}

class OnlineStatusChangedState extends MapState {
  final bool isOnline;

  const OnlineStatusChangedState(this.isOnline);

  @override
  List<Object?> get props => [isOnline];
}
