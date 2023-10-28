import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps/blocs/blocs.dart';
import 'package:maps/views/views.dart';
import 'package:maps/widgets/widgets.dart';

class MapScreen extends StatefulWidget {

  const MapScreen({ Key? key }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late LocationBloc locationBloc;

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context, listen: false);
    // locationBloc.getCurrentPosition();
    locationBloc.startFollowingUser();
  }

  @override
  void dispose() {
    super.dispose();
    locationBloc.stopFollowingUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if (locationState.lastKnownLocation == null) {
            return const Center(child: Text('Espere por favor...'));
          }

          return BlocBuilder<MapBloc, MapState>(
            builder: (context, mapState) {

              Map<String, Polyline> polylines = Map<String, Polyline>.from(mapState.polylines);

              if ( !mapState.showPolylines ) {
                polylines.removeWhere((key, value) => key == 'route');
              }

              print(mapState.markers);

              return SingleChildScrollView(
                child: Stack(
                  children: [
                    MapView(
                      initiLocation: locationState.lastKnownLocation!,
                      polylines: polylines.values.toSet(),
                      markers: mapState.markers.values.toSet(),
                    ),

                    const SearchBarWidget(),

                    const ManualMarkerWidget(),
                  ],
                ),
              );
            },
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BtnTogglePolylines(),

          BtnFollowUserWidget(),

          BtnLocationWidget(),
        ],
      ),

    );
  }
}