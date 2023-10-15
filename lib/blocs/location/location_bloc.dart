import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {

  StreamSubscription? positionStremSubscription;

  LocationBloc() : super(const LocationState()) {

    on<NewUserLocationEvent>((event, emit) {
      emit(state.copyWith(
        lastKnownLocation: event.newLocation,
        locationHistory: [...state.locationHistory, event.newLocation],
      ));
    });

    on<StartFollowingUserEvent>((event, emit) => emit(state.copyWith(followingUser: true)));
    on<StopFollowingUserEvent>((event, emit) => emit(state.copyWith(followingUser: false)));

  }

  Future getCurrentPosition() async {
    final location = await Geolocator.getCurrentPosition();
    add(NewUserLocationEvent(newLocation: LatLng(location.latitude, location.longitude)));
  }

  void startFollowingUser() {
    add(StartFollowingUserEvent());

    positionStremSubscription = Geolocator.getPositionStream().listen((event) {
      add(NewUserLocationEvent(newLocation: LatLng(event.latitude, event.longitude)));
    });
  }

  void stopFollowingUser() {
    positionStremSubscription?.cancel();
    add(StopFollowingUserEvent());
  }

  @override
  Future<void> close() {
    stopFollowingUser();
    return super.close();
  }
}
