part of 'stop_bloc.dart';

abstract class StopEvent {}

class LoadStops extends StopEvent {
  final String tourId;

  LoadStops(this.tourId);
}

class ToggleMapView extends StopEvent {}

class ChangeMapStyle extends StopEvent {
  final String styleUri;
  ChangeMapStyle(this.styleUri);
}

class LoadRoutePolyline extends StopEvent {
  final List<Stop> stops;
  LoadRoutePolyline(this.stops);
}
