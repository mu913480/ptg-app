import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/features/tours/models/tour_model.dart';
import 'package:ptg/features/tours/repositories/tours_repository.dart';

part 'tours_event.dart';
part 'tours_state.dart';

class ToursBloc extends Bloc<ToursEvent, ToursState> {
  final ToursRepository _toursRepository;

  ToursBloc({ToursRepository? toursRepository})
    : _toursRepository = toursRepository ?? ToursRepository(),
      super(ToursInitial()) {
    on<LoadTours>(_onLoadTours);
  }

  Future<void> _onLoadTours(LoadTours event, Emitter<ToursState> emit) async {
    emit(ToursLoading());
    try {
      final tours = await _toursRepository.getTours();
      emit(ToursLoaded(tours));
    } catch (e) {
      emit(ToursError(e.toString()));
    }
  }
}
