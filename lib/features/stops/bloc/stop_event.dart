part of 'stop_bloc.dart';

abstract class StopEvent {}

class LoadStops extends StopEvent {
  final String tourId;

  LoadStops(this.tourId);
}

class ToggleMapView extends StopEvent {}

class ChangeTileProvider extends StopEvent {
  final String providerId;
  ChangeTileProvider(this.providerId);
}

class LoadRoutePolyline extends StopEvent {
  final List<Stop> stops;
  LoadRoutePolyline(this.stops);
}
