part of 'stop_bloc.dart';

abstract class StopEvent {}

class LoadStops extends StopEvent {
  final String tourId;

  LoadStops(this.tourId);
}
