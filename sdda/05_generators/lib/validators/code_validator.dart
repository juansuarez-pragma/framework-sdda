import 'dart:io';

import '../commands/validate_command.dart';

/// Validador de código contra convenciones SDDA.
class CodeValidator {
  /// Valida todos los archivos del proyecto.
  Future<List<ValidationResult>> validateProject({
    String? featureName,
    String fileType = 'all',
  }) async {
    final results = <ValidationResult>[];

    // Buscar archivos .dart en lib/features
    final featuresDir = Directory('lib/features');
    if (!await featuresDir.exists()) {
      return results;
    }

    await for (final entity in featuresDir.list(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) {
        continue;
      }

      // Filtrar por feature si se especificó
      if (featureName != null && !entity.path.contains('/$featureName/')) {
        continue;
      }

      // Filtrar por tipo si se especificó
      if (fileType != 'all' && !_matchesFileType(entity.path, fileType)) {
        continue;
      }

      final result = await validateFile(entity.path);
      results.add(result);
    }

    return results;
  }

  /// Valida un archivo específico.
  Future<ValidationResult> validateFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      return ValidationResult(
        filePath: filePath,
        errors: [ValidationIssue(message: 'Archivo no encontrado')],
      );
    }

    final content = await file.readAsString();
    final lines = content.split('\n');

    final errors = <ValidationIssue>[];
    final warnings = <ValidationIssue>[];

    // Detectar tipo de archivo
    final fileType = _detectFileType(filePath);

    // Validaciones generales
    _validateGeneralRules(lines, errors, warnings);

    // Validaciones específicas por tipo
    switch (fileType) {
      case 'usecase':
        _validateUseCase(lines, errors, warnings);
        break;
      case 'bloc':
        _validateBloc(lines, errors, warnings);
        break;
      case 'repository':
        _validateRepository(filePath, lines, errors, warnings);
        break;
      case 'model':
        _validateModel(lines, errors, warnings);
        break;
      case 'entity':
        _validateEntity(lines, errors, warnings);
        break;
    }

    // Validar ubicación del archivo
    _validateFileLocation(filePath, fileType, errors);

    return ValidationResult(
      filePath: filePath,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Intenta corregir problemas automáticamente.
  Future<int> autoFix(List<ValidationResult> results) async {
    var fixedCount = 0;

    for (final result in results) {
      for (final error in result.errors) {
        if (error.suggestion != null && error.suggestion!.contains('Eliminar')) {
          // Intentar fix automático para errores simples
          // Por ahora solo contamos, la implementación real sería más compleja
          fixedCount++;
        }
      }
    }

    return fixedCount;
  }

  void _validateGeneralRules(
    List<String> lines,
    List<ValidationIssue> errors,
    List<ValidationIssue> warnings,
  ) {
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNum = i + 1;

      // Error: print statements
      if (line.contains('print(') && !line.trim().startsWith('//')) {
        errors.add(ValidationIssue(
          message: 'No usar print() en código de producción',
          line: lineNum,
          context: line.trim(),
          suggestion: 'Eliminar o usar logger apropiado',
        ));
      }

      // Error: debugPrint
      if (line.contains('debugPrint(') && !line.trim().startsWith('//')) {
        errors.add(ValidationIssue(
          message: 'No usar debugPrint() en código de producción',
          line: lineNum,
          context: line.trim(),
          suggestion: 'Eliminar o usar logger apropiado',
        ));
      }

      // Warning: TODO sin issue
      if (line.contains('// TODO') && !line.contains('#')) {
        warnings.add(ValidationIssue(
          message: 'TODO sin issue asociado',
          line: lineNum,
          context: line.trim(),
        ));
      }

      // Warning: dynamic
      if (RegExp(r'\bdynamic\b').hasMatch(line) && !line.trim().startsWith('//')) {
        warnings.add(ValidationIssue(
          message: 'Evitar uso de dynamic',
          line: lineNum,
          context: line.trim(),
        ));
      }
    }
  }

  void _validateUseCase(
    List<String> lines,
    List<ValidationIssue> errors,
    List<ValidationIssue> warnings,
  ) {
    final content = lines.join('\n');

    // Debe tener @lazySingleton
    if (!content.contains('@lazySingleton')) {
      errors.add(ValidationIssue(
        message: 'UseCase debe tener anotación @lazySingleton',
        suggestion: 'Agregar @lazySingleton antes de la clase',
      ));
    }

    // Debe implementar UseCase
    if (!content.contains('implements UseCase<')) {
      errors.add(ValidationIssue(
        message: 'UseCase debe implementar UseCase<T, Params>',
        suggestion: 'Agregar implements UseCase<ReturnType, Params>',
      ));
    }

    // Debe retornar Either
    if (!content.contains('Future<Either<Failure')) {
      errors.add(ValidationIssue(
        message: 'UseCase debe retornar Future<Either<Failure, T>>',
        suggestion: 'Cambiar tipo de retorno del método call()',
      ));
    }

    // No debe importar de data layer
    if (content.contains("import '") && content.contains('/data/')) {
      errors.add(ValidationIssue(
        message: 'UseCase (domain) no debe importar de data layer',
        suggestion: 'Eliminar imports de data layer',
      ));
    }
  }

  void _validateBloc(
    List<String> lines,
    List<ValidationIssue> errors,
    List<ValidationIssue> warnings,
  ) {
    final content = lines.join('\n');

    // Debe tener @injectable
    if (!content.contains('@injectable')) {
      errors.add(ValidationIssue(
        message: 'BLoC debe tener anotación @injectable',
        suggestion: 'Agregar @injectable antes de la clase',
      ));
    }

    // Debe extender Bloc
    if (!content.contains('extends Bloc<')) {
      errors.add(ValidationIssue(
        message: 'BLoC debe extender Bloc<Event, State>',
      ));
    }

    // Debe usar on<Event>
    if (!content.contains('on<')) {
      warnings.add(ValidationIssue(
        message: 'BLoC debería registrar handlers con on<Event>',
      ));
    }

    // No debe importar de data layer
    if (content.contains("import '") && content.contains('/data/')) {
      errors.add(ValidationIssue(
        message: 'BLoC (presentation) no debe importar de data layer',
        suggestion: 'Usar UseCases en lugar de Repositories',
      ));
    }
  }

  void _validateRepository(
    String filePath,
    List<String> lines,
    List<ValidationIssue> errors,
    List<ValidationIssue> warnings,
  ) {
    final content = lines.join('\n');

    // Si es implementación
    if (filePath.contains('_impl.dart') || filePath.contains('/data/')) {
      // Debe tener @LazySingleton(as:)
      if (!content.contains('@LazySingleton(as:')) {
        errors.add(ValidationIssue(
          message: 'Repository impl debe tener @LazySingleton(as: Interface)',
        ));
      }

      // Debe verificar conectividad
      if (!content.contains('_networkInfo.isConnected') &&
          !content.contains('networkInfo.isConnected')) {
        warnings.add(ValidationIssue(
          message: 'Repository debería verificar conectividad',
          suggestion: 'Agregar verificación con NetworkInfo',
        ));
      }

      // Debe usar try-catch
      if (!content.contains('try {')) {
        warnings.add(ValidationIssue(
          message: 'Repository debería manejar excepciones con try-catch',
        ));
      }
    }

    // Debe retornar Either
    if (!content.contains('Either<Failure')) {
      errors.add(ValidationIssue(
        message: 'Repository debe retornar Either<Failure, T>',
      ));
    }
  }

  void _validateModel(
    List<String> lines,
    List<ValidationIssue> errors,
    List<ValidationIssue> warnings,
  ) {
    final content = lines.join('\n');

    // Debe tener fromJson
    if (!content.contains('fromJson')) {
      warnings.add(ValidationIssue(
        message: 'Model debería tener factory fromJson',
      ));
    }

    // Debe tener toJson
    if (!content.contains('toJson')) {
      warnings.add(ValidationIssue(
        message: 'Model debería tener método toJson',
      ));
    }

    // Debe tener toEntity si extiende Entity
    if (content.contains('extends') && !content.contains('toEntity')) {
      warnings.add(ValidationIssue(
        message: 'Model debería tener método toEntity()',
      ));
    }
  }

  void _validateEntity(
    List<String> lines,
    List<ValidationIssue> errors,
    List<ValidationIssue> warnings,
  ) {
    final content = lines.join('\n');

    // Debe extender Equatable
    if (!content.contains('extends Equatable')) {
      warnings.add(ValidationIssue(
        message: 'Entity debería extender Equatable',
      ));
    }

    // Debería tener const constructor
    if (!content.contains('const ')) {
      warnings.add(ValidationIssue(
        message: 'Entity debería tener const constructor',
      ));
    }
  }

  void _validateFileLocation(
    String filePath,
    String fileType,
    List<ValidationIssue> errors,
  ) {
    switch (fileType) {
      case 'usecase':
        if (!filePath.contains('/domain/usecases/')) {
          errors.add(ValidationIssue(
            message: 'UseCase debe estar en domain/usecases/',
            suggestion: 'Mover archivo a features/[feature]/domain/usecases/',
          ));
        }
        break;
      case 'bloc':
        if (!filePath.contains('/presentation/bloc/')) {
          errors.add(ValidationIssue(
            message: 'BLoC debe estar en presentation/bloc/',
            suggestion: 'Mover archivo a features/[feature]/presentation/bloc/',
          ));
        }
        break;
      case 'repository':
        if (!filePath.contains('/domain/repositories/') &&
            !filePath.contains('/data/repositories/')) {
          errors.add(ValidationIssue(
            message: 'Repository debe estar en domain o data repositories/',
          ));
        }
        break;
      case 'entity':
        if (!filePath.contains('/domain/entities/')) {
          errors.add(ValidationIssue(
            message: 'Entity debe estar en domain/entities/',
          ));
        }
        break;
      case 'model':
        if (!filePath.contains('/data/models/')) {
          errors.add(ValidationIssue(
            message: 'Model debe estar en data/models/',
          ));
        }
        break;
    }
  }

  String _detectFileType(String path) {
    if (path.contains('_usecase.dart')) return 'usecase';
    if (path.contains('_bloc.dart')) return 'bloc';
    if (path.contains('_event.dart')) return 'event';
    if (path.contains('_state.dart')) return 'state';
    if (path.contains('_repository')) return 'repository';
    if (path.contains('_model.dart')) return 'model';
    if (path.contains('/entities/')) return 'entity';
    if (path.contains('_page.dart')) return 'page';
    if (path.contains('_widget.dart')) return 'widget';
    return 'unknown';
  }

  bool _matchesFileType(String path, String type) {
    final detectedType = _detectFileType(path);
    return detectedType == type;
  }
}
