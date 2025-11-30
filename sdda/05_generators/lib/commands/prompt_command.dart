import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:yaml/yaml.dart';

import '../prompt_engine/prompt_builder.dart';
import '../utils/console.dart';

/// Comando para generar prompts parametrizados para IA.
///
/// Uso:
///   sdda prompt usecase --feature=auth --name=Login
///   sdda prompt bloc --feature=auth --name=Auth
///   sdda prompt review --file=path/to/file.dart
class PromptCommand extends Command<int> {
  @override
  final name = 'prompt';

  @override
  final description = 'Genera prompts parametrizados para IA';

  @override
  final aliases = ['p'];

  PromptCommand() {
    addSubcommand(_PromptUseCaseCommand());
    addSubcommand(_PromptBlocCommand());
    addSubcommand(_PromptRepositoryCommand());
    addSubcommand(_PromptFeatureCommand());
    addSubcommand(_PromptReviewCommand());
  }
}

class _PromptUseCaseCommand extends Command<int> {
  @override
  final name = 'usecase';

  @override
  final description = 'Genera prompt para crear un UseCase';

  _PromptUseCaseCommand() {
    argParser
      ..addOption(
        'feature',
        abbr: 'f',
        help: 'Nombre del feature',
        mandatory: true,
      )
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Nombre del UseCase',
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
        help: 'Nombre del repository',
      )
      ..addMultiOption(
        'params',
        abbr: 'p',
        help: 'Parámetros (formato: nombre:tipo)',
      )
      ..addFlag(
        'copy',
        help: 'Copia el prompt al portapapeles',
        negatable: false,
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Archivo de salida para el prompt',
      );
  }

  @override
  Future<int> run() async {
    final args = argResults!;
    final featureName = args['feature'] as String;
    final usecaseName = args['name'] as String;
    final returnType = args['return'] as String;
    final repository = args['repository'] as String?;
    final params = args['params'] as List<String>;
    final output = args['output'] as String?;

    final builder = PromptBuilder();

    // Parsear parámetros
    final parsedParams = params.map((p) {
      final parts = p.split(':');
      return {
        'name': parts[0],
        'type': parts.length > 1 ? parts[1] : 'String',
        'required': true,
      };
    }).toList();

    final prompt = await builder.buildUseCasePrompt(
      featureName: featureName,
      usecaseName: usecaseName,
      returnType: returnType,
      repositoryName: repository ?? '${_toPascalCase(featureName)}Repository',
      params: parsedParams,
    );

    if (output != null) {
      await File(output).writeAsString(prompt);
      Console.success('Prompt guardado en: $output');
    } else {
      Console.info('\n${'═' * 60}');
      Console.info('PROMPT PARA GENERAR USECASE');
      Console.info('${'═' * 60}\n');
      print(prompt);
      Console.info('\n${'═' * 60}');
    }

    return 0;
  }
}

class _PromptBlocCommand extends Command<int> {
  @override
  final name = 'bloc';

  @override
  final description = 'Genera prompt para crear un BLoC';

  _PromptBlocCommand() {
    argParser
      ..addOption(
        'feature',
        abbr: 'f',
        help: 'Nombre del feature',
        mandatory: true,
      )
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Nombre del BLoC',
        mandatory: true,
      )
      ..addMultiOption(
        'usecases',
        abbr: 'u',
        help: 'UseCases que utiliza',
      )
      ..addMultiOption(
        'events',
        abbr: 'e',
        help: 'Eventos del BLoC',
      )
      ..addFlag(
        'pagination',
        help: 'Incluye soporte de paginación',
        negatable: false,
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Archivo de salida',
      );
  }

  @override
  Future<int> run() async {
    final args = argResults!;
    final featureName = args['feature'] as String;
    final blocName = args['name'] as String;
    final usecases = args['usecases'] as List<String>;
    final events = args['events'] as List<String>;
    final pagination = args['pagination'] as bool;
    final output = args['output'] as String?;

    final builder = PromptBuilder();

    final prompt = await builder.buildBlocPrompt(
      featureName: featureName,
      blocName: blocName,
      usecases: usecases,
      events: events,
      supportsPagination: pagination,
    );

    if (output != null) {
      await File(output).writeAsString(prompt);
      Console.success('Prompt guardado en: $output');
    } else {
      Console.info('\n${'═' * 60}');
      Console.info('PROMPT PARA GENERAR BLOC');
      Console.info('${'═' * 60}\n');
      print(prompt);
      Console.info('\n${'═' * 60}');
    }

    return 0;
  }
}

class _PromptRepositoryCommand extends Command<int> {
  @override
  final name = 'repository';

  @override
  final description = 'Genera prompt para crear un Repository';

  @override
  final aliases = ['repo'];

  _PromptRepositoryCommand() {
    argParser
      ..addOption(
        'feature',
        abbr: 'f',
        help: 'Nombre del feature',
        mandatory: true,
      )
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Nombre del Repository',
        mandatory: true,
      )
      ..addMultiOption(
        'methods',
        abbr: 'm',
        help: 'Métodos (formato: nombre:retorno)',
      )
      ..addFlag(
        'local',
        help: 'Incluye datasource local',
        defaultsTo: true,
      )
      ..addFlag(
        'remote',
        help: 'Incluye datasource remoto',
        defaultsTo: true,
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Archivo de salida',
      );
  }

  @override
  Future<int> run() async {
    final args = argResults!;
    final featureName = args['feature'] as String;
    final repoName = args['name'] as String;
    final methods = args['methods'] as List<String>;
    final hasLocal = args['local'] as bool;
    final hasRemote = args['remote'] as bool;
    final output = args['output'] as String?;

    final builder = PromptBuilder();

    final parsedMethods = methods.map((m) {
      final parts = m.split(':');
      return {
        'name': parts[0],
        'return_type': parts.length > 1 ? parts[1] : 'void',
      };
    }).toList();

    final prompt = await builder.buildRepositoryPrompt(
      featureName: featureName,
      repositoryName: repoName,
      methods: parsedMethods,
      hasLocalDataSource: hasLocal,
      hasRemoteDataSource: hasRemote,
    );

    if (output != null) {
      await File(output).writeAsString(prompt);
      Console.success('Prompt guardado en: $output');
    } else {
      Console.info('\n${'═' * 60}');
      Console.info('PROMPT PARA GENERAR REPOSITORY');
      Console.info('${'═' * 60}\n');
      print(prompt);
      Console.info('\n${'═' * 60}');
    }

    return 0;
  }
}

class _PromptFeatureCommand extends Command<int> {
  @override
  final name = 'feature';

  @override
  final description = 'Genera prompt para crear un feature completo';

  _PromptFeatureCommand() {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Nombre del feature',
        mandatory: true,
      )
      ..addOption(
        'spec',
        abbr: 's',
        help: 'Archivo de especificación YAML',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Archivo de salida',
      );
  }

  @override
  Future<int> run() async {
    final args = argResults!;
    final featureName = args['name'] as String;
    final specFile = args['spec'] as String?;
    final output = args['output'] as String?;

    final builder = PromptBuilder();

    Map<String, dynamic>? spec;
    if (specFile != null) {
      final content = await File(specFile).readAsString();
      spec = Map<String, dynamic>.from(loadYaml(content) as Map);
    }

    final prompt = await builder.buildFeaturePrompt(
      featureName: featureName,
      specification: spec,
    );

    if (output != null) {
      await File(output).writeAsString(prompt);
      Console.success('Prompt guardado en: $output');
    } else {
      Console.info('\n${'═' * 60}');
      Console.info('PROMPT PARA GENERAR FEATURE');
      Console.info('${'═' * 60}\n');
      print(prompt);
      Console.info('\n${'═' * 60}');
    }

    return 0;
  }
}

class _PromptReviewCommand extends Command<int> {
  @override
  final name = 'review';

  @override
  final description = 'Genera prompt para revisar código existente';

  _PromptReviewCommand() {
    argParser
      ..addOption(
        'file',
        abbr: 'f',
        help: 'Archivo a revisar',
        mandatory: true,
      )
      ..addOption(
        'type',
        abbr: 't',
        help: 'Tipo de archivo',
        allowed: ['usecase', 'bloc', 'repository', 'model', 'entity', 'auto'],
        defaultsTo: 'auto',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Archivo de salida',
      );
  }

  @override
  Future<int> run() async {
    final args = argResults!;
    final filePath = args['file'] as String;
    var fileType = args['type'] as String;
    final output = args['output'] as String?;

    final file = File(filePath);
    if (!await file.exists()) {
      Console.error('Archivo no encontrado: $filePath');
      return 1;
    }

    // Auto-detectar tipo
    if (fileType == 'auto') {
      fileType = _detectFileType(filePath);
    }

    final code = await file.readAsString();
    final builder = PromptBuilder();

    final prompt = await builder.buildReviewPrompt(
      code: code,
      filePath: filePath,
      fileType: fileType,
    );

    if (output != null) {
      await File(output).writeAsString(prompt);
      Console.success('Prompt guardado en: $output');
    } else {
      Console.info('\n${'═' * 60}');
      Console.info('PROMPT PARA REVISAR CÓDIGO');
      Console.info('${'═' * 60}\n');
      print(prompt);
      Console.info('\n${'═' * 60}');
    }

    return 0;
  }

  String _detectFileType(String path) {
    if (path.contains('_usecase.dart')) return 'usecase';
    if (path.contains('_bloc.dart')) return 'bloc';
    if (path.contains('_repository')) return 'repository';
    if (path.contains('_model.dart')) return 'model';
    if (path.contains('/entities/')) return 'entity';
    return 'unknown';
  }
}

String _toPascalCase(String input) {
  return input
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join('');
}
