# Referencia del Sistema de Prompts

Documentación del sistema de prompts para generación con IA.

---

## Arquitectura del Sistema de Prompts

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SISTEMA DE PROMPTS SDDA                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐                   │
│   │   SYSTEM     │   │  GENERATION  │   │  VALIDATION  │                   │
│   │   PROMPTS    │   │   PROMPTS    │   │   PROMPTS    │                   │
│   └──────┬───────┘   └──────┬───────┘   └──────┬───────┘                   │
│          │                  │                  │                            │
│          ▼                  ▼                  ▼                            │
│   ┌─────────────────────────────────────────────────────┐                  │
│   │              PROMPT ENGINE                           │                  │
│   │  ┌─────────┐  ┌─────────┐  ┌─────────┐             │                  │
│   │  │Template │  │ Context │  │ Output  │             │                  │
│   │  │ Loader  │  │Injector │  │Formatter│             │                  │
│   │  └─────────┘  └─────────┘  └─────────┘             │                  │
│   └─────────────────────────────────────────────────────┘                  │
│                            │                                                │
│                            ▼                                                │
│   ┌─────────────────────────────────────────────────────┐                  │
│   │              PROMPT FINAL                            │                  │
│   │  System + Context + Spec + Examples + Task          │                  │
│   └─────────────────────────────────────────────────────┘                  │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Tipos de Prompts

### 1. System Prompts

Establecen el rol y las reglas base para la IA.

**Ubicación**: `sdda/04_prompts/system/`

| Archivo | Propósito |
|---------|-----------|
| `flutter_expert.md` | Rol de experto en Flutter |
| `clean_architecture.md` | Reglas de Clean Architecture |
| `tdd_expert.md` | Metodología TDD |

#### Ejemplo: flutter_expert.md

```markdown
# System Prompt: Flutter Expert

You are an expert Flutter developer with deep knowledge of:

## Technical Expertise
- Flutter SDK and Dart language (latest stable versions)
- Clean Architecture patterns
- BLoC pattern for state management
- Functional programming with dartz (Either, Option)
- Test-Driven Development (TDD)

## Code Standards
- Write production-ready, type-safe code
- Follow Effective Dart guidelines
- Use meaningful names that reveal intent
- Keep functions small and focused
- Prefer composition over inheritance

## Constraints
- ONLY use packages listed in pubspec.yaml
- NEVER invent methods or classes that don't exist
- ALWAYS follow the project's existing patterns
- Generate code that compiles without errors
- Include proper error handling with Either<Failure, Success>

## Output Format
- Generate complete, runnable code
- Include all necessary imports
- Add documentation comments for public APIs
- Follow the exact file structure provided
```

---

### 2. Generation Prompts

Templates para generar componentes específicos.

**Ubicación**: `sdda/04_prompts/generation/`

| Archivo | Propósito |
|---------|-----------|
| `feature_prompt.md` | Feature completo |
| `usecase_prompt.md` | UseCase individual |
| `bloc_prompt.md` | BLoC con eventos/estados |
| `repository_prompt.md` | Repository + impl |
| `entity_prompt.md` | Entity del dominio |
| `model_prompt.md` | Model con JSON |

#### Ejemplo: usecase_prompt.md

```markdown
# Generate UseCase: {{usecase_name}}

## Context

### Project Architecture
{{architecture_context}}

### Conventions
{{conventions_context}}

## Specification

```yaml
{{usecase_spec}}
```

## Example Pattern

Follow this exact pattern:

```dart
{{example_usecase}}
```

## Dependencies Available

### Repository Interface
```dart
{{repository_interface}}
```

### Entity
```dart
{{entity_definition}}
```

### Failures
```dart
{{failure_types}}
```

## Tests to Pass (Contract)

```dart
{{usecase_tests}}
```

## Task

Generate the UseCase `{{usecase_name}}` that:

1. Extends `UseCase<{{return_type}}, {{params_type}}>`
2. Receives `{{repository_name}}` via constructor injection
3. Implements the `call` method with the exact signature
4. Returns `Either<Failure, {{return_type}}>`
5. Handles all failures defined in the specification
6. Passes ALL the tests provided above

## Output Format

Provide the complete file content for:
`lib/features/{{feature_name}}/domain/usecases/{{usecase_file}}.dart`

Include:
- All necessary imports
- The UseCase class
- The Params class (if needed)
- Documentation comments
```

---

### 3. Testing Prompts

Templates para generar tests.

**Ubicación**: `sdda/04_prompts/testing/`

| Archivo | Propósito |
|---------|-----------|
| `unit_test_prompt.md` | Tests unitarios |
| `bloc_test_prompt.md` | Tests de BLoC |
| `widget_test_prompt.md` | Tests de widgets |
| `integration_test_prompt.md` | Tests de integración |

#### Ejemplo: unit_test_prompt.md

```markdown
# Generate Unit Tests: {{component_name}}

## Context

### Testing Conventions
{{testing_conventions}}

### Available Test Utilities
- mocktail: ^1.0.0 for mocking
- bloc_test: ^9.0.0 for BLoC testing
- flutter_test for general testing

## Component Under Test

```dart
{{component_code}}
```

## Specification

```yaml
{{component_spec}}
```

## Example Test Pattern

```dart
{{example_test}}
```

## Task

Generate comprehensive unit tests that cover:

### Success Cases
{{success_cases}}

### Validation Cases
{{validation_cases}}

### Error Cases
{{error_cases}}

### Edge Cases
{{edge_cases}}

## Test Structure

```dart
void main() {
  // Test data with 't' prefix
  // Setup with mocks
  // Group by scenario type
  // Arrange-Act-Assert pattern
}
```

## Output Format

Provide the complete test file:
`test/features/{{feature_name}}/{{test_path}}/{{test_file}}.dart`
```

---

### 4. Validation Prompts

Templates para validar y corregir código.

**Ubicación**: `sdda/04_prompts/validation/`

| Archivo | Propósito |
|---------|-----------|
| `review_prompt.md` | Code review |
| `fix_prompt.md` | Corregir errores |
| `refactor_prompt.md` | Refactorizar |

#### Ejemplo: fix_prompt.md

```markdown
# Fix Code: {{component_name}}

## Current Code (with errors)

```dart
{{current_code}}
```

## Errors Found

```
{{error_messages}}
```

## Project Context

### Correct Patterns
```dart
{{correct_patterns}}
```

### Available Types
{{available_types}}

### Available Methods
{{available_methods}}

## Task

Fix the code above so that:
1. All compilation errors are resolved
2. All tests pass
3. The code follows project conventions
4. No new dependencies are introduced

## Constraints
- ONLY fix the errors, do not add new features
- Keep the same structure and intent
- Use only existing types and methods
- Maintain all existing functionality

## Output Format

Provide the corrected complete file.
```

---

## Variables de Template

El sistema usa placeholders que se reemplazan dinámicamente.

### Variables Globales

| Variable | Descripción | Fuente |
|----------|-------------|--------|
| `{{project_name}}` | Nombre del proyecto | sdda.yaml |
| `{{package_name}}` | Package name | pubspec.yaml |
| `{{flutter_version}}` | Versión de Flutter | environment |
| `{{date}}` | Fecha actual | system |

### Variables de Contexto

| Variable | Descripción | Fuente |
|----------|-------------|--------|
| `{{architecture_context}}` | Extracto de arquitectura | ARCHITECTURE.md |
| `{{conventions_context}}` | Convenciones relevantes | CONVENTIONS.md |
| `{{glossary_terms}}` | Términos del glosario | glossary/ |

### Variables de Especificación

| Variable | Descripción | Fuente |
|----------|-------------|--------|
| `{{feature_name}}` | Nombre del feature | spec.yaml |
| `{{usecase_name}}` | Nombre del UseCase | spec.yaml |
| `{{usecase_spec}}` | Spec completo del UseCase | spec.yaml |
| `{{entity_definition}}` | Definición de entidad | spec.yaml |
| `{{return_type}}` | Tipo de retorno | spec.yaml |
| `{{params_type}}` | Tipo de parámetros | spec.yaml |

### Variables de Ejemplos

| Variable | Descripción | Fuente |
|----------|-------------|--------|
| `{{example_usecase}}` | Código de ejemplo UseCase | examples/ |
| `{{example_bloc}}` | Código de ejemplo BLoC | examples/ |
| `{{example_repository}}` | Código de ejemplo Repository | examples/ |
| `{{example_test}}` | Código de ejemplo test | examples/ |

### Variables de Tests

| Variable | Descripción | Fuente |
|----------|-------------|--------|
| `{{usecase_tests}}` | Tests del UseCase | contracts/ |
| `{{bloc_tests}}` | Tests del BLoC | contracts/ |
| `{{success_cases}}` | Casos de éxito | spec.yaml |
| `{{error_cases}}` | Casos de error | spec.yaml |

---

## Configuración de Prompts

### En sdda.yaml

```yaml
prompts:
  # Nivel de contexto por defecto
  context_level: medium  # minimal | medium | full

  # Inclusiones por defecto
  include_examples: true
  include_tests: true
  include_architecture: true
  include_conventions: true

  # Límites de tokens
  max_tokens:
    minimal: 1500
    medium: 4000
    full: 12000

  # Personalización de templates
  custom_templates:
    usecase: custom/my_usecase_prompt.md
    bloc: custom/my_bloc_prompt.md

  # Secciones opcionales
  sections:
    constraints: true
    output_format: true
    examples: true
    tests: true
```

---

## API del Prompt Engine

### PromptEngine

```dart
class PromptEngine {
  /// Genera un prompt para un componente
  Future<String> generatePrompt({
    required PromptType type,
    required String featureName,
    String? componentName,
    ContextLevel contextLevel = ContextLevel.medium,
    Map<String, dynamic>? additionalContext,
  });

  /// Carga un template específico
  Future<String> loadTemplate(String templatePath);

  /// Inyecta variables en un template
  String injectVariables(String template, Map<String, String> variables);

  /// Obtiene contexto del proyecto
  Future<Map<String, String>> getProjectContext(ContextLevel level);

  /// Obtiene especificación formateada
  Future<String> getFormattedSpec(String featureName, String? componentName);
}
```

### Tipos de Prompt

```dart
enum PromptType {
  feature,
  usecase,
  bloc,
  repository,
  entity,
  model,
  datasource,
  unitTest,
  blocTest,
  widgetTest,
  integrationTest,
  fix,
  refactor,
  review,
}
```

### Niveles de Contexto

```dart
enum ContextLevel {
  /// Solo especificación (~500-1500 tokens)
  minimal,

  /// Spec + 1 ejemplo + convenciones (~2000-4000 tokens)
  medium,

  /// Todo el contexto disponible (~8000-12000 tokens)
  full,
}
```

---

## Personalización de Prompts

### Crear Template Personalizado

1. **Crear archivo de template**:
```bash
mkdir -p sdda/04_prompts/custom
touch sdda/04_prompts/custom/my_usecase_prompt.md
```

2. **Escribir template**:
```markdown
# Custom UseCase Generator

## My Company Standards
[Estándares específicos de tu empresa]

## Specification
{{usecase_spec}}

## Pattern to Follow
{{example_usecase}}

## Generate

Create UseCase following our company standards...
```

3. **Registrar en sdda.yaml**:
```yaml
prompts:
  custom_templates:
    usecase: custom/my_usecase_prompt.md
```

---

### Extender Variables

```dart
// En lib/sdda/prompt_extensions.dart

extension CustomPromptVariables on PromptEngine {
  Map<String, String> getCustomVariables() {
    return {
      'company_name': 'My Company',
      'team_conventions': loadFile('team_conventions.md'),
      'api_standards': loadFile('api_standards.md'),
    };
  }
}
```

---

## Mejores Prácticas para Prompts

### 1. Ser Específico

```markdown
# ❌ Vago
Generate a UseCase for getting products.

# ✅ Específico
Generate the GetProducts UseCase that:
- Extends UseCase<List<Product>, GetProductsParams>
- Uses ProductRepository.getProducts()
- Returns Either<Failure, List<Product>>
- Handles NetworkFailure and ServerFailure
```

### 2. Incluir Ejemplos Completos

```markdown
# ❌ Sin ejemplo
Follow the project patterns.

# ✅ Con ejemplo completo
Follow this exact pattern:

```dart
class GetUser implements UseCase<User, GetUserParams> {
  final UserRepository repository;

  GetUser(this.repository);

  @override
  Future<Either<Failure, User>> call(GetUserParams params) async {
    return await repository.getUserById(params.userId);
  }
}
```

### 3. Definir Constraints Claros

```markdown
## Constraints

- ONLY use packages from pubspec.yaml
- DO NOT create new methods in existing interfaces
- DO NOT use try/catch directly (use Either)
- MUST pass all tests in the contract
```

### 4. Especificar Formato de Output

```markdown
## Output Format

Provide ONLY the Dart code for the file:
`lib/features/products/domain/usecases/get_products.dart`

Do not include:
- Explanations
- Alternative implementations
- Comments about the code outside the file
```

---

## Debugging de Prompts

### Ver Prompt Generado

```bash
# Mostrar prompt sin ejecutar
sdda prompt usecase --feature=products --name=get_products --verbose

# Guardar a archivo para inspección
sdda prompt usecase --feature=products --name=get_products > debug_prompt.md
```

### Verificar Variables

```bash
# Mostrar variables disponibles
sdda prompt --show-variables --feature=products

# Output:
# Available variables:
# - {{feature_name}}: products
# - {{architecture_context}}: [148 lines]
# - {{example_usecase}}: [45 lines]
# ...
```

### Validar Template

```bash
# Verificar que el template es válido
sdda prompt --validate-template=custom/my_prompt.md

# Output:
# Template validation:
# ✓ All required variables present
# ✓ Syntax valid
# ⚠ Warning: {{custom_var}} not defined in context
```

---

## Siguiente Paso

Ver la [Referencia de Validadores](./VALIDATORS_REFERENCE.md) para detalles del sistema de validación.
