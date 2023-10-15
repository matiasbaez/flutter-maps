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
