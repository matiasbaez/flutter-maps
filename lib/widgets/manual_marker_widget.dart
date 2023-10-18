
import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/blocs/blocs.dart';

class ManualMarkerWidget extends StatelessWidget {

  const ManualMarkerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
          ? const _ManualMarkerBody()
          : const SizedBox();
      },
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {

  const _ManualMarkerBody({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [

          // Cancel button
          const Positioned(
            top: 70,
            left: 20,
            child: _BtnBack()
          ),

          // Marker
          Center(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: BounceInDown(
                from: 100,
                child: const Icon( Icons.location_on_rounded, size: 50 )
              ),
            ),
          ),

          // Confirm button
          Positioned(
            bottom: 70,
            left: 40,
            child: FadeInUp(
              duration: const Duration( milliseconds: 300 ),
              child: MaterialButton(
                minWidth: size.width - 120,
                color: Colors.black,
                elevation: 0,
                height: 50,
                shape: const StadiumBorder(),
                onPressed: () {

                },
                child: const Text( 'Confirmar destino', style: TextStyle( color: Colors.white, fontWeight: FontWeight.w300 ) ),
              ),
            ),
          )

        ],
      ),
    );
  }
}

class _BtnBack extends StatelessWidget {

  const _BtnBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon( Icons.arrow_back_ios_new, color: Colors.black ),
          onPressed: () {
            final searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
            searchBloc.add(DeactivateManualMarkerEvent());
          },
        ),
      ),
    );
  }
}