import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/core/network/database_service.dart';
import 'package:ptg/core/network/mapbox_directions_service.dart';
import 'package:ptg/features/stops/models/stop_model.dart';

part 'stop_event.dart';
part 'stop_state.dart';

class StopBloc extends Bloc<StopEvent, StopState> {
  final DatabaseService _databaseService;
  final MapboxDirectionsService _directionsService;

  StopBloc({
    DatabaseService? databaseService,
    MapboxDirectionsService? directionsService,
  }) : _databaseService = databaseService ?? DatabaseService(),

       _directionsService = directionsService ?? MapboxDirectionsService(),
       super(StopState()) {
    on<LoadStops>(_onLoadStops);
    on<ToggleMapView>(_onToggleMapView);
    on<ChangeTileProvider>(_onChangeTileProvider);
    on<LoadRoutePolyline>(_onLoadRoutePolyline);
  }

  void _onChangeTileProvider(
    ChangeTileProvider event,
    Emitter<StopState> emit,
  ) {
    emit(state.copyWith(selectedTileId: event.providerId));
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

  Future<void> _onToggleMapView(
    ToggleMapView event,
    Emitter<StopState> emit,
  ) async {
    emit(state.copyWith(isMapview: !state.isMapview));
  }

  Future<void> _onLoadRoutePolyline(
    LoadRoutePolyline event,
    Emitter<StopState> emit,
  ) async {
    emit(state.copyWith(isRouteLoading: true));
    final coords = await _directionsService.getRouteCoordinates(event.stops);
    emit(state.copyWith(routeCoordinates: coords, isRouteLoading: false));
  }
}
