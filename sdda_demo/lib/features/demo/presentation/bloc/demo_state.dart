import 'package:equatable/equatable.dart';

/// Estados del DemoBloc.
sealed class DemoState extends Equatable {
  const DemoState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class DemoInitial extends DemoState {
  const DemoInitial();
}

/// Cargando datos
class DemoLoading extends DemoState {
  const DemoLoading();
}

/// Datos cargados exitosamente
class DemoLoaded extends DemoState {
  // Extender con payload de datos cuando se defina la fuente.

  const DemoLoaded();

  // @override
  // List<Object?> get props => [items];
}

/// Error al cargar datos
class DemoError extends DemoState {
  final String message;

  const DemoError(this.message);

  @override
  List<Object?> get props => [message];
}
