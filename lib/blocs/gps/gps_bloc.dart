import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {

  StreamSubscription? gpsServiceSubscription;

  GpsBloc() : super(const GpsState( isGPSEnabled: false, isGPSPermissionGranted: false )) {

    on<GpsAndPermissionEvent>((event, emit) {
      emit(state.copyWith(
        isGPSEnabled: event.isGPSEnabled,
        isGPSPermissionGranted: event.isGPSPermissionGranted
      ));
    });

    _init();
  }

  Future<void> _init() async {

    final [ isEnabled, isGranted ] = await Future.wait([
      _checkGPSStatus(),
      _isPermissionGranted()
    ]);

    add(GpsAndPermissionEvent(isGPSEnabled: isEnabled, isGPSPermissionGranted: isGranted));
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<bool> _checkGPSStatus() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();

    gpsServiceSubscription = Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = ( event.index == 1 ) ? true : false;
      add(GpsAndPermissionEvent(isGPSEnabled: isEnabled, isGPSPermissionGranted: state.isGPSPermissionGranted));
    });

    return isEnable;
  }

  Future<void> requestGPSAccess() async {
    final status = await Permission.location.request();

    switch (status) {
      case PermissionStatus.granted:
        add(GpsAndPermissionEvent(isGPSEnabled: state.isGPSEnabled, isGPSPermissionGranted: true));
        break;

      case PermissionStatus.denied:
      case PermissionStatus.limited:
      case PermissionStatus.restricted:
      case PermissionStatus.provisional:
      case PermissionStatus.permanentlyDenied:
        add(GpsAndPermissionEvent(isGPSEnabled: state.isGPSEnabled, isGPSPermissionGranted: false));
        openAppSettings();
        break;
    }
  }

  @override
  Future<void> close() {
    gpsServiceSubscription?.cancel();
    return super.close();
  }
}
