import 'package:equatable/equatable.dart';

/// Eventos del AuthBloc.
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Solicita cargar datos
class LoadAuth extends AuthEvent {
  const LoadAuth();
}

/// Solicita refrescar datos
class RefreshAuth extends AuthEvent {
  const RefreshAuth();
}
