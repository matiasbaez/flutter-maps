import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps/blocs/blocs.dart';
import 'package:maps/models/models.dart';
import 'package:maps/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  LatLng? mapCenter;

  StreamSubscription? locationStateSubscription;

  MapBloc({
    required this.locationBloc
  }) : super(const MapState()) {

    on<InitializeMapEvent>(_onInitMap);
    on<StartFollowingUserMapEvent>(_startFollowingUserMap);
    on<StopFollowingUserMapEvent>((event, emit) => emit(state.copyWith(isFollowingUser: false)));

    on<UpdateUserMapPolylinesEvent>(_updateUserMapPolylines);

    on<ToggleMapPolylines>((event, emit) => emit( state.copyWith(showPolylines: !state.showPolylines) ));
    on<DisplayCustomRouteEvent>((event, emit) => emit( state.copyWith(polylines: event.polylines) ));

    locationStateSubscription = locationBloc.stream.listen((LocationState locationState) {
      if (locationState.lastKnownLocation != null) {
        add(UpdateUserMapPolylinesEvent(locationHistory: locationState.locationHistory));
      }

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

  void _updateUserMapPolylines(UpdateUserMapPolylinesEvent event, Emitter<MapState> emit) {
    final route = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.black,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: event.locationHistory
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines["route"] = route;

    emit(state.copyWith(polylines: currentPolylines));
  }

  Future drawPolylineRoute( RouteDestination destination ) async {

    final route = Polyline(
      polylineId: const PolylineId('destination'),
      color: Colors.black,
      width: 5,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.squareCap
    );

    final currentPolylines = Map<String, Polyline>.from( state.polylines );
    currentPolylines['destination'] = route;

    add( DisplayCustomRouteEvent(polylines: currentPolylines) );

    return;
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }

}
