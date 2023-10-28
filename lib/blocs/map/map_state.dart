part of 'map_bloc.dart';

class MapState extends Equatable {

  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool showPolylines;

  // Polylines
  final Map<String, Polyline> polylines;

  // Markers
  final Map<String, Marker> markers;

  const MapState({
    this.isMapInitialized = false,
    this.isFollowingUser = true,
    this.showPolylines = true,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
  }) : polylines = polylines ?? const {},
    markers = markers ?? const {};

  @override
  List<Object> get props => [ isMapInitialized, isFollowingUser, polylines, showPolylines, markers ];

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? showPolylines,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    isFollowingUser: isFollowingUser ?? this.isFollowingUser,
    showPolylines: showPolylines ?? this.showPolylines,
    polylines: polylines ?? this.polylines,
    markers: markers ?? this.markers,
  );

}
