
import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {

  final accessToken = 'pk.eyJ1IjoibWF0aWFzYmFlejI1IiwiYSI6ImNqdXB1aDMxZjByaTg0NGxqZ2Jpdm9vMncifQ.rBB54IV-jv8KTVq2V8aQqg';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    options.queryParameters.addAll({
      'language': 'es',
      'limit': 10,
      'access_token': accessToken,
    });

    super.onRequest(options, handler);
  }

}
