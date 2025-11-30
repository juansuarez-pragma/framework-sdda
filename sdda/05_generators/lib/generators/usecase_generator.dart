import 'dart:io';

import '../utils/string_utils.dart';

/// Generador de código para UseCases.
class UseCaseGenerator {
  final String usecaseName;
  final String featureName;
  final String returnType;
  final String repositoryName;
  final List<Map<String, dynamic>> params;

  UseCaseGenerator({
    required this.usecaseName,
    required this.featureName,
    required this.returnType,
    required this.repositoryName,
    this.params = const [],
  });

  /// Genera los archivos del UseCase.
  Future<List<File>> generate() async {
    final files = <File>[];

    // Generar archivo del UseCase
    final usecaseFile = await _generateUseCaseFile();
    files.add(usecaseFile);

    return files;
  }

  /// Genera los tests del UseCase.
  Future<List<File>> generateTests() async {
    final files = <File>[];

    // Generar archivo de test
    final testFile = await _generateTestFile();
    files.add(testFile);

    return files;
  }

  Future<File> _generateUseCaseFile() async {
    final fileName = '${usecaseName.toSnakeCase()}_usecase.dart';
    final path = 'lib/features/$featureName/domain/usecases/$fileName';

    final content = _buildUseCaseContent();

    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);

    return file;
  }

  Future<File> _generateTestFile() async {
    final fileName = '${usecaseName.toSnakeCase()}_usecase_test.dart';
    final path = 'test/features/$featureName/domain/usecases/$fileName';

    final content = _buildTestContent();

    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);

    return file;
  }

  String _buildUseCaseContent() {
    final className = '${usecaseName}UseCase';
    final paramsClassName = params.isEmpty ? 'NoParams' : '${usecaseName}Params';

    final buffer = StringBuffer();

    // Imports
    buffer.writeln("import 'package:dartz/dartz.dart';");
    buffer.writeln("import 'package:equatable/equatable.dart';");
    buffer.writeln("import 'package:injectable/injectable.dart';");
    buffer.writeln();
    buffer.writeln("import '../../../../core/error/failures.dart';");
    buffer.writeln("import '../../../../core/usecases/usecase.dart';");
    buffer.writeln("import '../repositories/${featureName}_repository.dart';");
    if (returnType != 'void') {
      buffer.writeln("import '../entities/${returnType.toLowerCase()}.dart';");
    }
    buffer.writeln();

    // Documentación
    buffer.writeln('/// Caso de uso para ${usecaseName.toSpacedWords().toLowerCase()}.');
    buffer.writeln('///');
    buffer.writeln('/// Retorna [Either<Failure, $returnType>].');
    buffer.writeln('@lazySingleton');
    buffer.writeln('class $className implements UseCase<$returnType, $paramsClassName> {');
    buffer.writeln('  final $repositoryName _repository;');
    buffer.writeln();
    buffer.writeln('  /// Crea una instancia de [$className].');
    buffer.writeln('  $className(this._repository);');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  Future<Either<Failure, $returnType>> call($paramsClassName params) async {');

    // Validaciones
    if (params.isNotEmpty) {
      buffer.writeln('    // Validaciones');
      for (final param in params) {
        if (param['validation'] != null) {
          buffer.writeln('    // ${param['validation']}');
        }
      }
      buffer.writeln();
    }

    // Delegación
    buffer.writeln('    // Delegación al repository');
    final methodName = usecaseName.toCamelCase();
    if (params.isEmpty) {
      buffer.writeln('    return _repository.$methodName();');
    } else {
      final paramArgs = params.map((p) => '${p['name']}: params.${p['name']}').join(', ');
      buffer.writeln('    return _repository.$methodName($paramArgs);');
    }

    buffer.writeln('  }');
    buffer.writeln('}');

    // Clase Params si hay parámetros
    if (params.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('/// Parámetros para [$className].');
      buffer.writeln('class $paramsClassName extends Equatable {');

      for (final param in params) {
        buffer.writeln('  /// ${param['description'] ?? param['name']}');
        buffer.writeln('  final ${param['type']} ${param['name']};');
        buffer.writeln();
      }

      buffer.writeln('  const $paramsClassName({');
      for (final param in params) {
        final required = param['required'] == true ? 'required ' : '';
        buffer.writeln('    ${required}this.${param['name']},');
      }
      buffer.writeln('  });');
      buffer.writeln();
      buffer.writeln('  @override');
      buffer.writeln('  List<Object?> get props => [${params.map((p) => p['name']).join(', ')}];');
      buffer.writeln('}');
    }

    return buffer.toString();
  }

  String _buildTestContent() {
    final className = '${usecaseName}UseCase';
    final paramsClassName = params.isEmpty ? 'NoParams' : '${usecaseName}Params';

    final buffer = StringBuffer();

    // Imports
    buffer.writeln("import 'package:dartz/dartz.dart';");
    buffer.writeln("import 'package:flutter_test/flutter_test.dart';");
    buffer.writeln("import 'package:mocktail/mocktail.dart';");
    buffer.writeln();
    buffer.writeln("// Import del UseCase");
    buffer.writeln("// import 'package:app/features/$featureName/domain/usecases/${usecaseName.toSnakeCase()}_usecase.dart';");
    buffer.writeln();

    // Mock
    buffer.writeln('class Mock$repositoryName extends Mock implements $repositoryName {}');
    buffer.writeln();

    // Tests
    buffer.writeln('void main() {');
    buffer.writeln('  late $className sut;');
    buffer.writeln('  late Mock$repositoryName mockRepository;');
    buffer.writeln();

    // Test data
    buffer.writeln('  // Test data');
    if (returnType != 'void') {
      buffer.writeln("  final t${returnType} = $returnType(); // TODO: Inicializar");
    }
    buffer.writeln("  const tFailure = ServerFailure('Error de prueba');");
    buffer.writeln();

    // setUp
    buffer.writeln('  setUp(() {');
    buffer.writeln('    mockRepository = Mock$repositoryName();');
    buffer.writeln('    sut = $className(mockRepository);');
    buffer.writeln('  });');
    buffer.writeln();

    // Tests
    buffer.writeln("  group('$className', () {");

    // Test de éxito
    buffer.writeln("    group('casos de éxito', () {");
    buffer.writeln("      test('debe retornar $returnType cuando la operación es exitosa', () async {");
    buffer.writeln('        // Arrange');
    buffer.writeln('        when(() => mockRepository.${usecaseName.toCamelCase()}(');
    if (params.isNotEmpty) {
      for (final param in params) {
        buffer.writeln('          ${param['name']}: any(named: \'${param['name']}\'),');
      }
    }
    if (returnType != 'void') {
      buffer.writeln('        )).thenAnswer((_) async => Right(t$returnType));');
    } else {
      buffer.writeln('        )).thenAnswer((_) async => const Right(null));');
    }
    buffer.writeln();
    buffer.writeln('        // Act');
    if (params.isEmpty) {
      buffer.writeln('        final result = await sut(const NoParams());');
    } else {
      buffer.writeln('        final result = await sut(const $paramsClassName(');
      for (final param in params) {
        buffer.writeln("          ${param['name']}: 'test_value', // TODO: Valor de prueba");
      }
      buffer.writeln('        ));');
    }
    buffer.writeln();
    buffer.writeln('        // Assert');
    if (returnType != 'void') {
      buffer.writeln('        expect(result, Right(t$returnType));');
    } else {
      buffer.writeln('        expect(result, const Right(null));');
    }
    buffer.writeln('        verify(() => mockRepository.${usecaseName.toCamelCase()}(');
    if (params.isNotEmpty) {
      for (final param in params) {
        buffer.writeln('          ${param['name']}: any(named: \'${param['name']}\'),');
      }
    }
    buffer.writeln('        )).called(1);');
    buffer.writeln('      });');
    buffer.writeln('    });');

    // Test de error
    buffer.writeln();
    buffer.writeln("    group('casos de error', () {");
    buffer.writeln("      test('debe retornar Failure cuando el repository falla', () async {");
    buffer.writeln('        // Arrange');
    buffer.writeln('        when(() => mockRepository.${usecaseName.toCamelCase()}(');
    if (params.isNotEmpty) {
      for (final param in params) {
        buffer.writeln('          ${param['name']}: any(named: \'${param['name']}\'),');
      }
    }
    buffer.writeln('        )).thenAnswer((_) async => const Left(tFailure));');
    buffer.writeln();
    buffer.writeln('        // Act');
    if (params.isEmpty) {
      buffer.writeln('        final result = await sut(const NoParams());');
    } else {
      buffer.writeln('        final result = await sut(const $paramsClassName(');
      for (final param in params) {
        buffer.writeln("          ${param['name']}: 'test_value',");
      }
      buffer.writeln('        ));');
    }
    buffer.writeln();
    buffer.writeln('        // Assert');
    buffer.writeln('        expect(result, const Left(tFailure));');
    buffer.writeln('      });');
    buffer.writeln('    });');

    buffer.writeln('  });');
    buffer.writeln('}');

    return buffer.toString();
  }
}
