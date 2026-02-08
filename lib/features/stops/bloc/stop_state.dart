part of 'stop_bloc.dart';

class StopState {
  final List<Stop> stops;
  final String error;
  final int currentPage;
  final isMapview;
  final int? currentStop;
  final bool isLoading;
  final String selectedTileId;

  StopState({
    this.currentPage = 1,
    this.stops = const [],
    this.error = '',
    this.isMapview = true,
    this.currentStop,
    this.isLoading = false,
    this.selectedTileId = 'cartodb_voyager',
  });

  StopState copyWith({
    List<Stop>? stops,
    String? error,
    int? currentPage,
    bool? isMapview,
    int? currentStop,
    bool? isLoading,
    String? selectedTileId,
  }) {
    return StopState(
      stops: stops ?? this.stops,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      isMapview: isMapview ?? this.isMapview,
      currentStop: currentStop ?? this.currentStop,
      isLoading: isLoading ?? this.isLoading,
      selectedTileId: selectedTileId ?? this.selectedTileId,
    );
  }
}
