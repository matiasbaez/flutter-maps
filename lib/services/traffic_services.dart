
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps/services/services.dart';
import 'package:maps/models/models.dart';

class TrafficService {

  final Dio _dioTraffic;
  final Dio _dioPlaces;
  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  final String _basePlacesUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';

  TrafficService()
  : _dioTraffic = Dio()..interceptors.add( TrafficInterceptor() ),
   _dioPlaces = Dio()..interceptors.add( PlacesInterceptor() );

  Future<TrafficResponse> getCoordsStartToEnd( LatLng start, LatLng end) async {
    final coordString = '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
    final url = '$_baseTrafficUrl/driving/$coordString';

    final response = await _dioTraffic.get(url);
    final data = TrafficResponse.fromJson(response.data);

    return data;
  }

  Future<List<Feature>> getResultsByQuery( LatLng proximity, String query ) async {

    if (query.isEmpty) return [];

    final url = '$_basePlacesUrl/$query.json';

    final response = await _dioPlaces.get(url, queryParameters: {
      'proximity': '${proximity.longitude},${proximity.latitude}',
      'limit': 10
    });

    final data = PlacesResponse.fromJson(response.data);

    return data.features;
  }

  Future<Feature> getInfoByCoord( LatLng coords ) async {

    final url = '$_basePlacesUrl/${coords.longitude},${coords.latitude}.json';

    final response = await _dioPlaces.get(url, queryParameters: {
      'limit': 1
    });

    final data = PlacesResponse.fromJson(response.data);

    return data.features.first;
  }

}
