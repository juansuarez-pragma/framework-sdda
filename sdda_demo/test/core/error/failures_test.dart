import 'package:flutter_test/flutter_test.dart';
import 'package:sdda_demo/core/error/failures.dart';

void main() {
  group('Failures', () {
    group('ServerFailure', () {
      test('debe almacenar el mensaje correctamente', () {
        const failure = ServerFailure('Error del servidor');
        expect(failure.message, 'Error del servidor');
      });

      test('props debe contener el mensaje', () {
        const failure = ServerFailure('Error');
        expect(failure.props, ['Error']);
      });

      test('dos instancias con mismo mensaje deben ser iguales', () {
        const failure1 = ServerFailure('Error');
        const failure2 = ServerFailure('Error');
        expect(failure1, equals(failure2));
      });
    });

    group('CacheFailure', () {
      test('debe almacenar el mensaje correctamente', () {
        const failure = CacheFailure('Error de caché');
        expect(failure.message, 'Error de caché');
      });

      test('props debe contener el mensaje', () {
        const failure = CacheFailure('Cache error');
        expect(failure.props, ['Cache error']);
      });
    });

    group('NetworkFailure', () {
      test('debe almacenar el mensaje correctamente', () {
        const failure = NetworkFailure('Sin conexión');
        expect(failure.message, 'Sin conexión');
      });

      test('props debe contener el mensaje', () {
        const failure = NetworkFailure('Network error');
        expect(failure.props, ['Network error']);
      });
    });

    group('ValidationFailure', () {
      test('debe almacenar el mensaje correctamente', () {
        const failure = ValidationFailure('Campo inválido');
        expect(failure.message, 'Campo inválido');
      });

      test('props debe contener el mensaje', () {
        const failure = ValidationFailure('Validation error');
        expect(failure.props, ['Validation error']);
      });
    });
  });
}
