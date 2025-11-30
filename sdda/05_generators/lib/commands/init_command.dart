import 'dart:io';

import 'package:args/command_runner.dart';

import '../utils/console.dart';

/// Comando para inicializar SDDA en un proyecto existente.
///
/// Uso:
///   sdda init
///   sdda init --force
class InitCommand extends Command<int> {
  @override
  final name = 'init';

  @override
  final description = 'Inicializa SDDA en el proyecto actual';

  InitCommand() {
    argParser
      ..addFlag(
        'force',
        abbr: 'f',
        help: 'Sobrescribe archivos existentes',
        negatable: false,
      )
      ..addOption(
        'path',
        abbr: 'p',
        help: 'Ruta del proyecto Flutter',
        defaultsTo: '.',
      );
  }

  @override
  Future<int> run() async {
    final args = argResults!;
    final force = args['force'] as bool;
    final projectPath = args['path'] as String;

    Console.info('SDDA - Inicialización');
    Console.info('═' * 50);

    // Verificar que es un proyecto Flutter
    final pubspecFile = File('$projectPath/pubspec.yaml');
    if (!await pubspecFile.exists()) {
      Console.error('No se encontró pubspec.yaml');
      Console.error('Ejecuta este comando en la raíz de un proyecto Flutter');
      return 1;
    }

    Console.info('Proyecto Flutter detectado');
    Console.info('Inicializando estructura SDDA...\n');

    try {
      // Crear estructura de carpetas
      await _createDirectories(projectPath, force);

      // Crear archivos de configuración
      await _createConfigFiles(projectPath, force);

      // Crear archivos de contexto
      await _createContextFiles(projectPath, force);

      // Actualizar pubspec.yaml si es necesario
      await _updatePubspec(projectPath);

      Console.success('\n✓ SDDA inicializado exitosamente');
      Console.info('\nPróximos pasos:');
      Console.info('  1. Revisa sdda/sdda.yaml para configuración');
      Console.info('  2. Completa sdda/03_context/ con tu arquitectura');
      Console.info('  3. Usa "sdda generate feature <nombre>" para crear features');

      return 0;
    } catch (e) {
      Console.error('Error en inicialización: $e');
      return 1;
    }
  }

  Future<void> _createDirectories(String basePath, bool force) async {
    final directories = [
      'sdda',
      'sdda/01_specs',
      'sdda/02_contracts',
      'sdda/03_context',
      'sdda/03_context/architecture',
      'sdda/03_context/conventions',
      'sdda/03_context/patterns',
      'sdda/03_context/patterns/examples',
      'sdda/03_context/api',
      'sdda/03_context/schemas',
      'sdda/04_prompts',
      'sdda/04_prompts/system',
      'sdda/04_prompts/generation',
      'sdda/04_prompts/testing',
      'sdda/04_prompts/validation',
    ];

    for (final dir in directories) {
      final directory = Directory('$basePath/$dir');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
        Console.success('  Creado: $dir/');
      } else {
        Console.info('  Existe: $dir/');
      }
    }
  }

  Future<void> _createConfigFiles(String basePath, bool force) async {
    // sdda.yaml
    await _writeFileIfNotExists(
      '$basePath/sdda/sdda.yaml',
      _sddaYamlContent,
      force,
    );

    // analysis_options.yaml
    await _writeFileIfNotExists(
      '$basePath/sdda/analysis_options.yaml',
      _analysisOptionsContent,
      force,
    );
  }

  Future<void> _createContextFiles(String basePath, bool force) async {
    // README
    await _writeFileIfNotExists(
      '$basePath/sdda/README.md',
      _readmeContent,
      force,
    );

    // .gitkeep en carpetas vacías
    final emptyDirs = [
      'sdda/01_specs',
      'sdda/02_contracts',
      'sdda/03_context/api',
      'sdda/03_context/schemas',
    ];

    for (final dir in emptyDirs) {
      await _writeFileIfNotExists(
        '$basePath/$dir/.gitkeep',
        '',
        force,
      );
    }
  }

  Future<void> _updatePubspec(String basePath) async {
    Console.info('\nVerificando dependencias...');

    final pubspecFile = File('$basePath/pubspec.yaml');
    var content = await pubspecFile.readAsString();

    final requiredDeps = [
      'flutter_bloc',
      'equatable',
      'dartz',
      'get_it',
      'injectable',
      'dio',
    ];

    final missingDeps = <String>[];
    for (final dep in requiredDeps) {
      if (!content.contains('$dep:')) {
        missingDeps.add(dep);
      }
    }

    if (missingDeps.isNotEmpty) {
      Console.warning('Dependencias faltantes: ${missingDeps.join(', ')}');
      Console.info('Ejecuta: flutter pub add ${missingDeps.join(' ')}');
    } else {
      Console.success('Todas las dependencias están presentes');
    }
  }

  Future<void> _writeFileIfNotExists(
    String path,
    String content,
    bool force,
  ) async {
    final file = File(path);
    if (await file.exists() && !force) {
      Console.info('  Existe: ${file.path.split('/').last}');
      return;
    }

    await file.writeAsString(content);
    Console.success('  Creado: ${file.path.split('/').last}');
  }

  static const _sddaYamlContent = '''
# ═══════════════════════════════════════════════════════════════════════════════
# SDDA - Specification-Driven Development for AI Agents
# Configuración del proyecto
# ═══════════════════════════════════════════════════════════════════════════════

version: "1.0"
name: "Mi Proyecto Flutter"

# Configuración de proveedores de IA
ai_providers:
  default: "claude"
  providers:
    - name: "claude"
      model: "claude-sonnet-4-20250514"
    - name: "openai"
      model: "gpt-4"
    - name: "gemini"
      model: "gemini-pro"

# Arquitectura del proyecto
architecture:
  pattern: "clean_architecture"
  state_management: "bloc"
  di_framework: "get_it_injectable"

# Rutas de contexto
context:
  architecture: "03_context/architecture/ARCHITECTURE.md"
  conventions: "03_context/conventions/CONVENTIONS.md"
  patterns: "03_context/patterns/examples/"
  api_catalog: "03_context/api/"
  schemas: "03_context/schemas/"

# Testing
testing:
  unit:
    framework: "flutter_test"
    mocking: "mocktail"
    coverage_threshold: 80
  bloc:
    framework: "bloc_test"
  integration:
    framework: "integration_test"
  e2e:
    framework: "patrol"

# Quality gates
quality:
  require_tests: true
  require_documentation: true
  max_complexity: 10
  forbidden_patterns:
    - "print("
    - "debugPrint"
    - "// TODO"
''';

  static const _analysisOptionsContent = '''
include: package:lints/recommended.yaml

analyzer:
  errors:
    missing_required_param: error
    missing_return: error
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

linter:
  rules:
    - always_declare_return_types
    - always_put_required_named_parameters_first
    - avoid_dynamic_calls
    - avoid_print
    - avoid_type_to_string
    - cancel_subscriptions
    - close_sinks
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - prefer_final_locals
    - require_trailing_commas
    - sort_constructors_first
    - unawaited_futures
    - unnecessary_await_in_return
''';

  static const _readmeContent = '''
# SDDA - Specification-Driven Development for AI Agents

Este directorio contiene la configuración y contexto para generación de código con IA.

## Estructura

```
sdda/
├── sdda.yaml                 # Configuración principal
├── analysis_options.yaml     # Reglas de linting
├── 01_specs/                 # Especificaciones de features
├── 02_contracts/             # Tests como contratos
├── 03_context/               # Contexto para IA
│   ├── architecture/         # Documentación de arquitectura
│   ├── conventions/          # Convenciones de código
│   ├── patterns/             # Patrones de ejemplo
│   ├── api/                  # Catálogo de APIs
│   └── schemas/              # Esquemas de datos
└── 04_prompts/               # Templates de prompts
```

## Uso

```bash
# Generar un feature completo
sdda generate feature auth

# Generar un UseCase
sdda generate usecase Login --feature=auth

# Validar código
sdda validate --all

# Generar prompt para IA
sdda prompt usecase --feature=auth --name=Login
```

## Filosofía

**"La IA NO imagina código, la IA IMPLEMENTA especificaciones"**

Entrada: Especificación + Tests + Contexto → Salida: Código Validado
''';
}
