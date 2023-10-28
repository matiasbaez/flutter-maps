import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

import 'package:maps/services/services.dart';
import 'package:maps/models/models.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {

  TrafficService trafficService;

  SearchBloc({
    required this.trafficService
  }) : super(const SearchState()) {

    on<ActivateManualMarkerEvent>((event, emit) => emit(state.copyWith( displayManualMarker: true )));
    on<DeactivateManualMarkerEvent>((event, emit) => emit(state.copyWith( displayManualMarker: false )));

    on<NewPlacesFoundEvent>((event, emit) => emit(state.copyWith( places: event.places )));
    on<AddToHistoryEvent>((event, emit) {
      final history = [ event.place, ...state.history ];
      emit(state.copyWith( history: history ));
    });

  }

  Future<RouteDestination> getCoordsStartToEnd( LatLng start, LatLng end ) async {

    final response = await trafficService.getCoordsStartToEnd(start, end);

    final geometry = response.routes[0].geometry;
    final distance = response.routes[0].distance;
    final duration = response.routes[0].duration;

    // Decode
    final polyline = decodePolyline( geometry, accuracyExponent: 6 );
    final points = polyline.map( ( coord ) => LatLng(coord[0].toDouble(), coord[1].toDouble()) ).toList();

    return RouteDestination(
      points: points,
      duration: duration,
      distance: distance
    );
  }

  Future<List<Feature>> getPlacesByQuery( LatLng proximity, String query ) async {

    final places = await trafficService.getResultsByQuery(proximity, query);

    add( NewPlacesFoundEvent(places: places) );

    return places;

  }

}
