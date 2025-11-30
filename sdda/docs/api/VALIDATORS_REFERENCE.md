# Referencia del Sistema de Validadores

Documentación del sistema de validación SDDA.

---

## Arquitectura de Validación

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SISTEMA DE VALIDACIÓN SDDA                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌────────────────┐  ┌────────────────┐  ┌────────────────┐               │
│   │  Architecture  │  │    Naming      │  │   Structure    │               │
│   │   Validator    │  │   Validator    │  │   Validator    │               │
│   └───────┬────────┘  └───────┬────────┘  └───────┬────────┘               │
│           │                   │                   │                         │
│           ▼                   ▼                   ▼                         │
│   ┌─────────────────────────────────────────────────────────┐              │
│   │                  VALIDATION ENGINE                       │              │
│   │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐    │              │
│   │  │  File   │  │  AST    │  │ Config  │  │ Report  │    │              │
│   │  │ Scanner │  │ Parser  │  │ Loader  │  │Generator│    │              │
│   │  └─────────┘  └─────────┘  └─────────┘  └─────────┘    │              │
│   └─────────────────────────────────────────────────────────┘              │
│                            │                                                │
│                            ▼                                                │
│   ┌─────────────────────────────────────────────────────────┐              │
│   │                 VALIDATION REPORT                        │              │
│   │  ┌─────────┐  ┌─────────┐  ┌─────────┐                 │              │
│   │  │ Errors  │  │Warnings │  │  Info   │                 │              │
│   │  └─────────┘  └─────────┘  └─────────┘                 │              │
│   └─────────────────────────────────────────────────────────┘              │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Validadores Disponibles

### 1. Architecture Validator

Valida que el código siga las reglas de Clean Architecture.

#### Reglas

| Código | Regla | Severidad |
|--------|-------|-----------|
| `ARCH001` | Domain no puede importar Data | Error |
| `ARCH002` | Domain no puede importar Presentation | Error |
| `ARCH003` | Presentation no puede importar Data directamente | Error |
| `ARCH004` | Data no puede importar Presentation | Error |
| `ARCH005` | Core no puede importar features | Error |
| `ARCH006` | Feature no puede importar otro feature directamente | Warning |

#### Configuración

```yaml
# sdda.yaml
validation:
  architecture:
    enabled: true
    strict: true  # false permite warnings sin fallar
    layers:
      domain:
        allowed_imports: [core]
        forbidden_imports: [data, presentation]
      data:
        allowed_imports: [core, domain]
        forbidden_imports: [presentation]
      presentation:
        allowed_imports: [core, domain]
        forbidden_imports: [data]
    cross_feature:
      allowed: false  # No permitir imports entre features
      exceptions: [shared, common]  # Features permitidos
```

#### Ejemplo de Violación

```dart
// lib/features/products/domain/usecases/get_products.dart

// ❌ ARCH001: Domain importing from Data
import 'package:app/features/products/data/models/product_model.dart';

// ✅ Correcto: Domain solo importa de Domain
import 'package:app/features/products/domain/entities/product.dart';
```

---

### 2. Naming Validator

Valida convenciones de nombrado.

#### Reglas

| Código | Regla | Aplica A | Pattern |
|--------|-------|----------|---------|
| `NAME001` | PascalCase para clases | Clases | `^[A-Z][a-zA-Z0-9]*$` |
| `NAME002` | snake_case para archivos | Archivos | `^[a-z][a-z0-9_]*\.dart$` |
| `NAME003` | camelCase para variables | Variables | `^[a-z][a-zA-Z0-9]*$` |
| `NAME004` | Sufijo correcto | Componentes | Ver tabla |
| `NAME005` | Prefijo de test data | Test data | `^t[A-Z]` |
| `NAME006` | Prefijo privado | Privados | `^_` |

#### Sufijos Requeridos

| Componente | Sufijo | Ejemplo |
|------------|--------|---------|
| UseCase | (ninguno o UseCase) | `GetProducts` o `GetProductsUseCase` |
| BLoC | Bloc | `ProductBloc` |
| Cubit | Cubit | `ProductCubit` |
| Event | Event | `LoadProductsEvent` |
| State | State | `ProductLoadedState` |
| Repository | Repository | `ProductRepository` |
| DataSource | DataSource | `ProductRemoteDataSource` |
| Model | Model | `ProductModel` |
| Entity | (ninguno) | `Product` |
| Failure | Failure | `NetworkFailure` |
| Exception | Exception | `ServerException` |
| Page | Page | `ProductsPage` |
| Widget | Widget (o específico) | `ProductCard` |

#### Configuración

```yaml
# sdda.yaml
validation:
  naming:
    enabled: true
    strict: true
    patterns:
      classes: PascalCase
      files: snake_case
      variables: camelCase
      constants: camelCase  # o SCREAMING_SNAKE_CASE
      private: _camelCase
    suffixes:
      bloc: Bloc
      cubit: Cubit
      repository: Repository
      datasource: DataSource
      model: Model
      failure: Failure
      exception: Exception
      page: Page
    prefixes:
      test_data: t
      private: _
```

#### Ejemplos de Violación

```dart
// ❌ NAME001: Clase no es PascalCase
class productBloc extends Bloc { }  // Debería ser ProductBloc

// ❌ NAME002: Archivo no es snake_case
// Archivo: ProductBloc.dart  // Debería ser product_bloc.dart

// ❌ NAME004: Sufijo incorrecto
class ProductManager { }  // Si es BLoC, debería ser ProductBloc

// ❌ NAME005: Test data sin prefijo
const testProduct = Product(...);  // Debería ser tProduct
```

---

### 3. Structure Validator

Valida la estructura de archivos y directorios.

#### Reglas

| Código | Regla | Severidad |
|--------|-------|-----------|
| `STRUCT001` | Directorio de capa faltante | Error |
| `STRUCT002` | Archivo requerido faltante | Error |
| `STRUCT003` | Archivo en ubicación incorrecta | Warning |
| `STRUCT004` | Directorio vacío | Info |
| `STRUCT005` | Test faltante para componente | Warning |

#### Estructura Esperada por Feature

```
lib/features/{feature}/
├── domain/                    # STRUCT001 si falta
│   ├── entities/              # STRUCT001 si falta
│   │   └── {entity}.dart      # STRUCT002 si falta
│   ├── repositories/          # STRUCT001 si falta
│   │   └── {feature}_repository.dart
│   └── usecases/              # STRUCT001 si falta
│       └── {usecase}.dart     # STRUCT002 si falta
├── data/                      # STRUCT001 si falta
│   ├── models/
│   │   └── {entity}_model.dart
│   ├── repositories/
│   │   └── {feature}_repository_impl.dart
│   └── datasources/
│       ├── {feature}_remote_datasource.dart
│       └── {feature}_local_datasource.dart
└── presentation/              # STRUCT001 si falta
    ├── bloc/
    │   ├── {feature}_bloc.dart
    │   ├── {feature}_event.dart
    │   └── {feature}_state.dart
    └── pages/
        └── {feature}_page.dart
```

#### Configuración

```yaml
# sdda.yaml
validation:
  structure:
    enabled: true
    strict: false  # true hace que warnings sean errores
    required_layers:
      - domain
      - data
      - presentation
    required_directories:
      domain:
        - entities
        - repositories
        - usecases
      data:
        - models
        - repositories
        - datasources
      presentation:
        - bloc
        - pages
    test_required: true  # Requiere tests para cada componente
    test_mirror: true    # Tests deben reflejar estructura de lib/
```

---

### 4. Test Validator

Valida existencia y calidad de tests.

#### Reglas

| Código | Regla | Severidad |
|--------|-------|-----------|
| `TEST001` | Test faltante para UseCase | Error |
| `TEST002` | Test faltante para BLoC | Error |
| `TEST003` | Test faltante para Repository | Warning |
| `TEST004` | Cobertura insuficiente | Warning |
| `TEST005` | Test sin assertions | Warning |
| `TEST006` | Test sin arrange/act/assert | Info |

#### Configuración

```yaml
# sdda.yaml
validation:
  tests:
    enabled: true
    required_for:
      - usecase      # TEST001
      - bloc         # TEST002
      - repository   # TEST003
    coverage:
      enabled: true
      minimum: 80
      per_layer:
        domain: 95
        data: 85
        presentation: 75
    quality:
      require_assertions: true
      require_aaa_pattern: false
```

---

### 5. Spec Validator

Valida especificaciones YAML.

#### Reglas

| Código | Regla | Severidad |
|--------|-------|-----------|
| `SPEC001` | YAML syntax inválido | Error |
| `SPEC002` | Campo requerido faltante | Error |
| `SPEC003` | Tipo inválido | Error |
| `SPEC004` | Referencia a entidad inexistente | Error |
| `SPEC005` | Validación mal formada | Warning |
| `SPEC006` | Descripción faltante | Info |

#### Campos Requeridos

```yaml
# Feature
feature:
  name: required        # SPEC002 si falta
  description: required # SPEC006 si falta (info)

# Entities
entities:
  - name: required      # SPEC002 si falta
    properties: required

# Properties
properties:
  - name: required
    type: required      # SPEC003 si tipo inválido

# UseCases
usecases:
  - name: required
    return_type: required

# BLoC
bloc:
  name: required
  events: required
  states: required
```

---

## API del Validation Engine

### ValidationEngine

```dart
class ValidationEngine {
  /// Ejecuta todas las validaciones configuradas
  Future<ValidationReport> validate({
    required String target,  // --all, --feature=X, o path
    ValidationOptions? options,
  });

  /// Ejecuta un validador específico
  Future<ValidationReport> runValidator(
    Validator validator,
    List<String> files,
  );

  /// Obtiene validadores habilitados
  List<Validator> getEnabledValidators();

  /// Registra un validador personalizado
  void registerValidator(Validator validator);
}
```

### Validator Interface

```dart
abstract class Validator {
  /// Nombre único del validador
  String get name;

  /// Descripción del validador
  String get description;

  /// Ejecuta la validación
  Future<List<ValidationIssue>> validate(
    List<String> files,
    ValidatorConfig config,
  );

  /// Intenta auto-corregir (si soportado)
  Future<List<ValidationFix>> fix(
    List<ValidationIssue> issues,
  );
}
```

### ValidationIssue

```dart
class ValidationIssue {
  final String code;        // ej: ARCH001
  final Severity severity;  // error, warning, info
  final String message;     // Descripción del problema
  final String file;        // Archivo afectado
  final int? line;          // Línea (si aplica)
  final int? column;        // Columna (si aplica)
  final String? suggestion; // Sugerencia de corrección
  final bool fixable;       // Si se puede auto-corregir
}

enum Severity { error, warning, info }
```

### ValidationReport

```dart
class ValidationReport {
  final List<ValidationIssue> issues;
  final int errorCount;
  final int warningCount;
  final int infoCount;
  final bool passed;        // true si no hay errores
  final Duration duration;

  /// Filtra por severidad
  List<ValidationIssue> byLevel(Severity severity);

  /// Filtra por código
  List<ValidationIssue> byCode(String code);

  /// Agrupa por archivo
  Map<String, List<ValidationIssue>> byFile();

  /// Genera reporte en formato
  String format(ReportFormat format);
}

enum ReportFormat { text, json, html, junit }
```

---

## Crear Validador Personalizado

### 1. Implementar Validator

```dart
// lib/sdda/validators/custom_validator.dart

class CustomValidator implements Validator {
  @override
  String get name => 'custom';

  @override
  String get description => 'Validaciones personalizadas de mi equipo';

  @override
  Future<List<ValidationIssue>> validate(
    List<String> files,
    ValidatorConfig config,
  ) async {
    final issues = <ValidationIssue>[];

    for (final file in files) {
      final content = await File(file).readAsString();

      // Ejemplo: Verificar que no haya print statements
      if (content.contains('print(')) {
        final lines = content.split('\n');
        for (var i = 0; i < lines.length; i++) {
          if (lines[i].contains('print(')) {
            issues.add(ValidationIssue(
              code: 'CUSTOM001',
              severity: Severity.warning,
              message: 'Avoid print statements in production code',
              file: file,
              line: i + 1,
              suggestion: 'Use Logger instead of print',
              fixable: true,
            ));
          }
        }
      }
    }

    return issues;
  }

  @override
  Future<List<ValidationFix>> fix(List<ValidationIssue> issues) async {
    final fixes = <ValidationFix>[];

    for (final issue in issues.where((i) => i.code == 'CUSTOM001')) {
      fixes.add(ValidationFix(
        issue: issue,
        replacement: issue.file.replaceAll(
          RegExp(r'print\((.*?)\);'),
          'Logger.d(\$1);',
        ),
      ));
    }

    return fixes;
  }
}
```

### 2. Registrar Validador

```dart
// En sdda/05_generators/lib/validators/validators.dart

final validationEngine = ValidationEngine()
  ..registerValidator(ArchitectureValidator())
  ..registerValidator(NamingValidator())
  ..registerValidator(StructureValidator())
  ..registerValidator(CustomValidator());  // Agregar aquí
```

### 3. Configurar en sdda.yaml

```yaml
validation:
  custom:
    enabled: true
    rules:
      CUSTOM001:
        severity: warning  # Puede ser overridden
        enabled: true
```

---

## Uso desde CLI

### Comandos de Validación

```bash
# Validar todo
sdda validate --all

# Validar feature específico
sdda validate --feature=products

# Validar archivo específico
sdda validate lib/features/products/domain/usecases/get_products.dart

# Solo ciertos validadores
sdda validate --all --validators=architecture,naming

# Excluir validadores
sdda validate --all --exclude=structure

# Con auto-fix
sdda validate --all --fix

# Generar reporte
sdda validate --all --report --format=json > report.json

# Modo estricto (warnings = errors)
sdda validate --all --strict

# Verbose
sdda validate --all --verbose
```

### Flags de Validación

| Flag | Descripción |
|------|-------------|
| `--all` | Valida todo el proyecto |
| `--feature=X` | Valida feature específico |
| `--validators=X,Y` | Solo ejecutar validadores específicos |
| `--exclude=X,Y` | Excluir validadores |
| `--fix` | Intentar auto-corregir |
| `--strict` | Warnings son errores |
| `--report` | Generar reporte |
| `--format=X` | Formato: text, json, html, junit |
| `--verbose` | Salida detallada |
| `--quiet` | Solo errores |

---

## Integración con CI/CD

### GitHub Actions

```yaml
- name: SDDA Validate
  run: |
    sdda validate --all --strict --report --format=junit > validation.xml

- name: Upload Validation Report
  uses: actions/upload-artifact@v3
  if: always()
  with:
    name: validation-report
    path: validation.xml

- name: Publish Test Results
  uses: EnricoMi/publish-unit-test-result-action@v2
  if: always()
  with:
    files: validation.xml
```

### Pre-commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Obtener archivos staged
STAGED=$(git diff --cached --name-only --diff-filter=ACM | grep '\.dart$')

if [ -n "$STAGED" ]; then
    echo "Validating staged files..."
    sdda validate $STAGED --strict

    if [ $? -ne 0 ]; then
        echo "❌ Validation failed. Fix issues before committing."
        exit 1
    fi
fi

echo "✅ Validation passed"
```

---

## Códigos de Error Completos

### Architecture (ARCH)

| Código | Mensaje | Auto-fix |
|--------|---------|----------|
| ARCH001 | Domain layer cannot import from Data layer | No |
| ARCH002 | Domain layer cannot import from Presentation layer | No |
| ARCH003 | Presentation layer cannot import from Data layer | No |
| ARCH004 | Data layer cannot import from Presentation layer | No |
| ARCH005 | Core cannot import from features | No |
| ARCH006 | Cross-feature import detected | No |

### Naming (NAME)

| Código | Mensaje | Auto-fix |
|--------|---------|----------|
| NAME001 | Class name should be PascalCase | Sí |
| NAME002 | File name should be snake_case | Sí |
| NAME003 | Variable name should be camelCase | Sí |
| NAME004 | Missing required suffix | Sí |
| NAME005 | Test data should have 't' prefix | Sí |
| NAME006 | Private member should start with '_' | Sí |

### Structure (STRUCT)

| Código | Mensaje | Auto-fix |
|--------|---------|----------|
| STRUCT001 | Required directory missing | Sí (crear) |
| STRUCT002 | Required file missing | No |
| STRUCT003 | File in wrong location | Sí (mover) |
| STRUCT004 | Empty directory | Sí (eliminar) |
| STRUCT005 | Missing test for component | No |

### Tests (TEST)

| Código | Mensaje | Auto-fix |
|--------|---------|----------|
| TEST001 | Missing test for UseCase | No |
| TEST002 | Missing test for BLoC | No |
| TEST003 | Missing test for Repository | No |
| TEST004 | Coverage below threshold | No |
| TEST005 | Test has no assertions | No |
| TEST006 | Test doesn't follow AAA pattern | No |

### Spec (SPEC)

| Código | Mensaje | Auto-fix |
|--------|---------|----------|
| SPEC001 | Invalid YAML syntax | No |
| SPEC002 | Required field missing | No |
| SPEC003 | Invalid type | No |
| SPEC004 | Reference to undefined entity | No |
| SPEC005 | Malformed validation rule | No |
| SPEC006 | Missing description | No |

---

## Siguiente Paso

Ver el [Índice de Documentación](../00_INDICE.md) para navegar a otras secciones.
