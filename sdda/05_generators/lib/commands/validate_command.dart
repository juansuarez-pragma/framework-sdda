import 'dart:io';

import 'package:args/command_runner.dart';

import '../validators/code_validator.dart';
import '../utils/console.dart';

/// Comando para validar código contra las convenciones SDDA.
///
/// Uso:
///   sdda validate <archivo.dart>
///   sdda validate --all
///   sdda validate --feature=auth
class ValidateCommand extends Command<int> {
  @override
  final name = 'validate';

  @override
  final description = 'Valida código contra las convenciones SDDA';

  @override
  final aliases = ['v', 'check'];

  ValidateCommand() {
    argParser
      ..addFlag(
        'all',
        abbr: 'a',
        help: 'Valida todos los archivos del proyecto',
        negatable: false,
      )
      ..addOption(
        'feature',
        abbr: 'f',
        help: 'Valida solo un feature específico',
      )
      ..addOption(
        'type',
        abbr: 't',
        help: 'Tipo de archivo a validar',
        allowed: ['usecase', 'bloc', 'repository', 'model', 'entity', 'all'],
        defaultsTo: 'all',
      )
      ..addFlag(
        'fix',
        help: 'Intenta corregir problemas automáticamente',
        negatable: false,
      );
  }

  @override
  Future<int> run() async {
    final args = argResults!;
    final files = args.rest;
    final validateAll = args['all'] as bool;
    final featureName = args['feature'] as String?;
    final fileType = args['type'] as String;
    final autoFix = args['fix'] as bool;

    Console.info('SDDA Code Validator');
    Console.info('═' * 50);

    try {
      final validator = CodeValidator();
      List<ValidationResult> results;

      if (validateAll) {
        Console.info('Validando todo el proyecto...\n');
        results = await validator.validateProject(
          featureName: featureName,
          fileType: fileType,
        );
      } else if (files.isNotEmpty) {
        Console.info('Validando archivos específicos...\n');
        results = [];
        for (final file in files) {
          final result = await validator.validateFile(file);
          results.add(result);
        }
      } else {
        Console.error('Especifica archivos o usa --all para validar todo');
        return 1;
      }

      // Mostrar resultados
      var totalErrors = 0;
      var totalWarnings = 0;
      var totalPassed = 0;

      for (final result in results) {
        if (result.errors.isEmpty && result.warnings.isEmpty) {
          totalPassed++;
          continue;
        }

        Console.info('\n${result.filePath}');

        for (final error in result.errors) {
          Console.error('  ✗ ${error.message}');
          if (error.line != null) {
            Console.error('    Línea ${error.line}: ${error.context}');
          }
          if (error.suggestion != null) {
            Console.info('    Sugerencia: ${error.suggestion}');
          }
          totalErrors++;
        }

        for (final warning in result.warnings) {
          Console.warning('  ⚠ ${warning.message}');
          if (warning.line != null) {
            Console.warning('    Línea ${warning.line}');
          }
          totalWarnings++;
        }
      }

      // Resumen
      Console.info('\n${'═' * 50}');
      Console.info('Resumen de Validación:');
      Console.info('  Archivos analizados: ${results.length}');
      Console.success('  Pasaron: $totalPassed');
      if (totalErrors > 0) {
        Console.error('  Errores: $totalErrors');
      }
      if (totalWarnings > 0) {
        Console.warning('  Warnings: $totalWarnings');
      }

      if (autoFix && totalErrors > 0) {
        Console.info('\nIntentando correcciones automáticas...');
        final fixedCount = await validator.autoFix(results);
        Console.success('Corregidos: $fixedCount problemas');
      }

      return totalErrors > 0 ? 1 : 0;
    } catch (e) {
      Console.error('Error en validación: $e');
      return 1;
    }
  }
}

/// Resultado de validación de un archivo.
class ValidationResult {
  final String filePath;
  final List<ValidationIssue> errors;
  final List<ValidationIssue> warnings;

  ValidationResult({
    required this.filePath,
    this.errors = const [],
    this.warnings = const [],
  });
}

/// Issue encontrado durante validación.
class ValidationIssue {
  final String message;
  final int? line;
  final String? context;
  final String? suggestion;

  ValidationIssue({
    required this.message,
    this.line,
    this.context,
    this.suggestion,
  });
}
