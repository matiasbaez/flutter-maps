import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps/blocs/blocs.dart';
import 'package:maps/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  final LocationBloc locationBloc;
  GoogleMapController? _mapController;

  MapBloc({
    required this.locationBloc
  }) : super(const MapState()) {

    on<InitializeMapEvent>(_onInitMap);
    on<StartFollowingUserMapEvent>(_startFollowingUserMap);
    on<StopFollowingUserMapEvent>((event, emit) => emit(state.copyWith(isFollowingUser: false)));

    locationBloc.stream.listen((LocationState locationState) {
      if (!state.isFollowingUser) return;
      if (locationState.lastKnownLocation == null) return;

      moveCamera(locationState.lastKnownLocation!);
    });

  }

  void _onInitMap( InitializeMapEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));
    emit(state.copyWith( isMapInitialized: true ));
  }

  void moveCamera( LatLng location ) {
    final cameraUpdate = CameraUpdate.newLatLng(location);
    _mapController?.moveCamera(cameraUpdate);
  }

  void _startFollowingUserMap(StartFollowingUserMapEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));

    if (locationBloc.state.lastKnownLocation == null) return;
    moveCamera(locationBloc.state.lastKnownLocation!);
  }

}
