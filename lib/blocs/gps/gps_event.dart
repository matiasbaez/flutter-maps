part of 'gps_bloc.dart';

sealed class GpsEvent extends Equatable {
  const GpsEvent();

  @override
  List<Object> get props => [];
}

class GpsAndPermissionEvent extends GpsEvent {
  final bool isGPSEnabled;
  final bool isGPSPermissionGranted;

  const GpsAndPermissionEvent({
    required this.isGPSEnabled,
    required this.isGPSPermissionGranted
  });
}
