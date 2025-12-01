import 'package:equatable/equatable.dart';

/// Estados del AuthBloc.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Cargando datos
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Datos cargados exitosamente
class AuthLoaded extends AuthState {
  // Extender con información de usuario/token cuando se defina la estrategia.

  const AuthLoaded();

  // @override
  // List<Object?> get props => [items];
}

/// Error al cargar datos
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
