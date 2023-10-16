part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class InitializeMapEvent extends MapEvent {
  final GoogleMapController controller;
  const InitializeMapEvent({required this.controller});
}

class StartFollowingUserMapEvent extends MapEvent {}
class StopFollowingUserMapEvent extends MapEvent {}

class UpdateUserMapPolylinesEvent extends MapEvent {
  final List<LatLng> locationHistory;
  const UpdateUserMapPolylinesEvent({ required this.locationHistory });
}

class ToggleMapPolylines extends MapEvent {}
