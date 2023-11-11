import 'package:animate_do/animate_do.dart';
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

              return Stack(
                children: [
                  MapView(
                    initiLocation: locationState.lastKnownLocation!,
                    polylines: polylines.values.toSet(),
                    markers: mapState.markers.values.toSet(),
                  ),

                  // const SearchBarWidget(),

                  // const ManualMarkerWidget(),

                  BottomSheetExample(state: mapState),

                ],
              );
            },
          );
        },
      ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: const Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     BtnTogglePolylines(),

      //     BtnFollowUserWidget(),

      //     BtnLocationWidget(),
      //   ],
      // ),

    );
  }
}

class BottomSheetExample extends StatelessWidget {

  final MapState state;

  const BottomSheetExample({
    super.key,
    required this.state
  });

  @override
  Widget build(BuildContext context) {

    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Listener(
          onPointerMove: (PointerMoveEvent event) {
            final mapBloc = BlocProvider.of<MapBloc>(context);
            print(scrollController.offset);
            print(state.sheetExpanded);
            if (scrollController.offset >= 0 && !state.sheetExpanded) {
              mapBloc.add(ToggleSheetExpandedEvent());
            } else if (scrollController.offset < 0 && state.sheetExpanded) {
              mapBloc.add(ToggleSheetExpandedEvent());
            }
          },
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F8FC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      final mapBloc = BlocProvider.of<MapBloc>(context);
                      mapBloc.add(ToggleSheetExpandedEvent());
                      print("object");
                    },
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
        
                  Column(
                    children: [
        
                      const UserInfoCard(),
        
                      if (!state.sheetExpanded) TripActionButton( state: state ),
        
                      if (state.sheetExpanded) ...[
                        FadeInUp(
                          duration: const Duration(seconds: 1),
                          child: Column(
                            children: [
                              const TripStops(),
        
                              const PaymentMethod(),
        
                              TripActionButton( state: state ),
                            ],
                          ),
                        )
                      ],
        
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage('https://placekitten.com/100/100'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'David',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            'Envio',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 22.0),
                        Text('4.5', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 18 )),
                      ],
                    ),
                    Text(
                      'Envio',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16.0),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F8FC),
                borderRadius: BorderRadius.circular(5)
              ),
              padding: const EdgeInsets.all(10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '5 min',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(height: 4.0),
                      Text('Duración del envio'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Gs. 9.240',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(height: 4.0),
                      Text('GANANCIA'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TripActionButton extends StatelessWidget {

  final MapState state;

  const TripActionButton({
    super.key,
    required this.state
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Hero(
      tag: "trip-action-button",
      child: MaterialButton(
        onPressed: () {},
        elevation: 0,
        minWidth: size.width,
        child: Container(
          height: 50,
          margin: EdgeInsets.only(top: state.sheetExpanded ? 10 : 0),
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            // color: Colors.blue,
            color: Color(0xFF001040),
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: const Text('Finalizar', style: TextStyle( color: Colors.white, fontSize: 16 ))
        ),
      ),
    );
  }
}

class TimelineItem extends StatelessWidget {

  final int index;
  final String title;
  final String description;

  const TimelineItem({
    super.key,
    required this.index,
    required this.title,
    required this.description
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 10.0,
            height: 10.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
          ),

          const SizedBox(width: 16.0),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(description, style: const TextStyle( fontWeight: FontWeight.bold ) ),
            ],
          ),
        ],
      ),
    );
  }
}

class TripStops extends StatelessWidget {

  const TripStops({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric( horizontal: 10 ),
      color: Colors.white,
      child: const Column(
        children: [

          TimelineItem(index: 0, title: 'Punto de partida', description: 'Monseñor Juan Moleón Andreu n...'),
          TimelineItem(index: 1, title: 'Punto de llegada', description: 'Juan Z De San Martin 1624...'),

          // Punto de partida
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text('Punto de partida'),
          //         Text('Monseñor Juan Moleón Andreu n...', style: TextStyle( fontWeight: FontWeight.bold ) ),
          //       ],
          //     )
          //   ],
          // ),

          // SizedBox(height: 15),

          // // Punto de llegada
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text('Punto de llegada'),
          //         Text('Juan Z De San Martin 1624...', style: TextStyle( fontWeight: FontWeight.bold ) ),
          //       ],
          //     )
          //   ],
          // ),

          DeliverInfo(),
        ]
      ),
    );
  }
}

class DeliverInfo extends StatelessWidget {
  const DeliverInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 15, left: 15),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color(0XFFFFE5D9),
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      width: 250,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Número de edificio', style: TextStyle( color: Colors.orange )),
          SizedBox(height: 5),
          Text('32'),
          SizedBox(height: 8),
          Text('Piso/departamento', style: TextStyle( color: Colors.orange )),
          SizedBox(height: 3),
          Text('sexto'),
        ],
      ),
    );
  }
}

class PaymentMethod extends StatelessWidget {

  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 15 ),
      margin: const EdgeInsets.symmetric( horizontal: 20 ),
      color: Colors.white,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Método de pago'),
              Text('Corporativo', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 22 ) ),
            ],
          ),

          VerticalDivider(color: Colors.red, width: 15, thickness: 1),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Total'),
              Text('Gs. 14.000', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 22 ) ),
            ],
          )
        ],
      ),
    );
  }
}
