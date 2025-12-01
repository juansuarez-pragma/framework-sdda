import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/core/usecases/usecase.dart';
import 'package:sdda_demo/features/tasks/domain/entities/task.dart';
import 'package:sdda_demo/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:sdda_demo/features/tasks/domain/usecases/get_tasks_usecase.dart';

class MockTasksRepository extends Mock implements TasksRepository {}

void main() {
  late GetTasksUseCase sut;
  late MockTasksRepository mockRepository;

  setUp(() {
    mockRepository = MockTasksRepository();
    sut = GetTasksUseCase(mockRepository);
  });

  final tTasks = [
    Task(
      id: '1',
      title: 'Test Task 1',
      description: 'Description 1',
      isCompleted: false,
      createdAt: DateTime(2024, 1, 1),
    ),
    Task(
      id: '2',
      title: 'Test Task 2',
      description: 'Description 2',
      isCompleted: true,
      createdAt: DateTime(2024, 1, 2),
    ),
  ];

  group('GetTasksUseCase', () {
    test('debe retornar lista de tareas cuando el repository tiene éxito',
        () async {
      // Arrange
      when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Right(tTasks));

      // Act
      final result = await sut(const NoParams());

      // Assert
      expect(result, Right(tTasks));
      verify(() => mockRepository.getTasks()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('debe retornar ServerFailure cuando el repository falla', () async {
      // Arrange
      const tFailure = ServerFailure('Error del servidor');
      when(() => mockRepository.getTasks())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await sut(const NoParams());

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.getTasks()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('debe retornar NetworkFailure cuando no hay conexión', () async {
      // Arrange
      const tFailure = NetworkFailure('Sin conexión a internet');
      when(() => mockRepository.getTasks())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await sut(const NoParams());

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.getTasks()).called(1);
    });

    test('debe retornar lista vacía cuando no hay tareas', () async {
      // Arrange
      when(() => mockRepository.getTasks())
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await sut(const NoParams());

      // Assert
      expect(result, const Right(<Task>[]));
      verify(() => mockRepository.getTasks()).called(1);
    });
  });
}
