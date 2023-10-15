part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class NewUserLocationEvent extends LocationEvent {
  final LatLng newLocation;
  const NewUserLocationEvent({required this.newLocation});
}

class StartFollowingUserEvent extends LocationEvent {}
class StopFollowingUserEvent extends LocationEvent {}
