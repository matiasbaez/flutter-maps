import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/blocs/blocs.dart';

import 'package:maps/delegates/delegates.dart';
import 'package:maps/models/models.dart';

class SearchBarWidget extends StatelessWidget {

  const SearchBarWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return !state.displayManualMarker
          ? FadeInDown(
            duration: const Duration(milliseconds: 300),
            child: const _SearchBarBody()
          )
          : const SizedBox();
      },
    );
  }
}

class _SearchBarBody extends StatelessWidget {

  const _SearchBarBody({ Key? key }) : super(key: key);

  void onSearchResults(BuildContext context, SearchResult result) async {

    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    if ( result.manual ) {
      searchBloc.add(ActivateManualMarkerEvent());
      return;
    }

    if ( result.position != null ) {
      final destination = await searchBloc.getCoordsStartToEnd( locationBloc.state.lastKnownLocation!, result.position! );
      await mapBloc.drawPolylineRoute(destination);
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only( top: 10 ),
        padding: const EdgeInsets.symmetric( horizontal: 30 ),
        width: double.infinity,
        child: GestureDetector(
          onTap: () async {
            final result = await showSearch<SearchResult>(context: context, delegate: SearchDestinationDelegate());
            if (result == null) return;
            if (!context.mounted) return; // To fix "Don't use 'BuildContext's across async gaps."

            onSearchResults(context, result);
          },
          child: Container(
            padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 13 ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 5)
                )
              ]
            ),
            child: const Text('¿Dónde quieres ir?', style: TextStyle( color: Colors.black87 )),
          ),
        ),
      ),
    );
  }
}