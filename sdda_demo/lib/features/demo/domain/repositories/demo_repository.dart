import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

/// Contrato del repositorio de demo.
///
/// Define las operaciones disponibles sin detalles de implementación.
abstract class DemoRepository {

  /// null
  Future<Either<Failure, void>> loadDemo();

  /// null
  Future<Either<Failure, void>> createDemo({required String title});

  /// null
  Future<Either<Failure, void>> refreshDemo();
}
