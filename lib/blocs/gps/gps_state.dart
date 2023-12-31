part of 'gps_bloc.dart';

class GpsState extends Equatable {

  final bool isGPSEnabled;
  final bool isGPSPermissionGranted;

  bool get isAllGranted => isGPSEnabled && isGPSPermissionGranted;

  const GpsState({
    required this.isGPSEnabled,
    required this.isGPSPermissionGranted
  });

  @override
  List<Object> get props => [ isGPSEnabled, isGPSPermissionGranted ];

  copyWith({
    bool? isGPSEnabled,
    bool? isGPSPermissionGranted
  }) => GpsState(
    isGPSEnabled: isGPSEnabled ?? this.isGPSEnabled,
    isGPSPermissionGranted: isGPSPermissionGranted ?? this.isGPSPermissionGranted
  );
}
