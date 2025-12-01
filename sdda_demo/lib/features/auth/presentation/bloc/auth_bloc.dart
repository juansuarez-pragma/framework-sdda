import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC para gestión de Auth.
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final RegisterUseCase _registerUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  AuthBloc(
    this._loginUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase,
    this._registerUseCase,
    this._checkAuthStatusUseCase,
  ) : super(const AuthInitial()) {
    on<LoadAuth>(_onLoadAuth);
    on<RefreshAuth>(_onRefreshAuth);
  }

  Future<void> _onLoadAuth(
    LoadAuth event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _checkAuthStatusUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (isAuth) => emit(isAuth ? const AuthLoaded() : const AuthError('No autenticado')),
    );
  }

  Future<void> _onRefreshAuth(
    RefreshAuth event,
    Emitter<AuthState> emit,
  ) async {
    // Similar a load pero sin mostrar loading
    add(const LoadAuth());
  }
}
