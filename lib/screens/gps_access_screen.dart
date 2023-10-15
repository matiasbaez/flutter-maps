import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps/blocs/blocs.dart';

class GPSAccessScreen extends StatelessWidget {
  const GPSAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: BlocBuilder<GpsBloc, GpsState>(
          builder: (context, state) {
            return !state.isGPSEnabled
              ? const _EnableGPSMessage()
              : const _RequestGPSAccess();
          },
        ),
      ),
    );
  }
}

class _EnableGPSMessage extends StatelessWidget {
  const _EnableGPSMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Debe de habilitar el GPS',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
    );
  }
}

class _RequestGPSAccess extends StatelessWidget {
  const _RequestGPSAccess({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Es necesario el acceso al GPS'),
        MaterialButton(
          color: Colors.black,
          shape: const StadiumBorder(),
          elevation: 0,
          splashColor: Colors.transparent,
          onPressed: () {
            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            gpsBloc.requestGPSAccess();
          },
          child: const Text(
            'Solicitar acceso',
            style: TextStyle(color: Colors.white)
          )
        )
      ],
    );
  }
}
