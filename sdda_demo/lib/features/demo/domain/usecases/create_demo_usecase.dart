import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/demo_repository.dart';

/// Caso de uso para create demo.
///
/// Retorna [Either<Failure, void>].
@lazySingleton
class CreateDemoUseCase implements UseCase<void, CreateDemoParams> {
  final DemoRepository _repository;

  /// Crea una instancia de [CreateDemoUseCase].
  CreateDemoUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(CreateDemoParams params) async {
    // Validaciones

    // Delegación al repository
    return _repository.createDemo(title: params.title);
  }
}

/// Parámetros para [CreateDemoUseCase].
class CreateDemoParams extends Equatable {
  /// title
  final String title;

  const CreateDemoParams({
    required this.title,
  });

  @override
  List<Object?> get props => [title];
}
