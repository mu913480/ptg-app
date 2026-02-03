import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/core/network/auth_service.dart';
import 'package:ptg/features/sign_up/bloc/sign_up_event.dart';
import 'package:ptg/features/sign_up/bloc/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthService _authService;

  SignUpBloc({AuthService? authService})
    : _authService = authService ?? AuthService(),
      super(const SignUpState()) {
    on<SignUpSubmitted>(_onSubmitted);
    on<SignUpPasswordToggled>(_onPasswordToggled);
    on<SignUpConfirmPasswordToggled>(_onConfirmPasswordToggled);
  }

  void _onPasswordToggled(
    SignUpPasswordToggled event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(isPasswordHidden: !state.isPasswordHidden));
  }

  void _onConfirmPasswordToggled(
    SignUpConfirmPasswordToggled event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(isConfirmPasswordHidden: !state.isConfirmPasswordHidden),
    );
  }

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    // Basic validation
    if (event.password != event.confirmPassword) {
      emit(state.copyWith(error: 'Passwords do not match'));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      await _authService.signUpWithEmail(
        email: event.email,
        password: event.password,
        data: {'full_name': event.name},
      );
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
