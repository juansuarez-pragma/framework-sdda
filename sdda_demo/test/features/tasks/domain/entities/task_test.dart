import 'package:flutter_test/flutter_test.dart';
import 'package:sdda_demo/features/tasks/domain/entities/task.dart';

void main() {
  final tTask = Task(
    id: '1',
    title: 'Test Task',
    description: 'Test Description',
    isCompleted: false,
    createdAt: DateTime(2024, 1, 1),
  );

  group('Task', () {
    test('debe crear una instancia con los valores correctos', () {
      expect(tTask.id, '1');
      expect(tTask.title, 'Test Task');
      expect(tTask.description, 'Test Description');
      expect(tTask.isCompleted, false);
      expect(tTask.createdAt, DateTime(2024, 1, 1));
    });

    test('props debe contener todos los campos', () {
      expect(tTask.props, [
        '1',
        'Test Task',
        'Test Description',
        false,
        DateTime(2024, 1, 1),
      ]);
    });

    test('dos instancias con mismos valores deben ser iguales', () {
      final task1 = Task(
        id: '1',
        title: 'Task',
        description: 'Desc',
        isCompleted: false,
        createdAt: DateTime(2024, 1, 1),
      );
      final task2 = Task(
        id: '1',
        title: 'Task',
        description: 'Desc',
        isCompleted: false,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(task1, equals(task2));
    });

    group('copyWith', () {
      test('debe crear una copia con id modificado', () {
        final copied = tTask.copyWith(id: '2');
        expect(copied.id, '2');
        expect(copied.title, tTask.title);
        expect(copied.description, tTask.description);
        expect(copied.isCompleted, tTask.isCompleted);
        expect(copied.createdAt, tTask.createdAt);
      });

      test('debe crear una copia con title modificado', () {
        final copied = tTask.copyWith(title: 'Nuevo título');
        expect(copied.id, tTask.id);
        expect(copied.title, 'Nuevo título');
        expect(copied.description, tTask.description);
        expect(copied.isCompleted, tTask.isCompleted);
        expect(copied.createdAt, tTask.createdAt);
      });

      test('debe crear una copia con description modificado', () {
        final copied = tTask.copyWith(description: 'Nueva descripción');
        expect(copied.id, tTask.id);
        expect(copied.title, tTask.title);
        expect(copied.description, 'Nueva descripción');
        expect(copied.isCompleted, tTask.isCompleted);
        expect(copied.createdAt, tTask.createdAt);
      });

      test('debe crear una copia con isCompleted modificado', () {
        final copied = tTask.copyWith(isCompleted: true);
        expect(copied.id, tTask.id);
        expect(copied.title, tTask.title);
        expect(copied.description, tTask.description);
        expect(copied.isCompleted, true);
        expect(copied.createdAt, tTask.createdAt);
      });

      test('debe crear una copia con createdAt modificado', () {
        final newDate = DateTime(2024, 12, 31);
        final copied = tTask.copyWith(createdAt: newDate);
        expect(copied.id, tTask.id);
        expect(copied.title, tTask.title);
        expect(copied.description, tTask.description);
        expect(copied.isCompleted, tTask.isCompleted);
        expect(copied.createdAt, newDate);
      });

      test('debe crear una copia sin cambios cuando no se pasan parámetros', () {
        final copied = tTask.copyWith();
        expect(copied, equals(tTask));
      });

      test('debe crear una copia con múltiples campos modificados', () {
        final copied = tTask.copyWith(
          title: 'Nuevo',
          isCompleted: true,
        );
        expect(copied.id, tTask.id);
        expect(copied.title, 'Nuevo');
        expect(copied.description, tTask.description);
        expect(copied.isCompleted, true);
        expect(copied.createdAt, tTask.createdAt);
      });
    });
  });
}
