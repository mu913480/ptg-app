import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/core/network/database_service.dart';
import 'package:ptg/features/stops/models/stop_model.dart';

part 'stop_event.dart';
part 'stop_state.dart';

class StopBloc extends Bloc<StopEvent, StopState> {
  final DatabaseService _databaseService;

  StopBloc({DatabaseService? databaseService})
    : _databaseService = databaseService ?? DatabaseService(),
      super(StopState()) {
    on<LoadStops>(_onLoadStops);
  }

  Future<void> _onLoadStops(LoadStops event, Emitter<StopState> emit) async {
    await _databaseService.getRecords<Stop>(
      tableName: 'stop',
      onLoading: () => emit(state.copyWith(isLoading: true)),
      onSuccess: (data) => emit(state.copyWith(stops: data, isLoading: false)),
      onError: (error) => emit(
        state.copyWith(error: error.toString(), isLoading: false, stops: []),
      ),
      fromJson: (json) => Stop.fromJson(json),
      select:
          "id, name, tour_id, latitude, longitude, description, stop_images(image_url)",
      filter: (query) => query
          .eq('tour_id', event.tourId)
          .limit(1, referencedTable: 'stop_images'),
      orderBy: 'name',
      ascending: true,
    );
  }
}
