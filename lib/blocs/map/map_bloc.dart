import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps/helpers/helpers.dart';
import 'package:maps/models/models.dart';
import 'package:maps/themes/themes.dart';
import 'package:maps/blocs/blocs.dart';

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
    on<DisplayCustomRouteEvent>((event, emit) => emit( state.copyWith(polylines: event.polylines, markers: event.markers) ));

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

    // Convert meters to kilometers
    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100;

    double tripDuration = (destination.duration / 60).floorToDouble();

    // Custom Markers
    // final startMarkerIcon = await getMarkerAssetImage();
    // final endMarkerIcon = await getNetworkImageMarker();

    final startMarkerIcon = await getStartCustomMarker( tripDuration.toInt(), 'My location' );
    final endMarkerIcon = await getEndCustomMarker( kms.toInt(), destination.endPlace.text );

    final startMarker = Marker(
      markerId: const MarkerId('startMarker'),
      position: destination.points.first,
      icon: startMarkerIcon,
      anchor: const Offset( 0.02, 1 ),
      // infoWindow: InfoWindow(
      //   title: 'Start',
      //   snippet: 'Kms: $kms, duration: $tripDuration min',
      // )
    );

    final endMarker = Marker(
      markerId: const MarkerId('endMarker'),
      position: destination.points.last,
      icon: endMarkerIcon,
      // anchor: const Offset(0, 0),
      // infoWindow: InfoWindow(
      //   title: destination.endPlace.text,
      //   snippet: destination.endPlace.placeName
      // )
    );

    final currentPolylines = Map<String, Polyline>.from( state.polylines );
    currentPolylines['destination'] = route;

    final currentMarkers = Map<String, Marker>.from( state.markers );
    currentMarkers['startMarker'] = startMarker;
    currentMarkers['endMarker'] = endMarker;

    add( DisplayCustomRouteEvent( polylines: currentPolylines, markers: currentMarkers ) );

    await Future.delayed( const Duration( milliseconds: 300 ) );
    _mapController?.showMarkerInfoWindow( const MarkerId('startMarker') );

    return;
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }

}
