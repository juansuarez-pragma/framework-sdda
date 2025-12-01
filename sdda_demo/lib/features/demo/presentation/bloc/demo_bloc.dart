import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/create_demo_usecase.dart';
import '../../domain/usecases/load_demo_usecase.dart';
import '../../domain/usecases/refresh_demo_usecase.dart';
import 'demo_event.dart';
import 'demo_state.dart';

/// BLoC para gestión de Demo.
@injectable
class DemoBloc extends Bloc<DemoEvent, DemoState> {
  final LoadDemoUseCase _loadDemoUseCase;
  final CreateDemoUseCase _createDemoUseCase;
  final RefreshDemoUseCase _refreshDemoUseCase;

  DemoBloc(
    this._loadDemoUseCase,
    this._createDemoUseCase,
    this._refreshDemoUseCase,
  ) : super(const DemoInitial()) {
    on<LoadDemo>(_onLoadDemo);
    on<CreateDemo>(_onCreateDemo);
    on<RefreshDemo>(_onRefreshDemo);
  }

  Future<void> _onLoadDemo(
    LoadDemo event,
    Emitter<DemoState> emit,
  ) async {
    emit(const DemoLoading());

    final result = await _loadDemoUseCase(const NoParams());
    result.fold(
      (failure) => emit(DemoError(failure.message)),
      (_) => emit(const DemoLoaded()),
    );
  }

  Future<void> _onCreateDemo(
    CreateDemo event,
    Emitter<DemoState> emit,
  ) async {
    emit(const DemoLoading());

    final result =
        await _createDemoUseCase(CreateDemoParams(title: event.title));
    result.fold(
      (failure) => emit(DemoError(failure.message)),
      (_) => emit(const DemoLoaded()),
    );
  }

  Future<void> _onRefreshDemo(
    RefreshDemo event,
    Emitter<DemoState> emit,
  ) async {
    final result = await _refreshDemoUseCase(const NoParams());
    result.fold(
      (failure) => emit(DemoError(failure.message)),
      (_) => emit(const DemoLoaded()),
    );
  }
}
