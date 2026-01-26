import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg/features/sign_in/bloc/login_event.dart';
import 'package:ptg/features/sign_in/bloc/login_state.dart';
import 'package:ptg/network/auth_service.dart';

/// BLoC for handling login logic.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;

  LoginBloc({AuthService? authService})
    : _authService = authService ?? AuthService(),
      super(const LoginInitial()) {
    on<LoginEmailSubmitted>(_onEmailSubmitted);
    on<LoginGoogleSubmitted>(_onGoogleSubmitted);
  }

  Future<void> _onEmailSubmitted(
    LoginEmailSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    try {
      await _authService.signInWithEmail(
        email: event.email,
        password: event.password,
      );
      emit(const LoginSuccess());
    } on Exception catch (e) {
      emit(LoginFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onGoogleSubmitted(
    LoginGoogleSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    try {
      final success = await _authService.signInWithGoogle();
      if (success) {
        emit(const LoginSuccess());
      } else {
        emit(const LoginFailure('Google sign-in was cancelled'));
      }
    } on Exception catch (e) {
      emit(LoginFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
