import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  GoogleMapController? _mapController;

  MapBloc() : super(const MapState()) {

    on<InitializeMapEvent>(_onInitMap);

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

}