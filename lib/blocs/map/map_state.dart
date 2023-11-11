part of 'map_bloc.dart';

class MapState extends Equatable {

  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool showPolylines;
  final bool sheetExpanded;

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
    this.sheetExpanded = false
  }) : polylines = polylines ?? const {},
    markers = markers ?? const {};

  @override
  List<Object> get props => [ isMapInitialized, isFollowingUser, polylines, showPolylines, markers, sheetExpanded ];

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? showPolylines,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
    double? sheetPosition,
    bool? sheetExpanded,
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    isFollowingUser: isFollowingUser ?? this.isFollowingUser,
    showPolylines: showPolylines ?? this.showPolylines,
    sheetExpanded: sheetExpanded ?? this.sheetExpanded,
    polylines: polylines ?? this.polylines,
    markers: markers ?? this.markers,
  );

}
