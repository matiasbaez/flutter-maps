
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/models/models.dart';

import 'package:maps/services/services.dart';

class TrafficService {

  final Dio _dioTraffic;
  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';

  TrafficService() : _dioTraffic = Dio()..interceptors.add( TrafficInterceptor() );

  Future<TrafficResponse> getCoordsStartToEnd( LatLng start, LatLng end) async {
    final coordString = '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
    final url = '$_baseTrafficUrl/driving/$coordString';

    final response = await _dioTraffic.get(url);
    final data = TrafficResponse.fromJson(response.data);

    return data;
  }

}
