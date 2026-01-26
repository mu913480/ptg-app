import 'package:equatable/equatable.dart';

/// Base class for all login states.
class LoginState extends Equatable {
  const LoginState({
    this.error = "",
    this.isLoading = false,
    this.isPasswordHidden = true,
  });
  final String error;
  final bool isLoading;
  final bool isPasswordHidden;

  LoginState copyWith({
    String? error,
    bool? isLoading,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isPasswordHidden: isPasswordVisible ?? this.isPasswordHidden,
    );
  }

  @override
  List<Object?> get props => [error, isLoading, isPasswordHidden];
}
