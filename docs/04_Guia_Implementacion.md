# 04 - Guía de Implementación Paso a Paso

## Objetivo

Esta guía proporciona los pasos concretos para implementar el framework SDDA en un proyecto Flutter, desde cero hasta un flujo de trabajo funcional con generación de código por IA.

---

## Fase 1: Preparación del Proyecto (Día 1-2)

### 1.1 Requisitos Previos

```bash
# Verificar versiones
flutter --version  # >= 3.24.0
dart --version     # >= 3.5.0

# Herramientas necesarias
# - Git
# - IDE (VS Code / Android Studio)
# - API key de al menos un proveedor de IA (Claude, GPT, Gemini)
```

### 1.2 Crear Estructura SDDA

```bash
#!/bin/bash
# scripts/init_sdda.sh

echo "🚀 Inicializando estructura SDDA..."

# Crear directorios principales
mkdir -p sdda/{01_specifications,02_contracts,03_context,04_prompts,05_generators}

# Subdirectorios de especificaciones
mkdir -p sdda/01_specifications/{templates,features,domain,schemas}

# Subdirectorios de contratos
mkdir -p sdda/02_contracts/{acceptance,unit,widget,integration,e2e}

# Subdirectorios de contexto
mkdir -p sdda/03_context/{architecture,patterns,apis,schemas,conventions,glossary}
mkdir -p sdda/03_context/patterns/examples
mkdir -p sdda/03_context/architecture/decisions

# Subdirectorios de prompts
mkdir -p sdda/04_prompts/{system,generation,testing,review,fix}

# Subdirectorios de generadores
mkdir -p sdda/05_generators

echo "✅ Estructura creada"
```

### 1.3 Configurar Dependencias

```yaml
# pubspec.yaml - agregar dependencias

dependencies:
  flutter:
    sdk: flutter

  # Arquitectura
  dartz: ^0.10.1           # Either y Option
  equatable: ^2.0.5        # Value equality
  get_it: ^7.6.7           # DI container
  injectable: ^2.3.2       # DI annotations

  # State Management
  flutter_bloc: ^8.1.4
  bloc: ^8.1.3

  # Networking
  dio: ^5.4.1
  connectivity_plus: ^5.0.2

  # Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Testing
  mocktail: ^1.0.3
  bloc_test: ^9.1.7
  golden_toolkit: ^0.15.0

  # Integration testing
  integration_test:
    sdk: flutter
  patrol: ^3.6.1

  # Code generation
  build_runner: ^2.4.8
  injectable_generator: ^2.4.1
  hive_generator: ^2.0.1

  # Analysis
  very_good_analysis: ^5.1.0
```

### 1.4 Configurar Analysis Options

```yaml
# analysis_options.yaml

include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.mocks.dart"

linter:
  rules:
    public_member_api_docs: false
    lines_longer_than_80_chars: false
    prefer_single_quotes: true
```

---

## Fase 2: Configurar Contexto (Día 3-4)

### 2.1 Crear Documento de Arquitectura

```bash
# Crear archivo de arquitectura
touch sdda/03_context/architecture/ARCHITECTURE.md
```

```markdown
<!-- sdda/03_context/architecture/ARCHITECTURE.md -->

# Arquitectura del Proyecto

## Stack Tecnológico

| Categoría | Tecnología | Versión |
|-----------|------------|---------|
| Framework | Flutter | 3.24.x |
| State Management | flutter_bloc | 8.x |
| DI | get_it + injectable | latest |
| HTTP | dio | 5.x |
| Storage | hive | 2.x |

## Capas

### Presentation Layer
- Pages (Screens)
- Widgets
- BLoCs/Cubits

### Domain Layer
- Entities
- Use Cases
- Repository Interfaces

### Data Layer
- Repository Implementations
- Data Sources (Remote/Local)
- Models (DTOs)

## Flujo de Datos

```
UI Event → BLoC → UseCase → Repository → DataSource
```

## Reglas de Dependencia

1. Presentation → Domain (solo)
2. Domain → Ninguna
3. Data → Domain (solo)
```

### 2.2 Documentar Patrones

```dart
// sdda/03_context/patterns/examples/example_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

/// Ejemplo de UseCase que sirve como referencia para la IA
@lazySingleton
class GetProductsUseCase {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  /// Ejecuta el caso de uso
  ///
  /// Retorna Either con:
  /// - Left: Failure en caso de error
  /// - Right: Lista de productos en caso de éxito
  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    // Validación de entrada
    if (params.limit <= 0) {
      return Left(ValidationFailure('Limit debe ser mayor a 0'));
    }

    // Delegación al repositorio
    return _repository.getProducts(
      page: params.page,
      limit: params.limit,
      category: params.category,
    );
  }
}

/// Parámetros del caso de uso
class GetProductsParams extends Equatable {
  final int page;
  final int limit;
  final String? category;

  const GetProductsParams({
    this.page = 1,
    this.limit = 20,
    this.category,
  });

  @override
  List<Object?> get props => [page, limit, category];
}
```

```dart
// sdda/03_context/patterns/examples/example_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'example_event.dart';
part 'example_state.dart';

/// Ejemplo de BLoC que sirve como referencia para la IA
@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase _getProductsUseCase;

  ProductBloc(this._getProductsUseCase) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await _getProductsUseCase(
      GetProductsParams(
        page: event.page,
        limit: event.limit,
        category: event.category,
      ),
    );

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products: products)),
    );
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    // No emitir loading para refresh (mantiene datos actuales)
    final result = await _getProductsUseCase(
      const GetProductsParams(page: 1),
    );

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products: products)),
    );
  }
}
```

### 2.3 Crear Convenciones

```markdown
<!-- sdda/03_context/conventions/CONVENTIONS.md -->

# Convenciones del Proyecto

## Nombrado de Archivos

| Tipo | Sufijo | Ejemplo |
|------|--------|---------|
| Page | `_page.dart` | `login_page.dart` |
| Widget | `_widget.dart` | `user_avatar_widget.dart` |
| BLoC | `_bloc.dart` | `auth_bloc.dart` |
| UseCase | `_usecase.dart` | `login_usecase.dart` |
| Repository (interface) | `_repository.dart` | `auth_repository.dart` |
| Repository (impl) | `_repository_impl.dart` | `auth_repository_impl.dart` |
| Model | `_model.dart` | `user_model.dart` |
| Entity | `.dart` (sin sufijo) | `user.dart` |

## Estructura de Feature

```
features/
└── auth/
    ├── data/
    │   ├── datasources/
    │   ├── models/
    │   └── repositories/
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    └── presentation/
        ├── bloc/
        ├── pages/
        └── widgets/
```

## Imports

Orden:
1. Dart SDK
2. Flutter
3. Paquetes externos (alfabético)
4. Imports del proyecto
```

---

## Fase 3: Configurar Sistema de Prompts (Día 5-6)

### 3.1 Crear Prompt Base del Sistema

```markdown
<!-- sdda/04_prompts/system/base_system_prompt.md -->

# ROL

Eres un desarrollador Flutter senior. Tu tarea es IMPLEMENTAR código
que cumpla EXACTAMENTE con las especificaciones y tests proporcionados.

# REGLAS ABSOLUTAS

1. **NO INVENTAR**: Solo usa APIs documentadas en el contexto
2. **SEGUIR PATRONES**: Replica exactamente los patrones mostrados
3. **PASAR TESTS**: El código DEBE pasar todos los tests de contrato
4. **MÍNIMO NECESARIO**: Solo implementa lo especificado
5. **CONVENCIONES**: Sigue las convenciones del proyecto

# FORMATO DE RESPUESTA

```dart
// filepath: lib/features/[feature]/[layer]/[file].dart
[código]
```
```

### 3.2 Crear Archivo de Configuración SDDA

```yaml
# sdda/sdda.yaml

version: "1.0"
name: "Mi Proyecto Flutter"

# Configuración del proyecto
project:
  flutter_version: "3.24.0"
  dart_version: "3.5.0"
  package_name: "my_app"

# Proveedores de IA soportados
ai_providers:
  - name: "claude"
    model: "claude-sonnet-4-20250514"
    api_key_env: "ANTHROPIC_API_KEY"

  - name: "openai"
    model: "gpt-4-turbo"
    api_key_env: "OPENAI_API_KEY"

  - name: "gemini"
    model: "gemini-pro"
    api_key_env: "GOOGLE_API_KEY"

# Configuración de generación
generation:
  max_retries: 3
  validate_syntax: true
  run_tests: true
  auto_format: true

# Configuración de tests
testing:
  unit:
    coverage_threshold: 80
    timeout: "5m"

  widget:
    coverage_threshold: 75
    timeout: "10m"

  e2e:
    timeout: "30m"
    device_farm: "firebase_test_lab"

# Quality gates
quality_gates:
  coverage:
    lines: 80
    branches: 75

  static_analysis:
    errors: 0
    warnings: 0
```

### 3.3 Crear Plantillas de Prompt

```yaml
# sdda/04_prompts/generation/usecase_prompt.yaml

prompt:
  name: "generate_usecase"
  version: "1.0"

  parameters:
    - name: "feature_name"
      required: true
    - name: "usecase_name"
      required: true
    - name: "spec_id"
      required: true

  template: |
    {{system_prompt}}

    ---

    # CONTEXTO

    ## Arquitectura
    {{architecture_doc}}

    ## Patrón de UseCase
    {{usecase_pattern}}

    ## Ejemplo
    ```dart
    {{example_usecase}}
    ```

    ---

    # CONTRATO (TESTS)

    ```dart
    {{contract_tests}}
    ```

    ---

    # TAREA

    Implementar: `{{usecase_name}}UseCase`
    Feature: `{{feature_name}}`
    Archivo: `lib/features/{{feature_name}}/domain/usecases/{{usecase_name}}_usecase.dart`

    El código debe pasar todos los tests del contrato.
```

---

## Fase 4: Primer Flujo Completo (Día 7-10)

### 4.1 Crear Especificación de Feature

```yaml
# sdda/01_specifications/features/auth/login_spec.yaml

feature:
  id: "AUTH-001"
  name: "Login de Usuario"
  version: "1.0"

  business_context:
    description: |
      Como usuario de la aplicación
      Quiero poder iniciar sesión con email y contraseña
      Para acceder a mi cuenta

  acceptance_criteria:
    - id: "AC-001"
      given: "Usuario registrado con email válido"
      when: "Ingresa credenciales correctas"
      then: "Es redirigido al home con sesión activa"

    - id: "AC-002"
      given: "Credenciales inválidas"
      when: "Intenta hacer login"
      then: "Ve mensaje de error"

  data_contracts:
    input:
      - name: "email"
        type: "String"
        validation: "email_format"
      - name: "password"
        type: "String"
        validation: "min_length:8"

    output:
      success:
        type: "User"
      failure:
        types: ["InvalidCredentials", "Network", "Server"]
```

### 4.2 Escribir Tests de Contrato (TDD)

```dart
// sdda/02_contracts/unit/auth/login_usecase_contract_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

// Imports del proyecto (ajustar según estructura)
import 'package:my_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_app/features/auth/domain/entities/user.dart';
import 'package:my_app/core/error/failures.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase sut;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    sut = LoginUseCase(repository: mockRepository);
  });

  group('LoginUseCase', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    final tUser = User(
      id: '1',
      email: tEmail,
      name: 'Test User',
      createdAt: DateTime(2024),
    );

    test('debe retornar User cuando login es exitoso', () async {
      // Arrange
      when(() => mockRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => Right(tUser));

      // Act
      final result = await sut(LoginParams(
        email: tEmail,
        password: tPassword,
      ));

      // Assert
      expect(result, Right(tUser));
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
    });

    test('debe retornar InvalidCredentialsFailure cuando credenciales inválidas', () async {
      // Arrange
      when(() => mockRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => Left(InvalidCredentialsFailure()));

      // Act
      final result = await sut(LoginParams(
        email: tEmail,
        password: tPassword,
      ));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
        (_) => fail('Debería fallar'),
      );
    });

    test('debe retornar ValidationFailure para email inválido', () async {
      // Act
      final result = await sut(LoginParams(
        email: 'invalid-email',
        password: tPassword,
      ));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Debería fallar'),
      );
      verifyNever(() => mockRepository.login(any(), any()));
    });

    test('debe retornar ValidationFailure para password corto', () async {
      // Act
      final result = await sut(LoginParams(
        email: tEmail,
        password: '123',
      ));

      // Assert
      expect(result.isLeft(), true);
      verifyNever(() => mockRepository.login(any(), any()));
    });
  });
}
```

### 4.3 Ejecutar Tests (deben fallar - RED)

```bash
flutter test sdda/02_contracts/unit/auth/login_usecase_contract_test.dart
# Debería fallar porque LoginUseCase no existe aún
```

### 4.4 Generar Código con IA

```dart
// sdda/05_generators/generate_feature.dart

import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print('Uso: dart run sdda/05_generators/generate_feature.dart <feature_name>');
    exit(1);
  }

  final featureName = args[0];

  print('🚀 Generando feature: $featureName');

  // 1. Cargar contexto
  final context = await loadContext(featureName);

  // 2. Cargar tests de contrato
  final contractTests = await loadContractTests(featureName);

  // 3. Construir prompt
  final prompt = await buildPrompt(
    featureName: featureName,
    context: context,
    contractTests: contractTests,
  );

  // 4. Enviar a IA
  final generatedCode = await sendToAI(prompt);

  // 5. Guardar código
  await saveGeneratedCode(featureName, generatedCode);

  // 6. Ejecutar tests
  final testResult = await runTests(featureName);

  if (testResult.passed) {
    print('✅ Código generado exitosamente');
  } else {
    print('❌ Tests fallaron. Reintentando...');
    // Lógica de reintento
  }
}

Future<Map<String, String>> loadContext(String feature) async {
  return {
    'architecture': await File('sdda/03_context/architecture/ARCHITECTURE.md').readAsString(),
    'patterns': await File('sdda/03_context/patterns/examples/example_usecase.dart').readAsString(),
    'conventions': await File('sdda/03_context/conventions/CONVENTIONS.md').readAsString(),
  };
}

Future<String> loadContractTests(String feature) async {
  return await File('sdda/02_contracts/unit/$feature/login_usecase_contract_test.dart').readAsString();
}

Future<String> buildPrompt({
  required String featureName,
  required Map<String, String> context,
  required String contractTests,
}) async {
  final systemPrompt = await File('sdda/04_prompts/system/base_system_prompt.md').readAsString();

  return '''
$systemPrompt

---

# CONTEXTO DEL PROYECTO

## Arquitectura
${context['architecture']}

## Patrón de UseCase
${context['patterns']}

## Convenciones
${context['conventions']}

---

# CONTRATO (TESTS QUE DEBE PASAR)

```dart
$contractTests
```

---

# TAREA

Implementar LoginUseCase para la feature auth.
Archivo: lib/features/auth/domain/usecases/login_usecase.dart

El código DEBE pasar todos los tests del contrato.
''';
}

// ... implementar sendToAI, saveGeneratedCode, runTests
```

### 4.5 Verificar Código Generado (GREEN)

```bash
# Ejecutar tests - ahora deberían pasar
flutter test sdda/02_contracts/unit/auth/login_usecase_contract_test.dart

# Si pasan todos:
echo "✅ LoginUseCase implementado correctamente"
```

---

## Fase 5: Automatización Completa (Día 11-15)

### 5.1 Crear CLI de SDDA

```dart
// bin/sdda.dart

import 'dart:io';
import 'package:args/command_runner.dart';

void main(List<String> args) {
  final runner = CommandRunner<void>(
    'sdda',
    'Framework de Specification-Driven Development para IA',
  )
    ..addCommand(InitCommand())
    ..addCommand(SpecCommand())
    ..addCommand(ContractCommand())
    ..addCommand(GenerateCommand())
    ..addCommand(ValidateCommand());

  runner.run(args).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64);
  });
}

class InitCommand extends Command<void> {
  @override
  String get name => 'init';

  @override
  String get description => 'Inicializa estructura SDDA en el proyecto';

  @override
  Future<void> run() async {
    print('🚀 Inicializando SDDA...');
    // Crear estructura de carpetas
    // Copiar templates
    // Configurar archivos base
    print('✅ SDDA inicializado');
  }
}

class GenerateCommand extends Command<void> {
  @override
  String get name => 'generate';

  @override
  String get description => 'Genera código desde especificaciones';

  GenerateCommand() {
    argParser
      ..addOption('feature', abbr: 'f', help: 'Nombre de la feature')
      ..addOption('type', abbr: 't', help: 'Tipo: usecase, bloc, widget, etc')
      ..addFlag('dry-run', help: 'Mostrar prompt sin ejecutar');
  }

  @override
  Future<void> run() async {
    final feature = argResults?['feature'] as String?;
    final type = argResults?['type'] as String?;
    final dryRun = argResults?['dry-run'] as bool? ?? false;

    if (feature == null || type == null) {
      print('Error: --feature y --type son requeridos');
      exit(1);
    }

    print('🤖 Generando $type para feature $feature...');

    // Lógica de generación
    if (dryRun) {
      print('(Dry run - mostrando prompt)');
      // Mostrar prompt
    } else {
      // Ejecutar generación
    }
  }
}

// ... más comandos
```

### 5.2 Script de Workflow Completo

```bash
#!/bin/bash
# scripts/develop_feature.sh

FEATURE_NAME=$1

if [ -z "$FEATURE_NAME" ]; then
    echo "Uso: ./scripts/develop_feature.sh <feature_name>"
    exit 1
fi

echo "═══════════════════════════════════════════════════════════════════"
echo "  SDDA: Desarrollando feature '$FEATURE_NAME'"
echo "═══════════════════════════════════════════════════════════════════"

# Paso 1: Verificar especificación existe
echo ""
echo "📋 Paso 1: Verificando especificación..."
if [ ! -f "sdda/01_specifications/features/$FEATURE_NAME/spec.yaml" ]; then
    echo "❌ Error: No existe especificación para '$FEATURE_NAME'"
    echo "   Crea: sdda/01_specifications/features/$FEATURE_NAME/spec.yaml"
    exit 1
fi
echo "✅ Especificación encontrada"

# Paso 2: Verificar contratos existen
echo ""
echo "📝 Paso 2: Verificando contratos (tests)..."
CONTRACT_DIR="sdda/02_contracts/unit/$FEATURE_NAME"
if [ ! -d "$CONTRACT_DIR" ] || [ -z "$(ls -A $CONTRACT_DIR)" ]; then
    echo "❌ Error: No existen tests de contrato para '$FEATURE_NAME'"
    echo "   Crea tests en: $CONTRACT_DIR/"
    exit 1
fi
echo "✅ Contratos encontrados"

# Paso 3: Ejecutar tests de contrato (deben fallar si código no existe)
echo ""
echo "🧪 Paso 3: Ejecutando tests de contrato..."
flutter test $CONTRACT_DIR --reporter expanded
TEST_RESULT=$?

if [ $TEST_RESULT -eq 0 ]; then
    echo "⚠️  Los tests ya pasan. ¿El código ya fue generado?"
    read -p "¿Deseas regenerar el código? (s/n): " REGENERATE
    if [ "$REGENERATE" != "s" ]; then
        echo "Abortando."
        exit 0
    fi
fi

# Paso 4: Generar código con IA
echo ""
echo "🤖 Paso 4: Generando código con IA..."
dart run sdda/05_generators/generate_feature.dart $FEATURE_NAME

# Paso 5: Verificar código generado
echo ""
echo "🔍 Paso 5: Verificando código generado..."
flutter analyze lib/features/$FEATURE_NAME/
dart format lib/features/$FEATURE_NAME/ --set-exit-if-changed

# Paso 6: Ejecutar tests de contrato (ahora deben pasar)
echo ""
echo "✅ Paso 6: Ejecutando tests de contrato (validación)..."
flutter test $CONTRACT_DIR --reporter expanded

if [ $? -ne 0 ]; then
    echo "❌ Error: Los tests de contrato no pasan"
    echo "   Revisa el código generado o ajusta los tests"
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "  ✅ Feature '$FEATURE_NAME' generada exitosamente"
echo "═══════════════════════════════════════════════════════════════════"
```

---

## Fase 6: Integración CI/CD (Día 16-20)

### 6.1 GitHub Actions Workflow

```yaml
# .github/workflows/sdda.yml

name: SDDA CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

env:
  FLUTTER_VERSION: '3.24.0'

jobs:
  # ═══════════════════════════════════════════════════════════════════════
  # Validar Contratos
  # ═══════════════════════════════════════════════════════════════════════
  validate-contracts:
    name: Validar Contratos
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}

      - name: Instalar dependencias
        run: flutter pub get

      - name: Ejecutar tests de contrato
        run: flutter test sdda/02_contracts/ --coverage

      - name: Verificar cobertura
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info | grep "lines" | awk '{print $2}' | cut -d'%' -f1)
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "❌ Cobertura $COVERAGE% menor al umbral (80%)"
            exit 1
          fi

  # ═══════════════════════════════════════════════════════════════════════
  # Análisis Estático
  # ═══════════════════════════════════════════════════════════════════════
  static-analysis:
    name: Análisis Estático
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}

      - run: flutter pub get
      - run: flutter analyze --fatal-infos
      - run: dart format --set-exit-if-changed .

  # ═══════════════════════════════════════════════════════════════════════
  # Tests Unitarios y de Widget
  # ═══════════════════════════════════════════════════════════════════════
  unit-tests:
    name: Tests Unitarios
    runs-on: ubuntu-latest
    needs: validate-contracts
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}

      - run: flutter pub get
      - run: flutter test test/ --coverage --reporter github

      - uses: codecov/codecov-action@v4
        with:
          files: coverage/lcov.info

  # ═══════════════════════════════════════════════════════════════════════
  # Tests E2E
  # ═══════════════════════════════════════════════════════════════════════
  e2e-tests:
    name: Tests E2E
    runs-on: macos-latest
    needs: unit-tests
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}

      - run: flutter pub get

      - name: Ejecutar tests E2E iOS
        run: |
          flutter build ios --simulator
          flutter test integration_test/ --device-id iPhone
```

---

## Resumen de Implementación

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CHECKLIST DE IMPLEMENTACIÓN SDDA                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  FASE 1: Preparación (Día 1-2)                                              │
│  ├── [ ] Estructura de carpetas SDDA creada                                 │
│  ├── [ ] Dependencias instaladas                                            │
│  └── [ ] Analysis options configurado                                       │
│                                                                              │
│  FASE 2: Contexto (Día 3-4)                                                 │
│  ├── [ ] ARCHITECTURE.md documentado                                        │
│  ├── [ ] Patrones de código ejemplificados                                  │
│  ├── [ ] Convenciones definidas                                             │
│  └── [ ] API catalog creado                                                 │
│                                                                              │
│  FASE 3: Sistema de Prompts (Día 5-6)                                       │
│  ├── [ ] Prompt base del sistema creado                                     │
│  ├── [ ] sdda.yaml configurado                                              │
│  └── [ ] Templates de prompt creados                                        │
│                                                                              │
│  FASE 4: Primer Flujo (Día 7-10)                                            │
│  ├── [ ] Primera especificación creada                                      │
│  ├── [ ] Tests de contrato escritos                                         │
│  ├── [ ] Código generado con IA                                             │
│  └── [ ] Tests pasando                                                      │
│                                                                              │
│  FASE 5: Automatización (Día 11-15)                                         │
│  ├── [ ] CLI de SDDA funcionando                                            │
│  ├── [ ] Scripts de workflow creados                                        │
│  └── [ ] Proceso reproducible                                               │
│                                                                              │
│  FASE 6: CI/CD (Día 16-20)                                                  │
│  ├── [ ] GitHub Actions configurado                                         │
│  ├── [ ] Quality gates activos                                              │
│  └── [ ] Pipeline completo funcionando                                      │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

**Documento parte del framework SDDA**
**Versión 1.0 - Noviembre 2025**
