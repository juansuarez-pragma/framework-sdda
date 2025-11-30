import 'dart:io';

import 'package:args/command_runner.dart';

import '../generators/usecase_generator.dart';
import '../generators/bloc_generator.dart';
import '../generators/repository_generator.dart';
import '../generators/feature_generator.dart';
import '../utils/console.dart';

/// Comando para generar código siguiendo los patrones SDDA.
///
/// Uso:
///   sdda generate usecase <nombre> --feature=<feature>
///   sdda generate bloc <nombre> --feature=<feature>
///   sdda generate repository <nombre> --feature=<feature>
///   sdda generate feature <nombre>
class GenerateCommand extends Command<int> {
  @override
  final name = 'generate';

  @override
  final description = 'Genera código siguiendo patrones SDDA';

  @override
  final aliases = ['g', 'gen'];

  GenerateCommand() {
    addSubcommand(_GenerateUseCaseCommand());
    addSubcommand(_GenerateBlocCommand());
    addSubcommand(_GenerateRepositoryCommand());
    addSubcommand(_GenerateFeatureCommand());
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SUBCOMANDOS
// ═══════════════════════════════════════════════════════════════════════════════

class _GenerateUseCaseCommand extends Command<int> {
  @override
  final name = 'usecase';

  @override
  final description = 'Genera un UseCase';

  @override
  final aliases = ['uc'];

  _GenerateUseCaseCommand() {
    argParser
      ..addOption(
        'feature',
        abbr: 'f',
        help: 'Nombre del feature',
        mandatory: true,
      )
      ..addOption(
        'return',
        abbr: 'r',
        help: 'Tipo de retorno',
        defaultsTo: 'void',
      )
      ..addOption(
        'repository',
        help: 'Nombre del repository a usar',
      )
      ..addFlag(
        'with-test',
        help: 'Genera también el archivo de test',
        defaultsTo: true,
      );
  }

  @override
  Future<int> run() async {
    final args = argResults!;
    final rest = args.rest;

    if (rest.isEmpty) {
      Console.error('Falta el nombre del UseCase');
      Console.info('Uso: sdda generate usecase <nombre> --feature=<feature>');
      return 1;
    }

    final usecaseName = rest.first;
    final featureName = args['feature'] as String;
    final returnType = args['return'] as String;
    final repositoryName = args['repository'] as String? ??
        '${_toPascalCase(featureName)}Repository';
    final withTest = args['with-test'] as bool;

    Console.info('Generando UseCase: $usecaseName');
    Console.info('  Feature: $featureName');
    Console.info('  Retorno: $returnType');
    Console.info('  Repository: $repositoryName');

    try {
      final generator = UseCaseGenerator(
        usecaseName: usecaseName,
        featureName: featureName,
        returnType: returnType,
        repositoryName: repositoryName,
      );

      final files = await generator.generate();

      for (final file in files) {
        Console.success('Creado: ${file.path}');
      }

      if (withTest) {
        final testFiles = await generator.generateTests();
        for (final file in testFiles) {
          Console.success('Creado: ${file.path}');
        }
      }

      Console.success('\n✓ UseCase generado exitosamente');
      return 0;
    } catch (e) {
      Console.error('Error generando UseCase: $e');
      return 1;
    }
  }
}

class _GenerateBlocCommand extends Command<int> {
  @override
  final name = 'bloc';

  @override
  final description = 'Genera un BLoC completo (bloc, events, states)';

  _GenerateBlocCommand() {
    argParser
      ..addOption(
        'feature',
        abbr: 'f',
        help: 'Nombre del feature',
        mandatory: true,
      )
      ..addMultiOption(
        'usecases',
        abbr: 'u',
        help: 'UseCases que utiliza el BLoC',
      )
      ..addFlag(
        'with-test',
        help: 'Genera también el archivo de test',
        defaultsTo: true,
      );
  }

  @override
  Future<int> run() async {
    final args = argResults!;
    final rest = args.rest;

    if (rest.isEmpty) {
      Console.error('Falta el nombre del BLoC');
      Console.info('Uso: sdda generate bloc <nombre> --feature=<feature>');
      return 1;
    }

    final blocName = rest.first;
    final featureName = args['feature'] as String;
    final usecases = args['usecases'] as List<String>;
    final withTest = args['with-test'] as bool;

    Console.info('Generando BLoC: $blocName');
    Console.info('  Feature: $featureName');
    Console.info('  UseCases: ${usecases.isEmpty ? "(ninguno)" : usecases.join(", ")}');

    try {
      final generator = BlocGenerator(
        blocName: blocName,
        featureName: featureName,
        usecases: usecases,
      );

      final files = await generator.generate();

      for (final file in files) {
        Console.success('Creado: ${file.path}');
      }

      if (withTest) {
        final testFiles = await generator.generateTests();
        for (final file in testFiles) {
          Console.success('Creado: ${file.path}');
        }
      }

      Console.success('\n✓ BLoC generado exitosamente');
      return 0;
    } catch (e) {
      Console.error('Error generando BLoC: $e');
      return 1;
    }
  }
}

class _GenerateRepositoryCommand extends Command<int> {
  @override
  final name = 'repository';

  @override
  final description = 'Genera Repository (interface e implementación)';

  @override
  final aliases = ['repo'];

  _GenerateRepositoryCommand() {
    argParser
      ..addOption(
        'feature',
        abbr: 'f',
        help: 'Nombre del feature',
        mandatory: true,
      )
      ..addFlag(
        'local',
        help: 'Incluir datasource local',
        defaultsTo: true,
      )
      ..addFlag(
        'remote',
        help: 'Incluir datasource remoto',
        defaultsTo: true,
      );
  }

  @override
  Future<int> run() async {
    final args = argResults!;
    final rest = args.rest;

    if (rest.isEmpty) {
      Console.error('Falta el nombre del Repository');
      Console.info('Uso: sdda generate repository <nombre> --feature=<feature>');
      return 1;
    }

    final repositoryName = rest.first;
    final featureName = args['feature'] as String;
    final hasLocal = args['local'] as bool;
    final hasRemote = args['remote'] as bool;

    Console.info('Generando Repository: $repositoryName');
    Console.info('  Feature: $featureName');
    Console.info('  DataSource Local: $hasLocal');
    Console.info('  DataSource Remoto: $hasRemote');

    try {
      final generator = RepositoryGenerator(
        repositoryName: repositoryName,
        featureName: featureName,
        hasLocalDataSource: hasLocal,
        hasRemoteDataSource: hasRemote,
      );

      final files = await generator.generate();

      for (final file in files) {
        Console.success('Creado: ${file.path}');
      }

      Console.success('\n✓ Repository generado exitosamente');
      return 0;
    } catch (e) {
      Console.error('Error generando Repository: $e');
      return 1;
    }
  }
}

class _GenerateFeatureCommand extends Command<int> {
  @override
  final name = 'feature';

  @override
  final description = 'Genera un feature completo con todas sus capas';

  _GenerateFeatureCommand() {
    argParser
      ..addOption(
        'spec',
        abbr: 's',
        help: 'Archivo de especificación YAML',
      )
      ..addFlag(
        'with-tests',
        help: 'Genera también los tests',
        defaultsTo: true,
      );
  }

  @override
  Future<int> run() async {
    final args = argResults!;
    final rest = args.rest;

    if (rest.isEmpty) {
      Console.error('Falta el nombre del feature');
      Console.info('Uso: sdda generate feature <nombre> [--spec=archivo.yaml]');
      return 1;
    }

    final featureName = rest.first;
    final specFile = args['spec'] as String?;
    final withTests = args['with-tests'] as bool;

    Console.info('Generando Feature: $featureName');
    if (specFile != null) {
      Console.info('  Spec: $specFile');
    }

    try {
      final generator = FeatureGenerator(
        featureName: featureName,
        specificationFile: specFile,
      );

      final files = await generator.generate();

      Console.info('\nArchivos generados:');
      for (final file in files) {
        Console.success('  ✓ ${file.path}');
      }

      if (withTests) {
        final testFiles = await generator.generateTests();
        Console.info('\nTests generados:');
        for (final file in testFiles) {
          Console.success('  ✓ ${file.path}');
        }
      }

      Console.success('\n✓ Feature "$featureName" generado exitosamente');
      return 0;
    } catch (e) {
      Console.error('Error generando feature: $e');
      return 1;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// UTILS
// ═══════════════════════════════════════════════════════════════════════════════

String _toPascalCase(String input) {
  return input
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join('');
}
