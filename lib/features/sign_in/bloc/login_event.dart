import 'package:equatable/equatable.dart';

/// Base class for all login events.
sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when user submits email/password login.
final class LoginEmailSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginEmailSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event triggered when user initiates Google sign-in.
final class LoginGoogleSubmitted extends LoginEvent {
  const LoginGoogleSubmitted();
}
