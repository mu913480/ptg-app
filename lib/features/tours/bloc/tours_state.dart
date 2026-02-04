part of 'tours_bloc.dart';

abstract class ToursState {}

class ToursInitial extends ToursState {}

class ToursLoading extends ToursState {}

class ToursLoaded extends ToursState {
  final List<Tour> tours;

  ToursLoaded(this.tours);
}

class ToursError extends ToursState {
  final String message;

  ToursError(this.message);
}
