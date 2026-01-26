import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/features/sign_in/bloc/login_event.dart';
import 'package:ptg/features/sign_in/bloc/login_state.dart';
import 'package:ptg/network/auth_service.dart';

/// BLoC for handling login logic.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;

  LoginBloc({AuthService? authService})
    : _authService = authService ?? AuthService(),
      super(const LoginState()) {
    on<LoginEmailSubmitted>(_onEmailSubmitted);
    on<LoginGoogleSubmitted>(_onGoogleSubmitted);
    on<LoginPasswordToggled>(_onPasswordToggled);
  }

  Future<void> _onPasswordToggled(
    LoginPasswordToggled event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> _onEmailSubmitted(
    LoginEmailSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _authService.signInWithEmail(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(isLoading: false));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onGoogleSubmitted(
    LoginGoogleSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final success = await _authService.signInWithGoogle();
      if (success) {
        emit(state.copyWith(isLoading: false));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Google sign-in was cancelled',
          ),
        );
      }
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
