# 02 - Sistema de Prompts Parametrizables

## Filosofía de Prompts

Los prompts son la **interfaz** entre la especificación humana y la generación de código por IA. Un buen sistema de prompts:

1. **Es reproducible**: El mismo prompt produce resultados consistentes
2. **Es parametrizable**: Se adapta a diferentes contextos
3. **Es validable**: Incluye criterios claros de éxito
4. **Es versionado**: Evoluciona con el proyecto

---

## 1. Estructura de Prompts

### 1.1 Anatomía de un Prompt SDDA

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         ESTRUCTURA DE PROMPT SDDA                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ 1. SYSTEM CONTEXT                                                       │ │
│  │    Define el rol y restricciones del agente                            │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                    ▼                                         │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ 2. PROJECT CONTEXT                                                      │ │
│  │    Arquitectura, patrones, convenciones                                │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                    ▼                                         │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ 3. CONTRACTS (TESTS)                                                    │ │
│  │    Tests que el código DEBE pasar                                      │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                    ▼                                         │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ 4. TASK SPECIFICATION                                                   │ │
│  │    Qué debe hacer exactamente                                          │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                    ▼                                         │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ 5. OUTPUT FORMAT                                                        │ │
│  │    Cómo debe entregar el resultado                                     │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Biblioteca de Prompts

### 2.1 Estructura de Carpetas

```
sdda/
└── 04_prompts/
    ├── system/
    │   └── base_system_prompt.md       # Prompt de sistema base
    │
    ├── generation/
    │   ├── usecase_prompt.yaml         # Generar UseCase
    │   ├── bloc_prompt.yaml            # Generar BLoC
    │   ├── repository_prompt.yaml      # Generar Repository
    │   ├── widget_prompt.yaml          # Generar Widget
    │   ├── page_prompt.yaml            # Generar Page
    │   └── model_prompt.yaml           # Generar Model
    │
    ├── testing/
    │   ├── unit_test_prompt.yaml       # Generar tests unitarios
    │   ├── widget_test_prompt.yaml     # Generar tests de widgets
    │   ├── integration_test_prompt.yaml # Generar tests de integración
    │   └── golden_test_prompt.yaml     # Generar golden tests
    │
    ├── review/
    │   ├── code_review_prompt.yaml     # Revisar código generado
    │   ├── security_review_prompt.yaml # Revisar seguridad
    │   └── performance_review_prompt.yaml # Revisar rendimiento
    │
    ├── refactor/
    │   ├── extract_method_prompt.yaml
    │   ├── rename_prompt.yaml
    │   └── optimize_prompt.yaml
    │
    └── fix/
        ├── bug_fix_prompt.yaml         # Corregir bug
        └── test_failure_prompt.yaml    # Corregir test fallido
```

---

## 3. Prompts de Generación

### 3.1 Prompt Base del Sistema

```markdown
<!-- sdda/04_prompts/system/base_system_prompt.md -->

# ROL

Eres un desarrollador Flutter senior especializado en Clean Architecture y TDD.
Tu tarea es IMPLEMENTAR código que cumpla EXACTAMENTE con las especificaciones
y tests proporcionados.

# REGLAS ABSOLUTAS

1. **NO INVENTAR**: No uses APIs, métodos o clases que no estén documentados
   en el contexto del proyecto. Si algo no está documentado, pregunta.

2. **SEGUIR PATRONES**: Replica EXACTAMENTE los patrones de código mostrados
   en los ejemplos. No "mejores" ni cambies el estilo.

3. **PASAR TESTS**: El código generado DEBE pasar todos los tests de contrato.
   Si un test parece incorrecto, repórtalo pero no lo ignores.

4. **MÍNIMO NECESARIO**: Implementa SOLO lo necesario para cumplir la
   especificación. No agregues funcionalidad especulativa.

5. **CONVENCIONES**: Sigue las convenciones de nombrado y estructura del
   proyecto al pie de la letra.

# PROCESO DE GENERACIÓN

1. Lee y comprende la especificación completa
2. Analiza los tests de contrato para entender el comportamiento esperado
3. Revisa los patrones y ejemplos existentes
4. Genera el código siguiendo exactamente los patrones
5. Verifica mentalmente que el código pasa todos los tests

# SI NO ENTIENDES ALGO

- Pregunta antes de asumir
- Señala ambigüedades en la especificación
- Indica si falta contexto necesario

# FORMATO DE RESPUESTA

Responde SIEMPRE con el código en bloques Dart marcados así:
```dart
// filepath: lib/features/[feature]/[layer]/[file].dart
[código]
```
```

### 3.2 Prompt para Generar UseCase

```yaml
# sdda/04_prompts/generation/usecase_prompt.yaml

prompt:
  name: "generate_usecase"
  version: "1.0"
  description: "Genera un UseCase siguiendo Clean Architecture"

  parameters:
    - name: "feature_name"
      type: "string"
      required: true
      description: "Nombre de la feature (ej: auth, products)"

    - name: "usecase_name"
      type: "string"
      required: true
      description: "Nombre del caso de uso (ej: login, get_products)"

    - name: "spec_id"
      type: "string"
      required: true
      description: "ID de la especificación relacionada"

  required_context:
    - "architecture_doc"
    - "usecase_pattern"
    - "repository_interface"
    - "entity_definitions"
    - "failure_types"
    - "contract_tests"

  template: |
    # SYSTEM
    {{system_prompt}}

    ---

    # CONTEXTO DEL PROYECTO

    ## Arquitectura
    {{architecture_doc}}

    ## Patrón de UseCase
    {{usecase_pattern}}

    ## Ejemplo de UseCase Existente
    ```dart
    {{existing_usecase_example}}
    ```

    ---

    # DEPENDENCIAS DISPONIBLES

    ## Repository Interface
    ```dart
    {{repository_interface}}
    ```

    ## Entidades
    ```dart
    {{entity_definitions}}
    ```

    ## Tipos de Failure
    ```dart
    {{failure_types}}
    ```

    ---

    # CONTRATO (TESTS QUE DEBE PASAR)

    ```dart
    {{contract_tests}}
    ```

    ---

    # TAREA

    Implementa el UseCase `{{usecase_name}}` para la feature `{{feature_name}}`.

    - Referencia: {{spec_id}}
    - Archivo destino: `lib/features/{{feature_name}}/domain/usecases/{{usecase_name}}_usecase.dart`

    ## Requisitos Específicos
    {{specific_requirements}}

    ---

    # OUTPUT

    Genera ÚNICAMENTE el archivo del UseCase.
    El código debe pasar todos los tests del contrato.

    ```dart
    // filepath: lib/features/{{feature_name}}/domain/usecases/{{usecase_name}}_usecase.dart
    ```
```

### 3.3 Prompt para Generar BLoC

```yaml
# sdda/04_prompts/generation/bloc_prompt.yaml

prompt:
  name: "generate_bloc"
  version: "1.0"
  description: "Genera un BLoC completo (bloc, events, states)"

  parameters:
    - name: "feature_name"
      type: "string"
      required: true

    - name: "bloc_name"
      type: "string"
      required: true

    - name: "events"
      type: "array"
      required: true
      description: "Lista de eventos que maneja el BLoC"

    - name: "states"
      type: "array"
      required: true
      description: "Lista de estados posibles"

  required_context:
    - "architecture_doc"
    - "bloc_pattern"
    - "usecases_available"
    - "contract_tests"

  template: |
    # SYSTEM
    {{system_prompt}}

    ---

    # CONTEXTO DEL PROYECTO

    ## Arquitectura
    {{architecture_doc}}

    ## Patrón de BLoC
    {{bloc_pattern}}

    ## Ejemplo de BLoC Existente
    ```dart
    {{existing_bloc_example}}
    ```

    ---

    # DEPENDENCIAS DISPONIBLES

    ## UseCases que puede usar este BLoC
    ```dart
    {{usecases_available}}
    ```

    ---

    # CONTRATO (TESTS QUE DEBE PASAR)

    ```dart
    {{contract_tests}}
    ```

    ---

    # TAREA

    Implementa el BLoC `{{bloc_name}}` para la feature `{{feature_name}}`.

    ## Events Requeridos
    {{#each events}}
    - `{{this.name}}`: {{this.description}}
    {{/each}}

    ## States Requeridos
    {{#each states}}
    - `{{this.name}}`: {{this.description}}
    {{/each}}

    ## Archivos a Generar
    1. `lib/features/{{feature_name}}/presentation/bloc/{{bloc_name}}_bloc.dart`
    2. `lib/features/{{feature_name}}/presentation/bloc/{{bloc_name}}_event.dart`
    3. `lib/features/{{feature_name}}/presentation/bloc/{{bloc_name}}_state.dart`

    ---

    # OUTPUT

    Genera los 3 archivos separados por `---FILE---`.
```

### 3.4 Prompt para Generar Widget

```yaml
# sdda/04_prompts/generation/widget_prompt.yaml

prompt:
  name: "generate_widget"
  version: "1.0"
  description: "Genera un Widget Flutter"

  parameters:
    - name: "widget_name"
      type: "string"
      required: true

    - name: "widget_type"
      type: "enum"
      values: ["stateless", "stateful"]
      required: true

    - name: "props"
      type: "array"
      description: "Propiedades del widget"

  required_context:
    - "design_system_doc"
    - "widget_patterns"
    - "theme_usage"
    - "accessibility_guidelines"
    - "widget_tests"

  template: |
    # SYSTEM
    {{system_prompt}}

    ---

    # CONTEXTO DEL PROYECTO

    ## Sistema de Diseño
    {{design_system_doc}}

    ## Patrones de Widget
    {{widget_patterns}}

    ## Uso del Theme
    ```dart
    {{theme_usage}}
    ```

    ## Accesibilidad
    {{accessibility_guidelines}}

    ---

    # CONTRATO (TESTS DEL WIDGET)

    ```dart
    {{widget_tests}}
    ```

    ---

    # TAREA

    Implementa el Widget `{{widget_name}}`.

    ## Propiedades
    {{#each props}}
    - `{{this.name}}`: {{this.type}} {{#if this.required}}(requerido){{/if}} - {{this.description}}
    {{/each}}

    ## Comportamiento Esperado
    {{behavior_description}}

    ## Requisitos de Accesibilidad
    - Semantic labels para lectores de pantalla
    - Suficiente contraste de colores
    - Tamaños táctiles mínimos de 48x48

    ---

    # OUTPUT

    ```dart
    // filepath: lib/features/{{feature_name}}/presentation/widgets/{{widget_name}}_widget.dart
    ```
```

---

## 4. Prompts de Testing

### 4.1 Prompt para Generar Tests Unitarios

```yaml
# sdda/04_prompts/testing/unit_test_prompt.yaml

prompt:
  name: "generate_unit_tests"
  version: "1.0"
  description: "Genera tests unitarios desde una especificación"

  parameters:
    - name: "target_class"
      type: "string"
      required: true
      description: "Clase a testear"

    - name: "spec_id"
      type: "string"
      required: true

  template: |
    # SYSTEM

    Eres un ingeniero de QA especializado en Flutter y TDD.
    Tu tarea es generar tests unitarios EXHAUSTIVOS que cubran todos los
    casos de la especificación.

    # REGLAS

    1. Usa el patrón AAA (Arrange-Act-Assert)
    2. Un test = una aserción principal
    3. Nombres descriptivos en español: "debe [acción] cuando [condición]"
    4. Cubre: casos felices, errores, edge cases, validaciones
    5. Usa mocktail para mocks

    ---

    # ESPECIFICACIÓN

    {{specification}}

    ---

    # CLASE A TESTEAR

    ```dart
    {{target_class_code}}
    ```

    ---

    # DEPENDENCIAS MOCKEABLES

    {{mockable_dependencies}}

    ---

    # TAREA

    Genera tests unitarios para `{{target_class}}` que cubran:

    1. Todos los criterios de aceptación
    2. Casos de error documentados
    3. Validaciones de entrada
    4. Edge cases (nulls, vacíos, límites)

    ## Cobertura Mínima Requerida
    - Líneas: 90%
    - Branches: 85%

    ---

    # OUTPUT

    ```dart
    // filepath: test/features/{{feature_name}}/domain/usecases/{{target_class}}_test.dart
    ```
```

### 4.2 Prompt para Generar Tests de Widget

```yaml
# sdda/04_prompts/testing/widget_test_prompt.yaml

prompt:
  name: "generate_widget_tests"
  version: "1.0"

  template: |
    # SYSTEM

    Eres un ingeniero de QA especializado en testing de UI Flutter.
    Genera tests de widget que verifiquen renderizado e interacciones.

    # REGLAS

    1. Usa WidgetTester y pumpWidget
    2. Verifica renderizado de elementos
    3. Prueba interacciones (tap, scroll, input)
    4. Prueba diferentes estados (loading, error, success)
    5. Usa Keys para encontrar widgets

    ---

    # WIDGET A TESTEAR

    ```dart
    {{widget_code}}
    ```

    ---

    # ESTADOS A PROBAR

    {{#each states}}
    - {{this.name}}: {{this.description}}
    {{/each}}

    ---

    # INTERACCIONES A PROBAR

    {{#each interactions}}
    - {{this.action}}: verifica que {{this.expected_result}}
    {{/each}}

    ---

    # OUTPUT

    ```dart
    // filepath: test/features/{{feature_name}}/presentation/widgets/{{widget_name}}_test.dart

    import 'package:flutter/material.dart';
    import 'package:flutter_test/flutter_test.dart';
    // ... imports

    void main() {
      // Tests aquí
    }
    ```
```

---

## 5. Prompts de Corrección

### 5.1 Prompt para Corregir Test Fallido

```yaml
# sdda/04_prompts/fix/test_failure_prompt.yaml

prompt:
  name: "fix_test_failure"
  version: "1.0"
  description: "Corrige código que no pasa un test"

  parameters:
    - name: "failing_test"
      type: "string"
      required: true

    - name: "error_message"
      type: "string"
      required: true

    - name: "current_implementation"
      type: "string"
      required: true

  template: |
    # SYSTEM

    Un test está fallando. Tu tarea es corregir la implementación
    para que pase el test. NO modifiques el test.

    # REGLAS

    1. Analiza el error cuidadosamente
    2. Identifica la causa raíz
    3. Corrige SOLO lo necesario
    4. No cambies comportamiento que otros tests validan
    5. Explica brevemente el cambio

    ---

    # TEST FALLIDO

    ```dart
    {{failing_test}}
    ```

    # MENSAJE DE ERROR

    ```
    {{error_message}}
    ```

    ---

    # IMPLEMENTACIÓN ACTUAL

    ```dart
    {{current_implementation}}
    ```

    ---

    # TAREA

    1. Explica por qué falla el test (2-3 líneas)
    2. Proporciona el código corregido
    3. Indica qué cambiaste y por qué

    ---

    # OUTPUT

    ## Análisis
    [Tu análisis aquí]

    ## Código Corregido
    ```dart
    // filepath: [mismo archivo]
    [código corregido]
    ```

    ## Cambios Realizados
    - [Lista de cambios]
```

### 5.2 Prompt para Code Review

```yaml
# sdda/04_prompts/review/code_review_prompt.yaml

prompt:
  name: "code_review"
  version: "1.0"

  template: |
    # SYSTEM

    Eres un revisor de código senior. Analiza el código generado
    verificando que cumple con los estándares del proyecto.

    # CHECKLIST DE REVISIÓN

    ## Funcionalidad
    - [ ] Cumple todos los requisitos de la especificación
    - [ ] Pasa todos los tests de contrato
    - [ ] Maneja todos los casos de error documentados

    ## Arquitectura
    - [ ] Sigue los patrones del proyecto
    - [ ] Respeta las capas de Clean Architecture
    - [ ] Las dependencias van en la dirección correcta

    ## Calidad
    - [ ] Código legible y bien nombrado
    - [ ] Sin código duplicado
    - [ ] Sin código muerto o comentado
    - [ ] Documentación donde es necesaria

    ## Seguridad
    - [ ] No hay secretos hardcodeados
    - [ ] Inputs validados
    - [ ] No hay vulnerabilidades obvias

    ---

    # CÓDIGO A REVISAR

    ```dart
    {{code_to_review}}
    ```

    ---

    # ESPECIFICACIÓN ORIGINAL

    {{specification}}

    ---

    # OUTPUT

    ## Resultado: [APROBADO / CAMBIOS REQUERIDOS / RECHAZADO]

    ## Hallazgos

    ### Críticos (bloquean aprobación)
    - [lista o "Ninguno"]

    ### Importantes (deben corregirse)
    - [lista o "Ninguno"]

    ### Sugerencias (opcionales)
    - [lista o "Ninguno"]

    ## Código Sugerido (si hay cambios)
    ```dart
    [código con correcciones]
    ```
```

---

## 6. Motor de Prompts

### 6.1 Implementación del Motor

```dart
// sdda/05_generators/prompt_engine.dart

import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:mustache_template/mustache_template.dart';

/// Motor para cargar y renderizar prompts parametrizables
class PromptEngine {
  final String promptsPath;
  final Map<String, String> _cache = {};

  PromptEngine({required this.promptsPath});

  /// Carga y renderiza un prompt con parámetros
  Future<String> render({
    required String promptName,
    required Map<String, dynamic> parameters,
    required Map<String, String> context,
  }) async {
    // Cargar template del prompt
    final promptConfig = await _loadPromptConfig(promptName);

    // Validar parámetros requeridos
    _validateParameters(promptConfig, parameters);

    // Cargar contexto requerido
    final fullContext = await _loadRequiredContext(
      promptConfig['required_context'] as List<String>? ?? [],
      context,
    );

    // Combinar todo
    final templateData = {
      ...parameters,
      ...fullContext,
      'system_prompt': await _loadSystemPrompt(),
    };

    // Renderizar template
    final template = Template(
      promptConfig['template'] as String,
      lenient: true,
    );

    return template.renderString(templateData);
  }

  Future<Map<String, dynamic>> _loadPromptConfig(String name) async {
    final file = File('$promptsPath/generation/$name.yaml');
    if (!await file.exists()) {
      throw PromptNotFoundException(name);
    }

    final content = await file.readAsString();
    final yaml = loadYaml(content) as YamlMap;
    return yaml['prompt'] as Map<String, dynamic>;
  }

  void _validateParameters(
    Map<String, dynamic> config,
    Map<String, dynamic> provided,
  ) {
    final required = (config['parameters'] as List?)
        ?.where((p) => p['required'] == true)
        .map((p) => p['name'] as String)
        .toList() ?? [];

    for (final param in required) {
      if (!provided.containsKey(param)) {
        throw MissingParameterException(param);
      }
    }
  }

  Future<Map<String, String>> _loadRequiredContext(
    List<String> required,
    Map<String, String> provided,
  ) async {
    final result = <String, String>{};

    for (final key in required) {
      if (provided.containsKey(key)) {
        result[key] = provided[key]!;
      } else {
        // Intentar cargar desde archivos de contexto
        final contextFile = await _findContextFile(key);
        if (contextFile != null) {
          result[key] = await contextFile.readAsString();
        } else {
          throw MissingContextException(key);
        }
      }
    }

    return result;
  }

  Future<File?> _findContextFile(String key) async {
    final possiblePaths = [
      'sdda/03_context/architecture/$key.md',
      'sdda/03_context/patterns/$key.md',
      'sdda/03_context/apis/$key.md',
    ];

    for (final path in possiblePaths) {
      final file = File(path);
      if (await file.exists()) {
        return file;
      }
    }

    return null;
  }

  Future<String> _loadSystemPrompt() async {
    if (_cache.containsKey('system_prompt')) {
      return _cache['system_prompt']!;
    }

    final file = File('$promptsPath/system/base_system_prompt.md');
    final content = await file.readAsString();
    _cache['system_prompt'] = content;
    return content;
  }
}

class PromptNotFoundException implements Exception {
  final String name;
  PromptNotFoundException(this.name);
  @override
  String toString() => 'Prompt no encontrado: $name';
}

class MissingParameterException implements Exception {
  final String parameter;
  MissingParameterException(this.parameter);
  @override
  String toString() => 'Parámetro requerido faltante: $parameter';
}

class MissingContextException implements Exception {
  final String context;
  MissingContextException(this.context);
  @override
  String toString() => 'Contexto requerido faltante: $context';
}
```

### 6.2 Uso del Motor de Prompts

```dart
// Ejemplo de uso

void main() async {
  final engine = PromptEngine(promptsPath: 'sdda/04_prompts');

  // Generar prompt para crear un UseCase
  final prompt = await engine.render(
    promptName: 'usecase_prompt',
    parameters: {
      'feature_name': 'auth',
      'usecase_name': 'login',
      'spec_id': 'AUTH-001',
      'specific_requirements': '''
        - Validar formato de email antes de llamar al repositorio
        - Validar longitud mínima de contraseña (8 caracteres)
        - Retornar ValidationFailure para errores de validación
      ''',
    },
    context: {
      'contract_tests': await File('test/contracts/login_test.dart').readAsString(),
      'repository_interface': await File('lib/features/auth/domain/repositories/auth_repository.dart').readAsString(),
    },
  );

  // Enviar prompt a la IA
  print(prompt);
}
```

---

## 7. Integración con APIs de IA

### 7.1 Cliente Genérico de IA

```dart
// sdda/05_generators/ai_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Cliente genérico para múltiples proveedores de IA
abstract class AIClient {
  Future<String> generate(String prompt);
}

class ClaudeClient implements AIClient {
  final String apiKey;
  final String model;

  ClaudeClient({
    required this.apiKey,
    this.model = 'claude-sonnet-4-20250514',
  });

  @override
  Future<String> generate(String prompt) async {
    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': model,
        'max_tokens': 8192,
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
      }),
    );

    final data = jsonDecode(response.body);
    return data['content'][0]['text'] as String;
  }
}

class OpenAIClient implements AIClient {
  final String apiKey;
  final String model;

  OpenAIClient({
    required this.apiKey,
    this.model = 'gpt-4-turbo-preview',
  });

  @override
  Future<String> generate(String prompt) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'max_tokens': 8192,
      }),
    );

    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'] as String;
  }
}

class GeminiClient implements AIClient {
  final String apiKey;
  final String model;

  GeminiClient({
    required this.apiKey,
    this.model = 'gemini-pro',
  });

  @override
  Future<String> generate(String prompt) async {
    final response = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1/models/$model:generateContent?key=$apiKey',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
      }),
    );

    final data = jsonDecode(response.body);
    return data['candidates'][0]['content']['parts'][0]['text'] as String;
  }
}
```

---

## 8. Pipeline de Generación Completo

```dart
// sdda/05_generators/code_generator.dart

class CodeGenerator {
  final PromptEngine promptEngine;
  final AIClient aiClient;
  final TestRunner testRunner;

  CodeGenerator({
    required this.promptEngine,
    required this.aiClient,
    required this.testRunner,
  });

  /// Genera código que pasa los tests de contrato
  Future<GenerationResult> generate({
    required String promptName,
    required Map<String, dynamic> parameters,
    required Map<String, String> context,
    required String contractTestPath,
    int maxRetries = 3,
  }) async {
    // 1. Renderizar prompt
    final prompt = await promptEngine.render(
      promptName: promptName,
      parameters: parameters,
      context: context,
    );

    String? generatedCode;
    List<String> errors = [];

    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      // 2. Generar código con IA
      final response = await aiClient.generate(
        attempt == 1 ? prompt : _buildRetryPrompt(prompt, errors),
      );

      // 3. Extraer código de la respuesta
      generatedCode = _extractCode(response);

      // 4. Guardar código temporalmente
      await _saveCode(generatedCode, parameters);

      // 5. Ejecutar tests de contrato
      final testResult = await testRunner.run(contractTestPath);

      if (testResult.passed) {
        return GenerationResult(
          success: true,
          code: generatedCode,
          attempts: attempt,
        );
      }

      errors = testResult.errors;
      print('Intento $attempt fallido. Errores: ${errors.join(", ")}');
    }

    return GenerationResult(
      success: false,
      code: generatedCode,
      attempts: maxRetries,
      errors: errors,
    );
  }

  String _buildRetryPrompt(String originalPrompt, List<String> errors) {
    return '''
$originalPrompt

---

# INTENTO ANTERIOR FALLIDO

El código generado anteriormente no pasó los tests.

## Errores:
${errors.map((e) => '- $e').join('\n')}

## Instrucciones:
1. Analiza los errores cuidadosamente
2. Corrige el código para que pase los tests
3. No cambies la estructura general, solo corrige los problemas
''';
  }

  String _extractCode(String response) {
    // Extraer bloques de código Dart de la respuesta
    final codeBlockRegex = RegExp(r'```dart\n([\s\S]*?)```');
    final matches = codeBlockRegex.allMatches(response);

    return matches.map((m) => m.group(1)!.trim()).join('\n\n');
  }

  Future<void> _saveCode(String code, Map<String, dynamic> params) async {
    // Guardar en la ubicación correcta según los parámetros
    // ...
  }
}

class GenerationResult {
  final bool success;
  final String? code;
  final int attempts;
  final List<String> errors;

  GenerationResult({
    required this.success,
    this.code,
    required this.attempts,
    this.errors = const [],
  });
}
```

---

## Siguiente Documento

El siguiente documento **03_Integracion_Metodologias.md** detallará cómo integrar TDD, DDD, ATDD y E2E en el flujo de trabajo.

---

**Documento parte del framework SDDA**
**Versión 1.0 - Noviembre 2025**
