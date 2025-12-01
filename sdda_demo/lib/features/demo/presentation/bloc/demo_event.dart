import 'package:equatable/equatable.dart';

/// Eventos del DemoBloc.
sealed class DemoEvent extends Equatable {
  const DemoEvent();

  @override
  List<Object?> get props => [];
}

/// Solicita cargar datos
class LoadDemo extends DemoEvent {
  const LoadDemo();
}

/// Crear elemento demo
class CreateDemo extends DemoEvent {
  final String title;

  const CreateDemo({required this.title});

  @override
  List<Object?> get props => [title];
}

/// Solicita refrescar datos
class RefreshDemo extends DemoEvent {
  const RefreshDemo();
}
