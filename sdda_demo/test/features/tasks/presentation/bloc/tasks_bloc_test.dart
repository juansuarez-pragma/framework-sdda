import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdda_demo/core/error/failures.dart';
import 'package:sdda_demo/core/usecases/usecase.dart';
import 'package:sdda_demo/features/tasks/domain/entities/task.dart';
import 'package:sdda_demo/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:sdda_demo/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:sdda_demo/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:sdda_demo/features/tasks/presentation/bloc/tasks_event.dart';
import 'package:sdda_demo/features/tasks/presentation/bloc/tasks_state.dart';

class MockGetTasksUseCase extends Mock implements GetTasksUseCase {}

class MockCreateTaskUseCase extends Mock implements CreateTaskUseCase {}

void main() {
  late TasksBloc sut;
  late MockGetTasksUseCase mockGetTasksUseCase;
  late MockCreateTaskUseCase mockCreateTaskUseCase;

  setUp(() {
    mockGetTasksUseCase = MockGetTasksUseCase();
    mockCreateTaskUseCase = MockCreateTaskUseCase();
    sut = TasksBloc(mockGetTasksUseCase, mockCreateTaskUseCase);
  });

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const CreateTaskParams(title: '', description: ''),
    );
  });

  tearDown(() {
    sut.close();
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

  final tNewTask = Task(
    id: '3',
    title: 'New Task',
    description: 'New Description',
    isCompleted: false,
    createdAt: DateTime(2024, 1, 3),
  );

  test('estado inicial es TasksInitial', () {
    expect(sut.state, const TasksInitial());
  });

  group('LoadTasks', () {
    blocTest<TasksBloc, TasksState>(
      'emite [Loading, Loaded] cuando GetTasksUseCase tiene éxito',
      build: () {
        when(() => mockGetTasksUseCase(any()))
            .thenAnswer((_) async => Right(tTasks));
        return sut;
      },
      act: (bloc) => bloc.add(const LoadTasks()),
      expect: () => [
        const TasksLoading(),
        TasksLoaded(tTasks),
      ],
      verify: (_) {
        verify(() => mockGetTasksUseCase(const NoParams())).called(1);
      },
    );

    blocTest<TasksBloc, TasksState>(
      'emite [Loading, Error] cuando GetTasksUseCase falla',
      build: () {
        when(() => mockGetTasksUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Error')));
        return sut;
      },
      act: (bloc) => bloc.add(const LoadTasks()),
      expect: () => [
        const TasksLoading(),
        const TasksError('Error'),
      ],
    );

    blocTest<TasksBloc, TasksState>(
      'emite [Loading, Loaded] con lista vacía cuando no hay tareas',
      build: () {
        when(() => mockGetTasksUseCase(any()))
            .thenAnswer((_) async => const Right([]));
        return sut;
      },
      act: (bloc) => bloc.add(const LoadTasks()),
      expect: () => [
        const TasksLoading(),
        const TasksLoaded([]),
      ],
    );
  });

  group('RefreshTasks', () {
    blocTest<TasksBloc, TasksState>(
      'emite [Loaded] sin Loading cuando RefreshTasks tiene éxito',
      build: () {
        when(() => mockGetTasksUseCase(any()))
            .thenAnswer((_) async => Right(tTasks));
        return sut;
      },
      act: (bloc) => bloc.add(const RefreshTasks()),
      expect: () => [
        TasksLoaded(tTasks),
      ],
    );

    blocTest<TasksBloc, TasksState>(
      'emite [Error] cuando RefreshTasks falla',
      build: () {
        when(() => mockGetTasksUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Error refresh')));
        return sut;
      },
      act: (bloc) => bloc.add(const RefreshTasks()),
      expect: () => [
        const TasksError('Error refresh'),
      ],
    );
  });

  group('TasksEvent', () {
    test('LoadTasks props debe ser vacío', () {
      const event = LoadTasks();
      expect(event.props, isEmpty);
    });

    test('RefreshTasks props debe ser vacío', () {
      const event = RefreshTasks();
      expect(event.props, isEmpty);
    });

    test('CreateTask props debe contener title y description', () {
      const event = CreateTask(title: 'Test', description: 'Desc');
      expect(event.props, ['Test', 'Desc']);
    });

    test('dos CreateTask con mismos valores deben ser iguales', () {
      const event1 = CreateTask(title: 'Test', description: 'Desc');
      const event2 = CreateTask(title: 'Test', description: 'Desc');
      expect(event1, equals(event2));
    });
  });

  group('CreateTask', () {
    blocTest<TasksBloc, TasksState>(
      'emite [Loaded] con nueva tarea cuando CreateTaskUseCase tiene éxito',
      build: () {
        when(() => mockCreateTaskUseCase(any()))
            .thenAnswer((_) async => Right(tNewTask));
        return sut;
      },
      act: (bloc) => bloc.add(
        const CreateTask(title: 'New Task', description: 'New Description'),
      ),
      expect: () => [
        TasksLoaded([tNewTask]),
      ],
    );

    blocTest<TasksBloc, TasksState>(
      'agrega tarea a lista existente cuando ya hay tareas cargadas',
      build: () {
        when(() => mockGetTasksUseCase(any()))
            .thenAnswer((_) async => Right(tTasks));
        when(() => mockCreateTaskUseCase(any()))
            .thenAnswer((_) async => Right(tNewTask));
        return sut;
      },
      seed: () => TasksLoaded(tTasks),
      act: (bloc) => bloc.add(
        const CreateTask(title: 'New Task', description: 'New Description'),
      ),
      expect: () => [
        TasksLoaded([...tTasks, tNewTask]),
      ],
    );

    blocTest<TasksBloc, TasksState>(
      'emite [Error] cuando CreateTaskUseCase falla',
      build: () {
        when(() => mockCreateTaskUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Error creando')));
        return sut;
      },
      act: (bloc) => bloc.add(
        const CreateTask(title: 'New Task', description: 'New Description'),
      ),
      expect: () => [
        const TasksError('Error creando'),
      ],
    );
  });
}
