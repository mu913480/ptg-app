import 'package:equatable/equatable.dart';

/// Base class for all login states.
class LoginState extends Equatable {
  const LoginState({
    this.error = "",
    this.isLoading = false,
    this.isPasswordVisible = false,
  });
  final String error;
  final bool isLoading;
  final bool isPasswordVisible;

  LoginState copyWith({
    String? error,
    bool? isLoading,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [error, isLoading, isPasswordVisible];
}
