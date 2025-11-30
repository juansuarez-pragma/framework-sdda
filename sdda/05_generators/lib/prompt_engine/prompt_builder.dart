import 'dart:io';

import 'package:yaml/yaml.dart';

/// Constructor de prompts parametrizados para IA.
class PromptBuilder {
  /// Construye prompt para generar un UseCase.
  Future<String> buildUseCasePrompt({
    required String featureName,
    required String usecaseName,
    required String returnType,
    required String repositoryName,
    List<Map<String, dynamic>> params = const [],
    List<String> validations = const [],
  }) async {
    final buffer = StringBuffer();

    // Cargar contexto
    final contextFiles = await _loadContextFiles();

    buffer.writeln('## Contexto del Proyecto');
    buffer.writeln();
    buffer.writeln('### Arquitectura');
    buffer.writeln('```');
    buffer.writeln(contextFiles['architecture'] ?? 'No disponible');
    buffer.writeln('```');
    buffer.writeln();
    buffer.writeln('### Convenciones');
    buffer.writeln('```');
    buffer.writeln(contextFiles['conventions'] ?? 'No disponible');
    buffer.writeln('```');
    buffer.writeln();

    buffer.writeln('## Tarea');
    buffer.writeln('Genera un UseCase llamado `${usecaseName}UseCase` para el feature `$featureName`.');
    buffer.writeln();

    buffer.writeln('## Especificación');
    buffer.writeln();
    buffer.writeln('### Información Base');
    buffer.writeln('- **Feature**: $featureName');
    buffer.writeln('- **Nombre UseCase**: ${usecaseName}UseCase');
    buffer.writeln('- **Tipo de Retorno**: Either<Failure, $returnType>');
    buffer.writeln('- **Repository**: $repositoryName');
    buffer.writeln();

    if (params.isNotEmpty) {
      buffer.writeln('### Parámetros');
      for (final param in params) {
        buffer.writeln('- `${param['name']}` (${param['type']})');
        if (param['validation'] != null) {
          buffer.writeln('  - Validación: ${param['validation']}');
        }
      }
      buffer.writeln();
    }

    if (validations.isNotEmpty) {
      buffer.writeln('### Validaciones');
      for (final validation in validations) {
        buffer.writeln('- $validation');
      }
      buffer.writeln();
    }

    buffer.writeln('## Archivo a Generar');
    buffer.writeln('`lib/features/$featureName/domain/usecases/${_toSnakeCase(usecaseName)}_usecase.dart`');
    buffer.writeln();

    buffer.writeln('## Requisitos');
    buffer.writeln('1. Usar anotación `@lazySingleton`');
    buffer.writeln('2. Implementar `UseCase<$returnType, ${usecaseName}Params>`');
    buffer.writeln('3. Constructor recibiendo `$repositoryName`');
    buffer.writeln('4. Retornar `Future<Either<Failure, $returnType>>`');
    buffer.writeln('5. Documentación con `///`');
    if (params.isNotEmpty) {
      buffer.writeln('6. Clase `${usecaseName}Params` extendiendo `Equatable`');
    }
    buffer.writeln();

    buffer.writeln('## Patrón de Referencia');
    buffer.writeln('Seguir el patrón de: `sdda/03_context/patterns/examples/example_usecase.dart`');

    return buffer.toString();
  }

  /// Construye prompt para generar un BLoC.
  Future<String> buildBlocPrompt({
    required String featureName,
    required String blocName,
    List<String> usecases = const [],
    List<String> events = const [],
    bool supportsPagination = false,
  }) async {
    final buffer = StringBuffer();

    buffer.writeln('## Tarea');
    buffer.writeln('Genera un BLoC completo llamado `${blocName}Bloc` para el feature `$featureName`.');
    buffer.writeln();

    buffer.writeln('## Especificación');
    buffer.writeln();
    buffer.writeln('### Información Base');
    buffer.writeln('- **Feature**: $featureName');
    buffer.writeln('- **Nombre BLoC**: ${blocName}Bloc');
    buffer.writeln('- **Soporta Paginación**: $supportsPagination');
    buffer.writeln();

    if (usecases.isNotEmpty) {
      buffer.writeln('### UseCases');
      for (final usecase in usecases) {
        buffer.writeln('- `$usecase`');
      }
      buffer.writeln();
    }

    if (events.isNotEmpty) {
      buffer.writeln('### Eventos');
      for (final event in events) {
        buffer.writeln('- `$event`');
      }
      buffer.writeln();
    }

    buffer.writeln('## Archivos a Generar');
    buffer.writeln('1. `lib/features/$featureName/presentation/bloc/${featureName}_event.dart`');
    buffer.writeln('2. `lib/features/$featureName/presentation/bloc/${featureName}_state.dart`');
    buffer.writeln('3. `lib/features/$featureName/presentation/bloc/${featureName}_bloc.dart`');
    buffer.writeln();

    buffer.writeln('## Requisitos');
    buffer.writeln('1. Events: `sealed class` con `extends Equatable`');
    buffer.writeln('2. States: `sealed class` con `extends Equatable`');
    buffer.writeln('3. BLoC: `@injectable`, registrar handlers con `on<Event>`');
    buffer.writeln('4. Usar `result.fold()` para manejar Either');
    buffer.writeln();

    buffer.writeln('## Patrón de Referencia');
    buffer.writeln('Seguir el patrón de: `sdda/03_context/patterns/examples/example_bloc.dart`');

    return buffer.toString();
  }

  /// Construye prompt para generar un Repository.
  Future<String> buildRepositoryPrompt({
    required String featureName,
    required String repositoryName,
    List<Map<String, dynamic>> methods = const [],
    bool hasLocalDataSource = true,
    bool hasRemoteDataSource = true,
  }) async {
    final buffer = StringBuffer();

    buffer.writeln('## Tarea');
    buffer.writeln('Genera el Repository `${repositoryName}Repository` para el feature `$featureName`.');
    buffer.writeln();

    buffer.writeln('## Especificación');
    buffer.writeln();
    buffer.writeln('### Información Base');
    buffer.writeln('- **Feature**: $featureName');
    buffer.writeln('- **Repository**: ${repositoryName}Repository');
    buffer.writeln('- **DataSource Local**: $hasLocalDataSource');
    buffer.writeln('- **DataSource Remoto**: $hasRemoteDataSource');
    buffer.writeln();

    if (methods.isNotEmpty) {
      buffer.writeln('### Métodos');
      for (final method in methods) {
        buffer.writeln('#### ${method['name']}');
        buffer.writeln('- Retorno: `Either<Failure, ${method['return_type']}>`');
        if (method['description'] != null) {
          buffer.writeln('- Descripción: ${method['description']}');
        }
      }
      buffer.writeln();
    }

    buffer.writeln('## Archivos a Generar');
    buffer.writeln('1. Interface: `lib/features/$featureName/domain/repositories/${featureName}_repository.dart`');
    buffer.writeln('2. Implementación: `lib/features/$featureName/data/repositories/${featureName}_repository_impl.dart`');
    if (hasRemoteDataSource) {
      buffer.writeln('3. DataSource Remoto: `lib/features/$featureName/data/datasources/${featureName}_remote_datasource.dart`');
    }
    if (hasLocalDataSource) {
      buffer.writeln('4. DataSource Local: `lib/features/$featureName/data/datasources/${featureName}_local_datasource.dart`');
    }
    buffer.writeln();

    buffer.writeln('## Requisitos');
    buffer.writeln('1. Interface: clase abstracta, métodos retornan `Future<Either<Failure, T>>`');
    buffer.writeln('2. Implementación: `@LazySingleton(as: Interface)`');
    buffer.writeln('3. Verificar conectividad con `_networkInfo.isConnected`');
    buffer.writeln('4. Manejar excepciones con try-catch');
    buffer.writeln('5. Convertir Models a Entities');
    buffer.writeln();

    buffer.writeln('## Patrón de Referencia');
    buffer.writeln('Seguir el patrón de: `sdda/03_context/patterns/examples/example_repository.dart`');

    return buffer.toString();
  }

  /// Construye prompt para generar un feature completo.
  Future<String> buildFeaturePrompt({
    required String featureName,
    Map<String, dynamic>? specification,
  }) async {
    final buffer = StringBuffer();

    buffer.writeln('## Tarea');
    buffer.writeln('Genera el feature `$featureName` completo siguiendo Clean Architecture.');
    buffer.writeln();

    if (specification != null) {
      buffer.writeln('## Especificación');
      buffer.writeln('```yaml');
      buffer.writeln(specification.toString());
      buffer.writeln('```');
      buffer.writeln();
    }

    buffer.writeln('## Estructura a Generar');
    buffer.writeln('```');
    buffer.writeln('lib/features/$featureName/');
    buffer.writeln('├── data/');
    buffer.writeln('│   ├── datasources/');
    buffer.writeln('│   ├── models/');
    buffer.writeln('│   └── repositories/');
    buffer.writeln('├── domain/');
    buffer.writeln('│   ├── entities/');
    buffer.writeln('│   ├── repositories/');
    buffer.writeln('│   └── usecases/');
    buffer.writeln('└── presentation/');
    buffer.writeln('    ├── bloc/');
    buffer.writeln('    ├── pages/');
    buffer.writeln('    └── widgets/');
    buffer.writeln('```');
    buffer.writeln();

    buffer.writeln('## Orden de Generación');
    buffer.writeln('1. Entities (domain)');
    buffer.writeln('2. Repository Interface (domain)');
    buffer.writeln('3. UseCases (domain)');
    buffer.writeln('4. Models (data)');
    buffer.writeln('5. DataSources (data)');
    buffer.writeln('6. Repository Implementation (data)');
    buffer.writeln('7. BLoC (presentation)');
    buffer.writeln('8. Pages y Widgets (presentation)');
    buffer.writeln();

    buffer.writeln('## Patrones de Referencia');
    buffer.writeln('- UseCase: `sdda/03_context/patterns/examples/example_usecase.dart`');
    buffer.writeln('- BLoC: `sdda/03_context/patterns/examples/example_bloc.dart`');
    buffer.writeln('- Repository: `sdda/03_context/patterns/examples/example_repository.dart`');

    return buffer.toString();
  }

  /// Construye prompt para revisar código existente.
  Future<String> buildReviewPrompt({
    required String code,
    required String filePath,
    required String fileType,
  }) async {
    final buffer = StringBuffer();

    buffer.writeln('## Tarea');
    buffer.writeln('Revisa el siguiente código y verifica que cumple con las convenciones SDDA.');
    buffer.writeln();

    buffer.writeln('## Archivo');
    buffer.writeln('- **Ruta**: `$filePath`');
    buffer.writeln('- **Tipo**: $fileType');
    buffer.writeln();

    buffer.writeln('## Código a Revisar');
    buffer.writeln('```dart');
    buffer.writeln(code);
    buffer.writeln('```');
    buffer.writeln();

    buffer.writeln('## Checklist de Validación');
    buffer.writeln();

    switch (fileType) {
      case 'usecase':
        buffer.writeln('### UseCase');
        buffer.writeln('- [ ] Tiene anotación `@lazySingleton`');
        buffer.writeln('- [ ] Implementa `UseCase<T, Params>`');
        buffer.writeln('- [ ] Retorna `Future<Either<Failure, T>>`');
        buffer.writeln('- [ ] No importa de data layer');
        buffer.writeln('- [ ] Tiene documentación');
        break;
      case 'bloc':
        buffer.writeln('### BLoC');
        buffer.writeln('- [ ] Tiene anotación `@injectable`');
        buffer.writeln('- [ ] Extiende `Bloc<Event, State>`');
        buffer.writeln('- [ ] Usa `on<Event>` para handlers');
        buffer.writeln('- [ ] No importa de data layer');
        break;
      case 'repository':
        buffer.writeln('### Repository');
        buffer.writeln('- [ ] Interface es clase abstracta');
        buffer.writeln('- [ ] Implementación tiene `@LazySingleton(as:)`');
        buffer.writeln('- [ ] Verifica conectividad');
        buffer.writeln('- [ ] Maneja excepciones');
        buffer.writeln('- [ ] Retorna `Either<Failure, T>`');
        break;
    }

    buffer.writeln();
    buffer.writeln('## Formato de Respuesta');
    buffer.writeln('```');
    buffer.writeln('### Resultado: [APROBADO/RECHAZADO/CON OBSERVACIONES]');
    buffer.writeln();
    buffer.writeln('### Errores Críticos');
    buffer.writeln('1. [error y corrección]');
    buffer.writeln();
    buffer.writeln('### Warnings');
    buffer.writeln('1. [warning y sugerencia]');
    buffer.writeln();
    buffer.writeln('### Código Corregido (si aplica)');
    buffer.writeln('[código completo corregido]');
    buffer.writeln('```');

    return buffer.toString();
  }

  Future<Map<String, String>> _loadContextFiles() async {
    final files = <String, String>{};

    try {
      final archFile = File('sdda/03_context/architecture/ARCHITECTURE.md');
      if (await archFile.exists()) {
        files['architecture'] = await archFile.readAsString();
      }

      final convFile = File('sdda/03_context/conventions/CONVENTIONS.md');
      if (await convFile.exists()) {
        files['conventions'] = await convFile.readAsString();
      }
    } catch (e) {
      // Ignorar errores de lectura
    }

    return files;
  }

  String _toSnakeCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => '_${match.group(0)!.toLowerCase()}',
        )
        .replaceFirst(RegExp(r'^_'), '');
  }
}
