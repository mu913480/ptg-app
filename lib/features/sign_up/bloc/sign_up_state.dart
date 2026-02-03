import 'package:equatable/equatable.dart';

class SignUpState extends Equatable {
  final bool isLoading;
  final String? error;
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;
  final bool isSuccess;

  const SignUpState({
    this.isLoading = false,
    this.error,
    this.isPasswordHidden = true,
    this.isConfirmPasswordHidden = true,
    this.isSuccess = false,
  });

  SignUpState copyWith({
    bool? isLoading,
    String? error,
    bool? isPasswordHidden,
    bool? isConfirmPasswordHidden,
    bool? isSuccess,
  }) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isConfirmPasswordHidden:
          isConfirmPasswordHidden ?? this.isConfirmPasswordHidden,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    isPasswordHidden,
    isConfirmPasswordHidden,
    isSuccess,
  ];
}
