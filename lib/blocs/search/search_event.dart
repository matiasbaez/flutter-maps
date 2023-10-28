part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {

  const SearchEvent();

  @override
  List<Object> get props => [];
}

class ActivateManualMarkerEvent extends SearchEvent {}
class DeactivateManualMarkerEvent extends SearchEvent {}

class NewPlacesFoundEvent extends SearchEvent {
  final List<Feature> places;

  const NewPlacesFoundEvent({ required this.places });
}

class AddToHistoryEvent extends SearchEvent {
  final Feature place;

  const AddToHistoryEvent({ required this.place });
}