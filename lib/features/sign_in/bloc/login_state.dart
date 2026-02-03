import 'package:equatable/equatable.dart';

/// Base class for all login states.
class LoginState extends Equatable {
  const LoginState({
    this.error = "",
    this.isLoading = false,
    this.isPasswordHidden = true,
    this.isLoggedInSuccess = false,
  });
  final String error;
  final bool isLoading;
  final bool isLoggedInSuccess;
  final bool isPasswordHidden;

  LoginState copyWith({
    String? error,
    bool? isLoading,
    bool? isLoggedInSuccess,
    bool? isPasswordHidden,
  }) {
    return LoginState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isLoggedInSuccess: isLoggedInSuccess ?? this.isLoggedInSuccess,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
    );
  }

  @override
  List<Object?> get props => [
    error,
    isLoading,
    isPasswordHidden,
    isLoggedInSuccess,
  ];
}
