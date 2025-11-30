import 'dart:io';

import 'package:yaml/yaml.dart';

import '../utils/string_utils.dart';
import 'usecase_generator.dart';
import 'bloc_generator.dart';
import 'repository_generator.dart';

/// Generador de features completos.
class FeatureGenerator {
  final String featureName;
  final String? specificationFile;
  Map<String, dynamic>? _spec;

  FeatureGenerator({
    required this.featureName,
    this.specificationFile,
  });

  /// Genera todos los archivos del feature.
  Future<List<File>> generate() async {
    final files = <File>[];

    // Cargar especificación si existe
    if (specificationFile != null) {
      final content = await File(specificationFile!).readAsString();
      _spec = Map<String, dynamic>.from(loadYaml(content) as Map);
    }

    // Crear estructura de carpetas
    await _createDirectoryStructure();

    // Generar entidades
    files.addAll(await _generateEntities());

    // Generar repository
    final repoGenerator = RepositoryGenerator(
      repositoryName: featureName.toPascalCase(),
      featureName: featureName,
      hasLocalDataSource: _spec?['has_local_datasource'] ?? true,
      hasRemoteDataSource: _spec?['has_remote_datasource'] ?? true,
      methods: _spec?['repository_methods'] ?? [],
    );
    files.addAll(await repoGenerator.generate());

    // Generar usecases
    files.addAll(await _generateUseCases());

    // Generar BLoC
    final blocGenerator = BlocGenerator(
      blocName: featureName.toPascalCase(),
      featureName: featureName,
      usecases: _getUseCaseNames(),
    );
    files.addAll(await blocGenerator.generate());

    // Generar page básica
    files.add(await _generatePage());

    return files;
  }

  /// Genera los tests del feature.
  Future<List<File>> generateTests() async {
    final files = <File>[];

    // Tests de UseCases
    for (final usecase in _spec?['usecases'] ?? []) {
      final generator = UseCaseGenerator(
        usecaseName: usecase['name'] as String,
        featureName: featureName,
        returnType: usecase['return_type'] as String? ?? 'void',
        repositoryName: '${featureName.toPascalCase()}Repository',
      );
      files.addAll(await generator.generateTests());
    }

    // Tests de BLoC
    final blocGenerator = BlocGenerator(
      blocName: featureName.toPascalCase(),
      featureName: featureName,
      usecases: _getUseCaseNames(),
    );
    files.addAll(await blocGenerator.generateTests());

    return files;
  }

  Future<void> _createDirectoryStructure() async {
    final directories = [
      'lib/features/$featureName/data/datasources',
      'lib/features/$featureName/data/models',
      'lib/features/$featureName/data/repositories',
      'lib/features/$featureName/domain/entities',
      'lib/features/$featureName/domain/repositories',
      'lib/features/$featureName/domain/usecases',
      'lib/features/$featureName/presentation/bloc',
      'lib/features/$featureName/presentation/pages',
      'lib/features/$featureName/presentation/widgets',
      'test/features/$featureName/data/repositories',
      'test/features/$featureName/domain/usecases',
      'test/features/$featureName/presentation/bloc',
    ];

    for (final dir in directories) {
      await Directory(dir).create(recursive: true);
    }
  }

  Future<List<File>> _generateEntities() async {
    final files = <File>[];
    final entities = _spec?['entities'] as List? ?? [];

    for (final entity in entities) {
      final entityName = entity['name'] as String;
      final properties = entity['properties'] as List? ?? [];

      final file = await _generateEntityFile(entityName, properties);
      files.add(file);

      // También generar el Model
      final modelFile = await _generateModelFile(entityName, properties);
      files.add(modelFile);
    }

    return files;
  }

  Future<File> _generateEntityFile(String name, List properties) async {
    final fileName = '${name.toSnakeCase()}.dart';
    final path = 'lib/features/$featureName/domain/entities/$fileName';

    final buffer = StringBuffer();
    buffer.writeln("import 'package:equatable/equatable.dart';");
    buffer.writeln();
    buffer.writeln('/// Entidad ${name}.');
    buffer.writeln('class $name extends Equatable {');

    for (final prop in properties) {
      buffer.writeln('  final ${prop['type']} ${prop['name']};');
    }

    buffer.writeln();
    buffer.writeln('  const $name({');
    for (final prop in properties) {
      final required = prop['required'] == true ? 'required ' : '';
      buffer.writeln('    ${required}this.${prop['name']},');
    }
    buffer.writeln('  });');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  List<Object?> get props => [${properties.map((p) => p['name']).join(', ')}];');
    buffer.writeln('}');

    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(buffer.toString());

    return file;
  }

  Future<File> _generateModelFile(String name, List properties) async {
    final fileName = '${name.toSnakeCase()}_model.dart';
    final path = 'lib/features/$featureName/data/models/$fileName';

    final buffer = StringBuffer();
    buffer.writeln("import '../../domain/entities/${name.toSnakeCase()}.dart';");
    buffer.writeln();
    buffer.writeln('/// Model para ${name} con serialización JSON.');
    buffer.writeln('class ${name}Model extends $name {');
    buffer.writeln();
    buffer.writeln('  const ${name}Model({');
    for (final prop in properties) {
      final required = prop['required'] == true ? 'required ' : '';
      buffer.writeln('    ${required}super.${prop['name']},');
    }
    buffer.writeln('  });');
    buffer.writeln();

    // fromJson
    buffer.writeln('  factory ${name}Model.fromJson(Map<String, dynamic> json) {');
    buffer.writeln('    return ${name}Model(');
    for (final prop in properties) {
      buffer.writeln("      ${prop['name']}: json['${prop['name']}'] as ${prop['type']},");
    }
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln();

    // toJson
    buffer.writeln('  Map<String, dynamic> toJson() {');
    buffer.writeln('    return {');
    for (final prop in properties) {
      buffer.writeln("      '${prop['name']}': ${prop['name']},");
    }
    buffer.writeln('    };');
    buffer.writeln('  }');
    buffer.writeln();

    // toEntity
    buffer.writeln('  $name toEntity() {');
    buffer.writeln('    return $name(');
    for (final prop in properties) {
      buffer.writeln('      ${prop['name']}: ${prop['name']},');
    }
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('}');

    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(buffer.toString());

    return file;
  }

  Future<List<File>> _generateUseCases() async {
    final files = <File>[];
    final usecases = _spec?['usecases'] as List? ?? [];

    for (final usecase in usecases) {
      final generator = UseCaseGenerator(
        usecaseName: usecase['name'] as String,
        featureName: featureName,
        returnType: usecase['return_type'] as String? ?? 'void',
        repositoryName: '${featureName.toPascalCase()}Repository',
        params: (usecase['params'] as List?)
                ?.map((p) => Map<String, dynamic>.from(p as Map))
                .toList() ??
            [],
      );
      files.addAll(await generator.generate());
    }

    return files;
  }

  Future<File> _generatePage() async {
    final pageName = featureName.toPascalCase();
    final fileName = '${featureName}_page.dart';
    final path = 'lib/features/$featureName/presentation/pages/$fileName';

    final buffer = StringBuffer();
    buffer.writeln("import 'package:flutter/material.dart';");
    buffer.writeln("import 'package:flutter_bloc/flutter_bloc.dart';");
    buffer.writeln();
    buffer.writeln("import '../bloc/${featureName}_bloc.dart';");
    buffer.writeln("import '../bloc/${featureName}_state.dart';");
    buffer.writeln();
    buffer.writeln('/// Página principal del feature ${pageName}.');
    buffer.writeln('class ${pageName}Page extends StatelessWidget {');
    buffer.writeln("  static const routeName = '/$featureName';");
    buffer.writeln();
    buffer.writeln('  const ${pageName}Page({super.key});');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  Widget build(BuildContext context) {');
    buffer.writeln('    return Scaffold(');
    buffer.writeln('      appBar: AppBar(');
    buffer.writeln("        title: const Text('$pageName'),");
    buffer.writeln('      ),');
    buffer.writeln('      body: BlocBuilder<${pageName}Bloc, ${pageName}State>(');
    buffer.writeln('        builder: (context, state) {');
    buffer.writeln('          return switch (state) {');
    buffer.writeln('            ${pageName}Initial() => const Center(');
    buffer.writeln("              child: Text('Inicial'),");
    buffer.writeln('            ),');
    buffer.writeln('            ${pageName}Loading() => const Center(');
    buffer.writeln('              child: CircularProgressIndicator(),');
    buffer.writeln('            ),');
    buffer.writeln('            ${pageName}Loaded() => const Center(');
    buffer.writeln("              child: Text('Cargado'),");
    buffer.writeln('            ),');
    buffer.writeln('            ${pageName}Error(:final message) => Center(');
    buffer.writeln('              child: Text(message),');
    buffer.writeln('            ),');
    buffer.writeln('          };');
    buffer.writeln('        },');
    buffer.writeln('      ),');
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('}');

    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(buffer.toString());

    return file;
  }

  List<String> _getUseCaseNames() {
    final usecases = _spec?['usecases'] as List? ?? [];
    return usecases.map((u) => '${u['name']}UseCase').toList();
  }
}
