part of 'stop_bloc.dart';

abstract class StopState {}

class StopInitial extends StopState {}

class StopLoading extends StopState {}

class StopLoaded extends StopState {
  final List<Stop> stops;

  StopLoaded(this.stops);
}

class StopError extends StopState {
  final String message;

  StopError(this.message);
}
