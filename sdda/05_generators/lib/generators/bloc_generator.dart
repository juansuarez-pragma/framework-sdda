import 'dart:io';

import '../utils/string_utils.dart';

/// Generador de código para BLoCs.
class BlocGenerator {
  final String blocName;
  final String featureName;
  final List<String> usecases;
  final List<Map<String, dynamic>> events;
  final List<Map<String, dynamic>> states;
  final bool supportsPagination;

  BlocGenerator({
    required this.blocName,
    required this.featureName,
    this.usecases = const [],
    this.events = const [],
    this.states = const [],
    this.supportsPagination = false,
  });

  /// Genera los archivos del BLoC.
  Future<List<File>> generate() async {
    final files = <File>[];

    // Generar eventos
    files.add(await _generateEventsFile());

    // Generar estados
    files.add(await _generateStatesFile());

    // Generar BLoC
    files.add(await _generateBlocFile());

    return files;
  }

  /// Genera los tests del BLoC.
  Future<List<File>> generateTests() async {
    final files = <File>[];

    files.add(await _generateTestFile());

    return files;
  }

  Future<File> _generateEventsFile() async {
    final fileName = '${featureName}_event.dart';
    final path = 'lib/features/$featureName/presentation/bloc/$fileName';

    final content = _buildEventsContent();

    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);

    return file;
  }

  Future<File> _generateStatesFile() async {
    final fileName = '${featureName}_state.dart';
    final path = 'lib/features/$featureName/presentation/bloc/$fileName';

    final content = _buildStatesContent();

    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);

    return file;
  }

  Future<File> _generateBlocFile() async {
    final fileName = '${featureName}_bloc.dart';
    final path = 'lib/features/$featureName/presentation/bloc/$fileName';

    final content = _buildBlocContent();

    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);

    return file;
  }

  Future<File> _generateTestFile() async {
    final fileName = '${featureName}_bloc_test.dart';
    final path = 'test/features/$featureName/presentation/bloc/$fileName';

    final content = _buildTestContent();

    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);

    return file;
  }

  String _buildEventsContent() {
    final buffer = StringBuffer();

    buffer.writeln("import 'package:equatable/equatable.dart';");
    buffer.writeln();
    buffer.writeln('/// Eventos del ${blocName}Bloc.');
    buffer.writeln('sealed class ${blocName}Event extends Equatable {');
    buffer.writeln('  const ${blocName}Event();');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  List<Object?> get props => [];');
    buffer.writeln('}');

    // Eventos por defecto si no se especificaron
    final defaultEvents = events.isEmpty
        ? [
            {'name': 'Load$blocName', 'description': 'Solicita cargar datos'},
            {'name': 'Refresh$blocName', 'description': 'Solicita refrescar datos'},
          ]
        : events;

    for (final event in defaultEvents) {
      buffer.writeln();
      buffer.writeln('/// ${event['description'] ?? event['name']}');
      buffer.writeln('class ${event['name']} extends ${blocName}Event {');

      final params = event['params'] as List<Map<String, dynamic>>? ?? [];
      if (params.isNotEmpty) {
        for (final param in params) {
          buffer.writeln('  final ${param['type']} ${param['name']};');
        }
        buffer.writeln();
        buffer.writeln('  const ${event['name']}({');
        for (final param in params) {
          buffer.writeln('    required this.${param['name']},');
        }
        buffer.writeln('  });');
        buffer.writeln();
        buffer.writeln('  @override');
        buffer.writeln('  List<Object?> get props => [${params.map((p) => p['name']).join(', ')}];');
      } else {
        buffer.writeln('  const ${event['name']}();');
      }

      buffer.writeln('}');
    }

    if (supportsPagination) {
      buffer.writeln();
      buffer.writeln('/// Solicita cargar más datos (paginación).');
      buffer.writeln('class LoadMore$blocName extends ${blocName}Event {');
      buffer.writeln('  const LoadMore$blocName();');
      buffer.writeln('}');
    }

    return buffer.toString();
  }

  String _buildStatesContent() {
    final buffer = StringBuffer();

    buffer.writeln("import 'package:equatable/equatable.dart';");
    buffer.writeln();
    buffer.writeln('/// Estados del ${blocName}Bloc.');
    buffer.writeln('sealed class ${blocName}State extends Equatable {');
    buffer.writeln('  const ${blocName}State();');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  List<Object?> get props => [];');
    buffer.writeln('}');

    // Estados por defecto
    final defaultStates = [
      {'name': 'Initial', 'description': 'Estado inicial'},
      {'name': 'Loading', 'description': 'Cargando datos'},
      {'name': 'Loaded', 'description': 'Datos cargados exitosamente'},
      {'name': 'Error', 'description': 'Error al cargar datos'},
    ];

    for (final state in defaultStates) {
      buffer.writeln();
      buffer.writeln('/// ${state['description']}');
      buffer.writeln('class $blocName${state['name']} extends ${blocName}State {');

      if (state['name'] == 'Loaded') {
        buffer.writeln('  // TODO: Agregar propiedades de datos');
        buffer.writeln('  // final List<Entity> items;');
        buffer.writeln();
        buffer.writeln('  const ${blocName}Loaded();');
        buffer.writeln();
        buffer.writeln('  // @override');
        buffer.writeln('  // List<Object?> get props => [items];');
      } else if (state['name'] == 'Error') {
        buffer.writeln('  final String message;');
        buffer.writeln();
        buffer.writeln('  const ${blocName}Error(this.message);');
        buffer.writeln();
        buffer.writeln('  @override');
        buffer.writeln('  List<Object?> get props => [message];');
      } else {
        buffer.writeln('  const $blocName${state['name']}();');
      }

      buffer.writeln('}');
    }

    if (supportsPagination) {
      buffer.writeln();
      buffer.writeln('/// Cargando más datos (paginación).');
      buffer.writeln('class ${blocName}LoadingMore extends ${blocName}State {');
      buffer.writeln('  const ${blocName}LoadingMore();');
      buffer.writeln('}');
    }

    return buffer.toString();
  }

  String _buildBlocContent() {
    final buffer = StringBuffer();

    buffer.writeln("import 'package:bloc/bloc.dart';");
    buffer.writeln("import 'package:injectable/injectable.dart';");
    buffer.writeln();
    buffer.writeln("import '${featureName}_event.dart';");
    buffer.writeln("import '${featureName}_state.dart';");

    // Imports de UseCases
    for (final usecase in usecases) {
      buffer.writeln("// import '../../../domain/usecases/${usecase.toSnakeCase()}.dart';");
    }

    buffer.writeln();
    buffer.writeln('/// BLoC para gestión de $blocName.');
    buffer.writeln('@injectable');
    buffer.writeln('class ${blocName}Bloc extends Bloc<${blocName}Event, ${blocName}State> {');

    // Dependencias
    for (final usecase in usecases) {
      buffer.writeln('  // final $usecase _${usecase.toCamelCase()};');
    }

    buffer.writeln();
    buffer.writeln('  ${blocName}Bloc(');
    for (final usecase in usecases) {
      buffer.writeln('    // this._${usecase.toCamelCase()},');
    }
    buffer.writeln('  ) : super(const ${blocName}Initial()) {');
    buffer.writeln('    on<Load$blocName>(_onLoad$blocName);');
    buffer.writeln('    on<Refresh$blocName>(_onRefresh$blocName);');
    if (supportsPagination) {
      buffer.writeln('    on<LoadMore$blocName>(_onLoadMore$blocName);');
    }
    buffer.writeln('  }');

    // Handlers
    buffer.writeln();
    buffer.writeln('  Future<void> _onLoad$blocName(');
    buffer.writeln('    Load$blocName event,');
    buffer.writeln('    Emitter<${blocName}State> emit,');
    buffer.writeln('  ) async {');
    buffer.writeln('    emit(const ${blocName}Loading());');
    buffer.writeln();
    buffer.writeln('    // TODO: Implementar llamada a UseCase');
    buffer.writeln('    // final result = await _useCase(params);');
    buffer.writeln('    // result.fold(');
    buffer.writeln('    //   (failure) => emit(${blocName}Error(failure.message)),');
    buffer.writeln('    //   (data) => emit(${blocName}Loaded(...)),');
    buffer.writeln('    // );');
    buffer.writeln('  }');

    buffer.writeln();
    buffer.writeln('  Future<void> _onRefresh$blocName(');
    buffer.writeln('    Refresh$blocName event,');
    buffer.writeln('    Emitter<${blocName}State> emit,');
    buffer.writeln('  ) async {');
    buffer.writeln('    // Similar a load pero sin mostrar loading');
    buffer.writeln('    add(const Load$blocName());');
    buffer.writeln('  }');

    if (supportsPagination) {
      buffer.writeln();
      buffer.writeln('  Future<void> _onLoadMore$blocName(');
      buffer.writeln('    LoadMore$blocName event,');
      buffer.writeln('    Emitter<${blocName}State> emit,');
      buffer.writeln('  ) async {');
      buffer.writeln('    // TODO: Implementar paginación');
      buffer.writeln('  }');
    }

    buffer.writeln('}');

    return buffer.toString();
  }

  String _buildTestContent() {
    final buffer = StringBuffer();

    buffer.writeln("import 'package:bloc_test/bloc_test.dart';");
    buffer.writeln("import 'package:flutter_test/flutter_test.dart';");
    buffer.writeln("import 'package:mocktail/mocktail.dart';");
    buffer.writeln();
    buffer.writeln('// TODO: Importar BLoC y dependencias');
    buffer.writeln();

    // Mocks
    for (final usecase in usecases) {
      buffer.writeln('class Mock$usecase extends Mock implements $usecase {}');
    }

    buffer.writeln();
    buffer.writeln('void main() {');
    buffer.writeln('  late ${blocName}Bloc sut;');
    for (final usecase in usecases) {
      buffer.writeln('  late Mock$usecase mock${usecase};');
    }
    buffer.writeln();

    buffer.writeln('  setUp(() {');
    for (final usecase in usecases) {
      buffer.writeln('    mock$usecase = Mock$usecase();');
    }
    buffer.writeln('    sut = ${blocName}Bloc(');
    for (final usecase in usecases) {
      buffer.writeln('      // mock$usecase,');
    }
    buffer.writeln('    );');
    buffer.writeln('  });');
    buffer.writeln();

    buffer.writeln("  test('estado inicial es ${blocName}Initial', () {");
    buffer.writeln('    expect(sut.state, const ${blocName}Initial());');
    buffer.writeln('  });');
    buffer.writeln();

    buffer.writeln("  group('Load$blocName', () {");
    buffer.writeln("    blocTest<${blocName}Bloc, ${blocName}State>(");
    buffer.writeln("      'emite [Loading, Loaded] cuando es exitoso',");
    buffer.writeln('      build: () {');
    buffer.writeln('        // TODO: Configurar mocks');
    buffer.writeln('        return sut;');
    buffer.writeln('      },');
    buffer.writeln('      act: (bloc) => bloc.add(const Load$blocName()),');
    buffer.writeln('      expect: () => [');
    buffer.writeln('        const ${blocName}Loading(),');
    buffer.writeln('        // const ${blocName}Loaded(...),');
    buffer.writeln('      ],');
    buffer.writeln('    );');
    buffer.writeln();
    buffer.writeln("    blocTest<${blocName}Bloc, ${blocName}State>(");
    buffer.writeln("      'emite [Loading, Error] cuando falla',");
    buffer.writeln('      build: () {');
    buffer.writeln('        // TODO: Configurar mocks para fallar');
    buffer.writeln('        return sut;');
    buffer.writeln('      },');
    buffer.writeln('      act: (bloc) => bloc.add(const Load$blocName()),');
    buffer.writeln('      expect: () => [');
    buffer.writeln('        const ${blocName}Loading(),');
    buffer.writeln("        // const ${blocName}Error('mensaje'),");
    buffer.writeln('      ],');
    buffer.writeln('    );');
    buffer.writeln('  });');

    buffer.writeln('}');

    return buffer.toString();
  }
}
