import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {

    on<ActivateManualMarkerEvent>((event, emit) {
      emit(state.copyWith( displayManualMarker: true ));
    });

    on<DeactivateManualMarkerEvent>((event, emit) {
      emit(state.copyWith( displayManualMarker: false ));
    });

  }
}
