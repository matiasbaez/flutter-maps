
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps/models/models.dart';
import 'package:maps/blocs/blocs.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {

  SearchDestinationDelegate() : super(
    searchFieldLabel: 'Buscar...'
  );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon( Icons.clear ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon( Icons.arrow_back_ios ),
      onPressed: () {
        final result = SearchResult(cancel: true);
        close(context, result);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    searchBloc.getPlacesByQuery( locationBloc.state.lastKnownLocation!, query );

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {

        final places = state.places;

        return ListView.separated(
          padding: const EdgeInsets.symmetric( vertical: 10 ),
          itemBuilder: (context, index) {
            final place = places[index];
            return ListTile(
              title: Text(place.text),
              subtitle: Text(place.placeName),
              leading: const Icon( Icons.place_outlined, color: Colors.black ),
              onTap: () {

                final result = SearchResult(
                  cancel: false,
                  manual: false,
                  position: LatLng( place.center[1], place.center[0] ), // Mapbox(longitud, latitud)
                  name: place.text,
                  description: place.placeName
                );

                searchBloc.add( AddToHistoryEvent( place: place ) );

                close(context, result);
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: places.length,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final history = searchBloc.state.history;

    return ListView(
      children: [
        ListTile(
          leading: const Icon( Icons.location_on_outlined, color: Colors.black, ),
          title: const Text( 'Colocar la ubicación manualmente', style: TextStyle( color:  Colors.black ) ),
          onTap: () {
            final result = SearchResult(cancel: false, manual: true);
            close(context, result);
          },
        ),

        ...history.map((place) => ListTile(
          leading: const Icon( Icons.history, color: Colors.black, ),
          title: Text(place.text),
          subtitle: Text(place.placeName),
          onTap: () {

            final result = SearchResult(
              cancel: false,
              manual: false,
              name: place.text,
              description: place.placeName,
              position: LatLng( place.center[1], place.center[0] )
            );

            close(context, result);
          },
        )).toList()
      ],
    );
  }

}