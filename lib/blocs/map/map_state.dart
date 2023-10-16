part of 'map_bloc.dart';

class MapState extends Equatable {

  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool showPolylines;

  // Polylines
  final Map<String, Polyline> polylines;

  const MapState({
    this.isMapInitialized = false,
    this.isFollowingUser = true,
    this.showPolylines = true,
    Map<String, Polyline>? polylines
  }) : polylines = polylines ?? const {};

  @override
  List<Object> get props => [ isMapInitialized, isFollowingUser, polylines, showPolylines ];

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? showPolylines,
    Map<String, Polyline>? polylines
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    isFollowingUser: isFollowingUser ?? this.isFollowingUser,
    showPolylines: showPolylines ?? this.showPolylines,
    polylines: polylines ?? this.polylines,
  );

}
