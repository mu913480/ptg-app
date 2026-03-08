part of 'stop_bloc.dart';

class StopState {
  final List<Stop> stops;
  final String error;
  final int currentPage;
  final bool isMapview;
  final int? currentStop;
  final bool isLoading;
  final String mapStyle;
  final List<List<double>> routeCoordinates;
  final bool isRouteLoading;

  StopState({
    this.currentPage = 1,
    this.stops = const [],
    this.error = '',
    this.isMapview = true,
    this.currentStop,
    this.isLoading = false,
    this.mapStyle = 'mapbox://styles/mapbox/streets-v12',
    this.routeCoordinates = const [],
    this.isRouteLoading = false,
  });

  StopState copyWith({
    List<Stop>? stops,
    String? error,
    int? currentPage,
    bool? isMapview,
    int? currentStop,
    bool? isLoading,
    String? mapStyle,
    List<List<double>>? routeCoordinates,
    bool? isRouteLoading,
  }) {
    return StopState(
      stops: stops ?? this.stops,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      isMapview: isMapview ?? this.isMapview,
      currentStop: currentStop ?? this.currentStop,
      isLoading: isLoading ?? this.isLoading,
      mapStyle: mapStyle ?? this.mapStyle,
      routeCoordinates: routeCoordinates ?? this.routeCoordinates,
      isRouteLoading: isRouteLoading ?? this.isRouteLoading,
    );
  }
}
