
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps/blocs/blocs.dart';

class MapView extends StatelessWidget {

  final LatLng initiLocation;
  final Set<Polyline> polylines;
  final Set<Marker> markers;

  const MapView({
    Key? key,
    required this.initiLocation,
    required this.polylines,
    required this.markers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final mapBloc = BlocProvider.of<MapBloc>(context);

    final CameraPosition initialCameraPosition = CameraPosition(
      target: initiLocation,
      zoom: 15
    );

    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        // To prevent camera move when the user changes the location manually
        onPointerMove: (event) => mapBloc.add(StopFollowingUserMapEvent()),
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,

          onMapCreated: (GoogleMapController controller) {
            mapBloc.add(InitializeMapEvent(controller: controller));
          },

          onCameraMove: (position) {
            mapBloc.mapCenter = position.target;
          },

          polylines: polylines,

          markers: markers,
        ),
      ),
    );
  }
}
