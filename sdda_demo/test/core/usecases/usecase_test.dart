import 'package:flutter_test/flutter_test.dart';
import 'package:sdda_demo/core/usecases/usecase.dart';

void main() {
  group('NoParams', () {
    test('debe crear una instancia constante', () {
      const params = NoParams();
      expect(params, isA<NoParams>());
    });

    test('props debe ser una lista vacía', () {
      const params = NoParams();
      expect(params.props, isEmpty);
    });

    test('dos instancias deben ser iguales', () {
      const params1 = NoParams();
      const params2 = NoParams();
      expect(params1, equals(params2));
    });
  });
}
