part of 'stop_bloc.dart';

class StopState {
  final List<Stop> stops;
  final String error;
  final int currentPage;
  final int? currentStop;
  final bool isLoading;

  StopState({
    this.currentPage = 1,
    this.stops = const [],
    this.error = '',
    this.currentStop,
    this.isLoading = false,
  });

  StopState copyWith({
    List<Stop>? stops,
    String? error,
    int? currentPage,
    int? currentStop,
    bool? isLoading,
  }) {
    return StopState(
      stops: stops ?? this.stops,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      currentStop: currentStop ?? this.currentStop,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
