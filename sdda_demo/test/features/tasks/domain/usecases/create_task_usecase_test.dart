import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/features/tasks/domain/entities/task.dart';
import 'package:sdda_demo/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:sdda_demo/features/tasks/domain/usecases/create_task_usecase.dart';

class MockTasksRepository extends Mock implements TasksRepository {}

void main() {
  late CreateTaskUseCase sut;
  late MockTasksRepository mockRepository;

  setUp(() {
    mockRepository = MockTasksRepository();
    sut = CreateTaskUseCase(mockRepository);
  });

  final tTask = Task(
    id: '1',
    title: 'Nueva Tarea',
    description: 'Descripción de la tarea',
    isCompleted: false,
    createdAt: DateTime(2024, 1, 1),
  );

  const tParams = CreateTaskParams(
    title: 'Nueva Tarea',
    description: 'Descripción de la tarea',
  );

  group('CreateTaskUseCase', () {
    test('debe retornar Task cuando la creación es exitosa', () async {
      // Arrange
      when(() => mockRepository.createTask(
            title: any(named: 'title'),
            description: any(named: 'description'),
          )).thenAnswer((_) async => Right(tTask));

      // Act
      final result = await sut(tParams);

      // Assert
      expect(result, Right(tTask));
      verify(() => mockRepository.createTask(
            title: tParams.title,
            description: tParams.description,
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('debe retornar ServerFailure cuando el repository falla', () async {
      // Arrange
      const tFailure = ServerFailure('Error al crear tarea');
      when(() => mockRepository.createTask(
            title: any(named: 'title'),
            description: any(named: 'description'),
          )).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await sut(tParams);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.createTask(
            title: tParams.title,
            description: tParams.description,
          )).called(1);
    });

    test('debe retornar NetworkFailure cuando no hay conexión', () async {
      // Arrange
      const tFailure = NetworkFailure('Sin conexión a internet');
      when(() => mockRepository.createTask(
            title: any(named: 'title'),
            description: any(named: 'description'),
          )).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await sut(tParams);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.createTask(
            title: tParams.title,
            description: tParams.description,
          )).called(1);
    });
  });

  group('CreateTaskParams', () {
    test('props debe contener title y description', () {
      expect(tParams.props, [tParams.title, tParams.description]);
    });

    test('dos instancias con mismos valores deben ser iguales', () {
      const params1 = CreateTaskParams(
        title: 'Test',
        description: 'Desc',
      );
      const params2 = CreateTaskParams(
        title: 'Test',
        description: 'Desc',
      );

      expect(params1, equals(params2));
    });
  });
}
