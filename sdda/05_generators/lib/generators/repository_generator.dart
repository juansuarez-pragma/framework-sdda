import 'dart:io';

import '../utils/string_utils.dart';

/// Generador de código para Repositories.
class RepositoryGenerator {
  final String repositoryName;
  final String featureName;
  final bool hasLocalDataSource;
  final bool hasRemoteDataSource;
  final List<Map<String, dynamic>> methods;

  RepositoryGenerator({
    required this.repositoryName,
    required this.featureName,
    this.hasLocalDataSource = true,
    this.hasRemoteDataSource = true,
    this.methods = const [],
  });

  /// Genera los archivos del Repository.
  Future<List<File>> generate() async {
    final files = <File>[];

    // Interface
    files.add(await _generateInterfaceFile());

    // Implementación
    files.add(await _generateImplementationFile());

    // DataSources
    if (hasRemoteDataSource) {
      files.add(await _generateRemoteDataSourceFile());
    }
    if (hasLocalDataSource) {
      files.add(await _generateLocalDataSourceFile());
    }

    return files;
  }

  Future<File> _generateInterfaceFile() async {
    final fileName = '${featureName}_repository.dart';
    final path = 'lib/features/$featureName/domain/repositories/$fileName';

    final content = _buildInterfaceContent();

    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);

    return file;
  }

  Future<File> _generateImplementationFile() async {
    final fileName = '${featureName}_repository_impl.dart';
    final path = 'lib/features/$featureName/data/repositories/$fileName';

    final content = _buildImplementationContent();

    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);

    return file;
  }

  Future<File> _generateRemoteDataSourceFile() async {
    final fileName = '${featureName}_remote_datasource.dart';
    final path = 'lib/features/$featureName/data/datasources/$fileName';

    final content = _buildRemoteDataSourceContent();

    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);

    return file;
  }

  Future<File> _generateLocalDataSourceFile() async {
    final fileName = '${featureName}_local_datasource.dart';
    final path = 'lib/features/$featureName/data/datasources/$fileName';

    final content = _buildLocalDataSourceContent();

    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);

    return file;
  }

  String _buildInterfaceContent() {
    final className = '${repositoryName}Repository';
    final buffer = StringBuffer();

    buffer.writeln("import 'package:dartz/dartz.dart';");
    buffer.writeln();
    buffer.writeln("import '../../../../core/error/failures.dart';");
    buffer.writeln();
    buffer.writeln('/// Contrato del repositorio de ${repositoryName.toSpacedWords().toLowerCase()}.');
    buffer.writeln('///');
    buffer.writeln('/// Define las operaciones disponibles sin detalles de implementación.');
    buffer.writeln('abstract class $className {');

    // Métodos por defecto si no se especificaron
    final defaultMethods = methods.isEmpty
        ? [
            {
              'name': 'getAll',
              'return_type': 'List<Entity>',
              'description': 'Obtiene todos los elementos',
            },
            {
              'name': 'getById',
              'return_type': 'Entity',
              'description': 'Obtiene un elemento por ID',
              'params': [
                {'name': 'id', 'type': 'String'}
              ],
            },
          ]
        : methods;

    for (final method in defaultMethods) {
      buffer.writeln();
      buffer.writeln('  /// ${method['description']}');
      buffer.write('  Future<Either<Failure, ${method['return_type']}>> ${method['name']}(');

      final params = method['params'] as List<Map<String, dynamic>>? ?? [];
      if (params.isNotEmpty) {
        final paramStr = params.map((p) => '${p['type']} ${p['name']}').join(', ');
        buffer.write(paramStr);
      }
      buffer.writeln(');');
    }

    buffer.writeln('}');

    return buffer.toString();
  }

  String _buildImplementationContent() {
    final interfaceName = '${repositoryName}Repository';
    final className = '${repositoryName}RepositoryImpl';
    final buffer = StringBuffer();

    buffer.writeln("import 'package:dartz/dartz.dart';");
    buffer.writeln("import 'package:injectable/injectable.dart';");
    buffer.writeln();
    buffer.writeln("import '../../../../core/error/exceptions.dart';");
    buffer.writeln("import '../../../../core/error/failures.dart';");
    buffer.writeln("import '../../../../core/network/network_info.dart';");
    buffer.writeln("import '../../domain/repositories/${featureName}_repository.dart';");

    if (hasRemoteDataSource) {
      buffer.writeln("import '../datasources/${featureName}_remote_datasource.dart';");
    }
    if (hasLocalDataSource) {
      buffer.writeln("import '../datasources/${featureName}_local_datasource.dart';");
    }

    buffer.writeln();
    buffer.writeln('/// Implementación del repositorio de ${repositoryName.toSpacedWords().toLowerCase()}.');
    buffer.writeln('@LazySingleton(as: $interfaceName)');
    buffer.writeln('class $className implements $interfaceName {');

    if (hasRemoteDataSource) {
      buffer.writeln('  final ${repositoryName}RemoteDataSource _remoteDataSource;');
    }
    if (hasLocalDataSource) {
      buffer.writeln('  final ${repositoryName}LocalDataSource _localDataSource;');
    }
    buffer.writeln('  final NetworkInfo _networkInfo;');
    buffer.writeln();

    // Constructor
    buffer.writeln('  $className({');
    if (hasRemoteDataSource) {
      buffer.writeln('    required ${repositoryName}RemoteDataSource remoteDataSource,');
    }
    if (hasLocalDataSource) {
      buffer.writeln('    required ${repositoryName}LocalDataSource localDataSource,');
    }
    buffer.writeln('    required NetworkInfo networkInfo,');
    buffer.writeln('  })  :');
    final assignments = <String>[];
    if (hasRemoteDataSource) {
      assignments.add('_remoteDataSource = remoteDataSource');
    }
    if (hasLocalDataSource) {
      assignments.add('_localDataSource = localDataSource');
    }
    assignments.add('_networkInfo = networkInfo');
    buffer.writeln('       ${assignments.join(',\n       ')};');

    // Métodos
    final defaultMethods = methods.isEmpty
        ? [
            {
              'name': 'getAll',
              'return_type': 'List<Entity>',
            },
            {
              'name': 'getById',
              'return_type': 'Entity',
              'params': [
                {'name': 'id', 'type': 'String'}
              ],
            },
          ]
        : methods;

    for (final method in defaultMethods) {
      buffer.writeln();
      buffer.writeln('  @override');
      buffer.write('  Future<Either<Failure, ${method['return_type']}>> ${method['name']}(');
      final params = method['params'] as List<Map<String, dynamic>>? ?? [];
      if (params.isNotEmpty) {
        final paramStr = params.map((p) => '${p['type']} ${p['name']}').join(', ');
        buffer.write(paramStr);
      }
      buffer.writeln(') async {');
      buffer.writeln('    if (!await _networkInfo.isConnected) {');
      buffer.writeln("      return const Left(NetworkFailure('Sin conexión a internet'));");
      buffer.writeln('    }');
      buffer.writeln();
      buffer.writeln('    try {');
      buffer.writeln('      // TODO: Implementar lógica');
      buffer.writeln('      throw UnimplementedError();');
      buffer.writeln('    } on ServerException catch (e) {');
      buffer.writeln('      return Left(ServerFailure(e.message));');
      buffer.writeln('    } on Exception catch (e) {');
      buffer.writeln("      return Left(ServerFailure('Error inesperado: \$e'));");
      buffer.writeln('    }');
      buffer.writeln('  }');
    }

    buffer.writeln('}');

    return buffer.toString();
  }

  String _buildRemoteDataSourceContent() {
    final className = '${repositoryName}RemoteDataSource';
    final buffer = StringBuffer();

    buffer.writeln('/// DataSource remoto para ${repositoryName.toSpacedWords().toLowerCase()}.');
    buffer.writeln('abstract class $className {');
    buffer.writeln('  // TODO: Definir métodos que retornan Models');
    buffer.writeln('}');
    buffer.writeln();
    buffer.writeln('/// Implementación del DataSource remoto.');
    buffer.writeln('// @LazySingleton(as: $className)');
    buffer.writeln('class ${className}Impl implements $className {');
    buffer.writeln('  // final ApiClient _apiClient;');
    buffer.writeln();
    buffer.writeln('  // ${className}Impl(this._apiClient);');
    buffer.writeln('}');

    return buffer.toString();
  }

  String _buildLocalDataSourceContent() {
    final className = '${repositoryName}LocalDataSource';
    final buffer = StringBuffer();

    buffer.writeln('/// DataSource local para ${repositoryName.toSpacedWords().toLowerCase()}.');
    buffer.writeln('abstract class $className {');
    buffer.writeln('  // TODO: Definir métodos de caché');
    buffer.writeln('}');
    buffer.writeln();
    buffer.writeln('/// Implementación del DataSource local.');
    buffer.writeln('// @LazySingleton(as: $className)');
    buffer.writeln('class ${className}Impl implements $className {');
    buffer.writeln('  // final LocalStorage _localStorage;');
    buffer.writeln();
    buffer.writeln('  // ${className}Impl(this._localStorage);');
    buffer.writeln('}');

    return buffer.toString();
  }
}
