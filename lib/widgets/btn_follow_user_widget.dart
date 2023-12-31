
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps/blocs/blocs.dart';

class BtnFollowUserWidget extends StatelessWidget {

  const BtnFollowUserWidget({ Key? key }) : super(key: key);

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
                  icon: Icon( state.isFollowingUser ? Icons.directions_run_rounded : Icons.hail_rounded ),
                  onPressed: () {
                    state.isFollowingUser
                      ? mapBloc.add(StopFollowingUserMapEvent())
                      : mapBloc.add(StartFollowingUserMapEvent());
                  },
                );
          },
        ),
      ),
    );
  }
}