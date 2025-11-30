# Flujo de Trabajo Completo

Guía detallada del ciclo de desarrollo con SDDA.

---

## Visión General

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                         CICLO DE DESARROLLO SDDA                              │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│   ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐               │
│   │ SPECIFY │────▶│CONTRACT │────▶│GENERATE │────▶│VALIDATE │               │
│   └─────────┘     └─────────┘     └─────────┘     └─────────┘               │
│        │                                               │                     │
│        │                                               │                     │
│        │         ┌──────────────────────────┐          │                     │
│        └────────▶│   Si falla, iterar       │◀─────────┘                     │
│                  └──────────────────────────┘                                │
│                                                                               │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Fase 1: SPECIFY (Especificar)

### Objetivo
Definir EXACTAMENTE qué se va a construir.

### Actividades

```bash
# 1. Crear directorio del feature
mkdir -p sdda/01_specs/features/[feature_name]

# 2. Crear especificación
touch sdda/01_specs/features/[feature_name]/spec.yaml
```

### Estructura de Especificación

```yaml
# sdda/01_specs/features/[feature]/spec.yaml

# ═══════════════════════════════════════════════════════════════════════════════
# METADATA
# ═══════════════════════════════════════════════════════════════════════════════
feature:
  name: [nombre_snake_case]
  description: "[Descripción clara]"
  version: "1.0.0"
  owner: "[equipo/persona]"
  status: draft | review | approved

# ═══════════════════════════════════════════════════════════════════════════════
# REQUISITOS DE NEGOCIO (ATDD)
# ═══════════════════════════════════════════════════════════════════════════════
requirements:
  - id: REQ-001
    description: "Como usuario quiero..."
    acceptance_criteria:
      - "Dado que..., cuando..., entonces..."
    priority: high | medium | low

# ═══════════════════════════════════════════════════════════════════════════════
# ENTIDADES (DDD)
# ═══════════════════════════════════════════════════════════════════════════════
entities:
  - name: EntityName
    type: entity | value_object | aggregate
    properties:
      - name: propertyName
        type: String | int | double | bool | DateTime | CustomType
        required: true | false
        validation: "[regla de validación]"

# ═══════════════════════════════════════════════════════════════════════════════
# CASOS DE USO
# ═══════════════════════════════════════════════════════════════════════════════
usecases:
  - name: UseCaseName
    description: "[Qué hace]"
    return_type: ReturnType
    params:
      - name: paramName
        type: ParamType
        required: true | false
        default: [valor_default]
        validation: "[regla]"
    preconditions:
      - "[condición que debe cumplirse]"
    postconditions:
      - "[estado después de ejecutar]"
    failures:
      - FailureType: "[cuándo ocurre]"

# ═══════════════════════════════════════════════════════════════════════════════
# API (si aplica)
# ═══════════════════════════════════════════════════════════════════════════════
api:
  base_url: "/api/v1/[feature]"
  endpoints:
    - method: GET | POST | PUT | DELETE
      path: /path/{param}
      description: "[qué hace]"
      request:
        headers: {}
        params: {}
        body: {}
      response:
        success: {}
        errors:
          400: "[descripción]"
          401: "[descripción]"
          500: "[descripción]"

# ═══════════════════════════════════════════════════════════════════════════════
# UI/BLOC
# ═══════════════════════════════════════════════════════════════════════════════
bloc:
  name: BlocName
  events:
    - name: EventName
      description: "[qué dispara]"
      params: []
  states:
    - name: StateName
      description: "[qué representa]"
      properties: []
```

### Checklist de Especificación

- [ ] ¿Todas las entidades tienen sus propiedades definidas?
- [ ] ¿Todos los casos de uso tienen params y return type?
- [ ] ¿Se documentaron los failures posibles?
- [ ] ¿Las validaciones están claras?
- [ ] ¿La API está completamente definida?

---

## Fase 2: CONTRACT (Escribir Tests)

### Objetivo
Escribir tests que sirvan como CONTRATOS del comportamiento esperado.

### Orden de Escritura

```
1. Unit Tests (UseCases)      ─▶  Comportamiento de lógica de negocio
2. Unit Tests (Repository)    ─▶  Coordinación de datasources
3. BLoC Tests                 ─▶  Transiciones de estado
4. Widget Tests               ─▶  Comportamiento de UI
5. Integration Tests          ─▶  Flujos entre capas
6. E2E Tests                  ─▶  Flujos completos de usuario
```

### Estructura de Tests

```
sdda/02_contracts/
├── unit/
│   └── [feature]/
│       ├── [usecase]_usecase_test.dart
│       └── [feature]_repository_impl_test.dart
│
├── bloc/
│   └── [feature]/
│       └── [feature]_bloc_test.dart
│
├── widget/
│   └── [feature]/
│       └── [widget]_test.dart
│
├── integration/
│   └── [feature]/
│       └── [feature]_integration_test.dart
│
└── e2e/
    └── [feature]/
        └── [feature]_e2e_test.dart
```

### Template de Test UseCase

```dart
// sdda/02_contracts/unit/[feature]/[usecase]_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late UseCase sut;
  late MockRepository mockRepository;

  // ══════════════════════════════════════════════════════════════════════════
  // TEST DATA
  // ══════════════════════════════════════════════════════════════════════════
  // Usar prefijo 't' para test data
  const tParam = 'test_value';
  final tResult = Entity(...);
  const tFailure = ServerFailure('Error');

  // ══════════════════════════════════════════════════════════════════════════
  // SETUP
  // ══════════════════════════════════════════════════════════════════════════
  setUp(() {
    mockRepository = MockRepository();
    sut = UseCase(mockRepository);
  });

  // ══════════════════════════════════════════════════════════════════════════
  // TESTS
  // ══════════════════════════════════════════════════════════════════════════

  group('UseCase', () {
    // Casos de éxito
    group('casos de éxito', () {
      test('debe retornar [Result] cuando [condición]', () async {
        // Arrange
        when(() => mockRepository.method(any()))
            .thenAnswer((_) async => Right(tResult));

        // Act
        final result = await sut(Params(...));

        // Assert
        expect(result, Right(tResult));
        verify(() => mockRepository.method(any())).called(1);
      });
    });

    // Validaciones
    group('validaciones', () {
      test('debe retornar ValidationFailure cuando [condición inválida]', () async {
        // Act
        final result = await sut(Params.invalid());

        // Assert
        expect(result.isLeft(), true);
        verifyNever(() => mockRepository.method(any()));
      });
    });

    // Casos de error
    group('casos de error', () {
      test('debe propagar [Failure] cuando [condición de error]', () async {
        // Arrange
        when(() => mockRepository.method(any()))
            .thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await sut(Params(...));

        // Assert
        expect(result, const Left(tFailure));
      });
    });
  });
}
```

### Template de Test BLoC

```dart
// sdda/02_contracts/bloc/[feature]/[feature]_bloc_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockUseCase extends Mock implements UseCase {}

void main() {
  late Bloc sut;
  late MockUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockUseCase();
    sut = Bloc(useCase: mockUseCase);
  });

  setUpAll(() {
    registerFallbackValue(Params());
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ESTADO INICIAL
  // ══════════════════════════════════════════════════════════════════════════
  test('estado inicial es [Initial]', () {
    expect(sut.state, const Initial());
  });

  // ══════════════════════════════════════════════════════════════════════════
  // EVENTOS
  // ══════════════════════════════════════════════════════════════════════════

  group('[EventName]', () {
    blocTest<Bloc, State>(
      'emite [Loading, Loaded] cuando es exitoso',
      build: () {
        when(() => mockUseCase(any()))
            .thenAnswer((_) async => Right(result));
        return sut;
      },
      act: (bloc) => bloc.add(Event()),
      expect: () => [
        const Loading(),
        Loaded(data: result),
      ],
      verify: (_) {
        verify(() => mockUseCase(any())).called(1);
      },
    );

    blocTest<Bloc, State>(
      'emite [Loading, Error] cuando falla',
      build: () {
        when(() => mockUseCase(any()))
            .thenAnswer((_) async => const Left(Failure()));
        return sut;
      },
      act: (bloc) => bloc.add(Event()),
      expect: () => [
        const Loading(),
        const Error(message: 'Error'),
      ],
    );
  });
}
```

### Checklist de Contratos

- [ ] ¿Cada UseCase tiene tests de éxito?
- [ ] ¿Cada UseCase tiene tests de validación?
- [ ] ¿Cada UseCase tiene tests de error?
- [ ] ¿El BLoC tiene test de estado inicial?
- [ ] ¿Cada evento del BLoC tiene tests de éxito y error?

---

## Fase 3: GENERATE (Generar)

### Opción A: Generación con CLI

```bash
# Feature completo
sdda generate feature [nombre] --spec=path/to/spec.yaml

# Componentes individuales
sdda generate usecase [nombre] --feature=[feature]
sdda generate bloc [nombre] --feature=[feature]
sdda generate repository [nombre] --feature=[feature]
```

### Opción B: Generación con IA Directa

```bash
# 1. Generar prompt
sdda prompt feature --name=[nombre] --spec=path/to/spec.yaml --output=prompt.md

# 2. Copiar prompt a Claude/ChatGPT/Gemini

# 3. Copiar código generado a archivos
```

### Opción C: Generación Híbrida

```bash
# 1. Generar estructura base con CLI
sdda generate feature [nombre] --skeleton-only

# 2. Generar implementaciones con IA usando prompts
sdda prompt usecase --feature=[nombre] --name=[usecase]
# Copiar a IA, obtener código, pegar en archivo

# 3. Validar
sdda validate --feature=[nombre]
```

---

## Fase 4: VALIDATE (Validar)

### 4.1 Validación de Convenciones

```bash
sdda validate --feature=[nombre]
```

### 4.2 Análisis Estático

```bash
flutter analyze lib/features/[nombre]/
```

### 4.3 Ejecutar Tests

```bash
# Todos los tests del feature
flutter test test/features/[nombre]/

# Con cobertura
flutter test test/features/[nombre]/ --coverage

# Generar reporte
genhtml coverage/lcov.info -o coverage/html
```

### 4.4 Verificar Cobertura

```bash
# Mínimo 80% de cobertura
lcov --summary coverage/lcov.info
```

### Checklist de Validación

- [ ] `sdda validate` pasa sin errores
- [ ] `flutter analyze` sin warnings
- [ ] Todos los tests pasan
- [ ] Cobertura ≥ 80%

---

## Iteración

### Si los Tests Fallan

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUJO DE ITERACIÓN                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Tests fallan                                                  │
│        │                                                        │
│        ▼                                                        │
│   ¿Es problema de spec?  ───Sí───▶  Actualizar spec            │
│        │                                   │                    │
│        No                                  ▼                    │
│        │                            Re-generar                  │
│        ▼                                   │                    │
│   ¿Es problema de test?  ───Sí───▶  Corregir test             │
│        │                                   │                    │
│        No                                  │                    │
│        │                                   │                    │
│        ▼                                   │                    │
│   Corregir código ◀────────────────────────┘                   │
│        │                                                        │
│        ▼                                                        │
│   Re-validar                                                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Comandos de Iteración

```bash
# Regenerar un componente específico
sdda generate usecase [nombre] --feature=[feature] --force

# Validar solo un archivo
sdda validate lib/features/[feature]/domain/usecases/[usecase].dart

# Ejecutar test específico
flutter test test/features/[feature]/domain/usecases/[usecase]_test.dart
```

---

## Flujo de Trabajo Diario

### Nuevo Feature

```bash
# Día 1: Especificar
1. Crear spec.yaml
2. Revisar con equipo
3. Aprobar spec

# Día 2: Contratar
4. Escribir tests de UseCase
5. Escribir tests de BLoC
6. Revisar tests

# Día 3: Generar
7. sdda generate feature [nombre]
8. Verificar estructura

# Día 4: Validar e Integrar
9. sdda validate
10. flutter test
11. Integrar en app
12. PR y code review
```

### Modificación de Feature Existente

```bash
# 1. Actualizar spec
nano sdda/01_specs/features/[feature]/spec.yaml

# 2. Actualizar/agregar tests
nano sdda/02_contracts/unit/[feature]/...

# 3. Regenerar componente afectado
sdda generate usecase [nuevo] --feature=[feature]

# 4. Validar
sdda validate --feature=[feature]
flutter test test/features/[feature]/
```

---

## Siguiente Paso

Ver la [Guía de Métricas](../metrics/METRICAS.md) para medir la efectividad del proceso.
