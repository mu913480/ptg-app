import 'package:equatable/equatable.dart';

/// Base class for all login states.
sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any login attempt.
final class LoginInitial extends LoginState {
  const LoginInitial();
}

/// State while login is in progress.
final class LoginLoading extends LoginState {
  const LoginLoading();
}

/// State when login succeeds.
final class LoginSuccess extends LoginState {
  const LoginSuccess();
}

/// State when login fails.
final class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}
