#!/usr/bin/env dart

/// CLI principal de SDDA (Specification-Driven Development for AI Agents)
///
/// Uso:
///   sdda generate <tipo> <nombre> [opciones]
///   sdda validate <archivo>
///   sdda prompt <template> [parámetros]
///   sdda init
///
library;

import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import '../lib/commands/generate_command.dart';
import '../lib/commands/validate_command.dart';
import '../lib/commands/prompt_command.dart';
import '../lib/commands/init_command.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner<int>(
    'sdda',
    'SDDA - Specification-Driven Development for AI Agents\n'
        'Framework para generación de código Flutter con IA.',
  )
    ..addCommand(GenerateCommand())
    ..addCommand(ValidateCommand())
    ..addCommand(PromptCommand())
    ..addCommand(InitCommand());

  // Opciones globales
  runner.argParser
    ..addFlag(
      'verbose',
      abbr: 'v',
      help: 'Muestra información detallada',
      negatable: false,
    )
    ..addFlag(
      'version',
      help: 'Muestra la versión de SDDA',
      negatable: false,
    )
    ..addOption(
      'config',
      abbr: 'c',
      help: 'Ruta al archivo de configuración sdda.yaml',
      defaultsTo: 'sdda/sdda.yaml',
    );

  try {
    final results = runner.parse(arguments);

    if (results['version'] as bool) {
      print('SDDA CLI v1.0.0');
      exit(0);
    }

    final exitCode = await runner.run(arguments) ?? 0;
    exit(exitCode);
  } on UsageException catch (e) {
    print('Error: ${e.message}\n');
    print(runner.usage);
    exit(64);
  } catch (e, stackTrace) {
    print('Error inesperado: $e');
    if (arguments.contains('-v') || arguments.contains('--verbose')) {
      print(stackTrace);
    }
    exit(1);
  }
}
