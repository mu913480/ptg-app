import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/core/network/database_service.dart';
import 'package:ptg/features/stops/models/stop_model.dart';

part 'stop_event.dart';
part 'stop_state.dart';

class StopBloc extends Bloc<StopEvent, StopState> {
  final DatabaseService _databaseService;

  StopBloc({DatabaseService? databaseService})
    : _databaseService = databaseService ?? DatabaseService(),
      super(StopInitial()) {
    on<LoadStops>(_onLoadStops);
  }

  Future<void> _onLoadStops(LoadStops event, Emitter<StopState> emit) async {
    await _databaseService.getRecords<Stop>(
      tableName: 'stop',
      onLoading: () => emit(StopLoading()),
      onSuccess: (data) => emit(StopLoaded(data)),
      onError: (error) => emit(StopError(error.toString())),
      fromJson: (json) => Stop.fromJson(json),
      filter: (query) => query.eq('tour_id', event.tourId),
      orderBy: 'order',
      ascending: true,
    );
  }
}
