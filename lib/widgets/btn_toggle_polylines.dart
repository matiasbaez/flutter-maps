
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps/blocs/blocs.dart';

class BtnTogglePolylines extends StatelessWidget {

  const BtnTogglePolylines({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only( bottom: 10 ),
      child: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        maxRadius: 25,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return IconButton(
              icon: Icon( state.showPolylines ? Icons.visibility_off : Icons.visibility ),
              onPressed: () {
                mapBloc.add(ToggleMapPolylines());
              },
            );
          },
        ),
      ),
    );
  }
}