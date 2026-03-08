import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/core/network/database_service.dart';
import 'package:ptg/features/tours/models/tour_model.dart';
import 'package:ptg/features/tours/repositories/tours_repository.dart';

part 'tours_event.dart';
part 'tours_state.dart';

class ToursBloc extends Bloc<ToursEvent, ToursState> {
  final ToursRepository _toursRepository;
  final DatabaseService _databaseService;

  ToursBloc({ToursRepository? toursRepository})
    : _toursRepository = toursRepository ?? ToursRepository(),
      _databaseService = DatabaseService(),
      super(ToursInitial()) {
    on<LoadTours>(_onLoadTours);
  }

  Future<void> _onLoadTours(LoadTours event, Emitter<ToursState> emit) async {
    emit(ToursLoading());
    await _databaseService.getRecords<Tour>(
      tableName: "tour",

      select: "*, tour_images(image_url), city(name, state(name)), stop(count)",
      fromJson: Tour.fromJson,
      onError: (e) {
        emit(ToursError(e.toString()));
      },

      onSuccess: (data) {
        emit(ToursLoaded(data));
      },
    );
  }
}
