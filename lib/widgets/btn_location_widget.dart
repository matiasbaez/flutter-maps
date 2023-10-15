
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps/blocs/blocs.dart';
import 'package:maps/ui/ui.dart';

class BtnLocationWidget extends StatelessWidget {

  const BtnLocationWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only( bottom: 10 ),
      child: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        maxRadius: 25,
        child: IconButton(
          icon: const Icon( Icons.my_location_outlined ),
          onPressed: () {

            final location = locationBloc.state.lastKnownLocation;

            if (location == null) {
              final snackBar = CustomSnackBar(message: 'No hay ubicación');
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return;
            }

            mapBloc.moveCamera(location);
          },
        ),
      ),
    );
  }
}