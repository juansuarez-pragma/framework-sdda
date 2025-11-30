# SDDA - Specification-Driven Development for AI Agents

## Plan Maestro para Automatización de Construcción de Código con IA

**Versión:** 1.0
**Fecha:** Noviembre 2025
**Enfoque:** Flutter

---

## 1. Resumen Ejecutivo

### 1.1 El Problema

Los agentes de IA actuales (Claude, GPT, Gemini, etc.) tienen un problema fundamental: **alucinan**. Cuando se les pide construir código sin un marco claro, tienden a:

- Inventar APIs que no existen
- Asumir estructuras de código incorrectas
- Generar código inconsistente con la arquitectura existente
- Ignorar patrones establecidos del proyecto
- Crear dependencias inexistentes

### 1.2 La Solución Propuesta

**SDDA (Specification-Driven Development for AI Agents)** es un framework que proporciona a los agentes de IA toda la infraestructura necesaria para generar código con **100% de certeza**, eliminando las alucinaciones mediante:

1. **Especificaciones Ejecutables**: Contratos que definen exactamente qué debe hacer el código
2. **Tests como Guía**: TDD/ATDD donde los tests existen ANTES del código
3. **Contexto Completo**: El agente conoce toda la arquitectura, patrones y convenciones
4. **Validación Automática**: El código generado debe pasar todos los tests para ser aceptado

### 1.3 Principio Fundamental

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│   "La IA NO imagina código, la IA IMPLEMENTA especificaciones"          │
│                                                                          │
│   Entrada: Especificación + Tests + Contexto → Salida: Código Validado  │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Estado del Arte - Herramientas Existentes

### 2.1 Agentes de Código Autónomos

| Herramienta | Tipo | Fortalezas | Debilidades |
|-------------|------|------------|-------------|
| **Devin** (Cognition AI) | Propietario | UI sofisticada, razonamiento complejo | Caja negra, costoso |
| **OpenHands** | Open Source | MIT License, comunidad activa, CLI | Requiere configuración |
| **SWE-agent** (Princeton) | Open Source | Benchmark SWE-bench, académico | Solo Python, limitado |
| **Claude Code** | CLI | Contexto largo, integración Git | Requiere guía clara |
| **AWS Kiro** | Enterprise | Flujo Specify→Plan→Execute | Atado a AWS |

### 2.2 Frameworks de Testing con IA para Flutter

| Herramienta | Propósito | Estado |
|-------------|-----------|--------|
| **Welltested AI** | Generación de tests unitarios/widget/integración | Activo |
| **TestSprite** | Testing automatizado en IDE | Emergente |
| **testRigor** | Tests en lenguaje natural | Maduro |
| **TestGrid** | Testing scriptless en dispositivos reales | Maduro |

### 2.3 Conceptos Clave Identificados

1. **Test-Driven Generation (TDG)**: TDD aplicado a generación con IA
2. **Spec-Driven Development (SDD)**: Especificación como fuente de verdad
3. **SuperSpec**: BDD para pipelines de agentes IA
4. **Design by Contract (DbC)**: Contratos formales entre componentes

---

## 3. Arquitectura del Framework SDDA

### 3.1 Visión General

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        FRAMEWORK SDDA PARA FLUTTER                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌───────────┐ │
│  │ 1. SPECIFY   │ →  │  2. CONTRACT │ →  │  3. GENERATE │ →  │ 4. VALIDATE│ │
│  │              │    │              │    │              │    │            │ │
│  │ • Requisitos │    │ • Tests ATDD │    │ • Código IA  │    │ • Ejecutar │ │
│  │ • User Story │    │ • Tests TDD  │    │ • Impl.      │    │ • Verificar│ │
│  │ • Criterios  │    │ • Contratos  │    │ • Refactor   │    │ • Aprobar  │ │
│  └──────────────┘    └──────────────┘    └──────────────┘    └───────────┘ │
│         │                   │                   │                  │        │
│         ▼                   ▼                   ▼                  ▼        │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │                     INFRAESTRUCTURA DE CONTEXTO                       │  │
│  │  • Arquitectura del proyecto    • Patrones de código                 │  │
│  │  • Dependencias disponibles     • Convenciones de nombrado           │  │
│  │  • APIs existentes              • Ejemplos de código similar         │  │
│  │  • Esquemas de datos            • Reglas de negocio                  │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Capas del Framework

```
sdda/
├── 01_specifications/          # Especificaciones de features
│   ├── templates/              # Plantillas de especificación
│   ├── features/               # Specs por feature
│   └── schemas/                # Esquemas JSON de validación
│
├── 02_contracts/               # Contratos y tests
│   ├── acceptance/             # Tests ATDD (Gherkin)
│   ├── behavior/               # Tests BDD
│   ├── unit/                   # Tests TDD (pre-escritos)
│   └── integration/            # Tests de integración
│
├── 03_context/                 # Contexto para la IA
│   ├── architecture/           # Documentación de arquitectura
│   ├── patterns/               # Patrones de código del proyecto
│   ├── apis/                   # Definiciones de APIs
│   ├── schemas/                # Esquemas de datos
│   └── examples/               # Ejemplos de código existente
│
├── 04_prompts/                 # Prompts parametrizables
│   ├── generation/             # Prompts de generación
│   ├── review/                 # Prompts de revisión
│   └── refactor/               # Prompts de refactorización
│
├── 05_generators/              # Generadores automáticos
│   ├── spec_generator.dart     # Genera specs desde requisitos
│   ├── test_generator.dart     # Genera tests desde specs
│   └── code_generator.dart     # Orquesta generación de código
│
└── sdda.yaml                   # Configuración principal
```

---

## 4. Flujo de Trabajo Detallado

### 4.1 Fase 1: SPECIFY (Especificación)

**Objetivo**: Convertir requisitos de negocio en especificaciones estructuradas.

```yaml
# sdda/01_specifications/features/auth/login_feature.yaml

feature:
  id: "AUTH-001"
  name: "Login de Usuario"
  version: "1.0"

  business_context:
    description: |
      Como usuario de la aplicación
      Quiero poder iniciar sesión con email y contraseña
      Para acceder a mi cuenta y datos personalizados

    stakeholders:
      - Product Owner
      - Equipo de Seguridad

    priority: "HIGH"

  acceptance_criteria:
    - id: "AC-001"
      given: "Un usuario registrado con email válido"
      when: "Ingresa credenciales correctas y presiona login"
      then: "Es redirigido al home con sesión activa"

    - id: "AC-002"
      given: "Un usuario con credenciales inválidas"
      when: "Intenta hacer login"
      then: "Ve mensaje de error y permanece en login"

    - id: "AC-003"
      given: "Un usuario sin conexión a internet"
      when: "Intenta hacer login"
      then: "Ve mensaje de error de conexión"

  technical_constraints:
    - "Usar AuthRepository existente"
    - "Implementar con BLoC pattern"
    - "Validación de email con regex estándar"
    - "Timeout de API: 30 segundos"

  data_contracts:
    input:
      - name: "email"
        type: "String"
        validation: "email_format"
        required: true
      - name: "password"
        type: "String"
        validation: "min_length:8"
        required: true

    output:
      success:
        type: "User"
        schema_ref: "schemas/user.json"
      failure:
        type: "AuthFailure"
        variants:
          - "InvalidCredentials"
          - "NetworkError"
          - "ServerError"
```

### 4.2 Fase 2: CONTRACT (Contratos y Tests)

**Objetivo**: Crear tests ejecutables ANTES del código.

```dart
// sdda/02_contracts/unit/auth/login_usecase_contract_test.dart

/// CONTRATO: LoginUseCase
///
/// Este test define el CONTRATO que debe cumplir cualquier implementación
/// de LoginUseCase. La IA debe generar código que pase estos tests.
///
/// Referencia: AUTH-001
/// Criterios de Aceptación: AC-001, AC-002, AC-003

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

// === CONTRATOS DE DEPENDENCIAS ===
abstract class AuthRepository {
  Future<Either<AuthFailure, User>> login(String email, String password);
}

// === CONTRATO DE SALIDA ===
abstract class AuthFailure {
  String get message;
}

class InvalidCredentialsFailure extends AuthFailure {
  @override
  String get message => 'Credenciales inválidas';
}

class NetworkFailure extends AuthFailure {
  @override
  String get message => 'Error de conexión';
}

// === MOCKS ===
class MockAuthRepository extends Mock implements AuthRepository {}
class FakeUser extends Fake implements User {}

void main() {
  late LoginUseCase sut; // System Under Test - A IMPLEMENTAR POR IA
  late MockAuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeUser());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    sut = LoginUseCase(repository: mockRepository);
  });

  group('LoginUseCase - Contrato AUTH-001', () {

    // AC-001: Login exitoso
    test(
      'DADO un usuario registrado con email válido '
      'CUANDO ingresa credenciales correctas '
      'ENTONCES retorna User exitosamente',
      () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        final expectedUser = User(id: '1', email: email, name: 'Test');

        when(() => mockRepository.login(email, password))
            .thenAnswer((_) async => Right(expectedUser));

        // Act
        final result = await sut(
          LoginParams(email: email, password: password),
        );

        // Assert
        expect(result, Right(expectedUser));
        verify(() => mockRepository.login(email, password)).called(1);
      },
    );

    // AC-002: Credenciales inválidas
    test(
      'DADO credenciales inválidas '
      'CUANDO intenta hacer login '
      'ENTONCES retorna InvalidCredentialsFailure',
      () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrongpassword';

        when(() => mockRepository.login(email, password))
            .thenAnswer((_) async => Left(InvalidCredentialsFailure()));

        // Act
        final result = await sut(
          LoginParams(email: email, password: password),
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
          (_) => fail('Debería retornar failure'),
        );
      },
    );

    // AC-003: Sin conexión
    test(
      'DADO que no hay conexión a internet '
      'CUANDO intenta hacer login '
      'ENTONCES retorna NetworkFailure',
      () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        when(() => mockRepository.login(email, password))
            .thenAnswer((_) async => Left(NetworkFailure()));

        // Act
        final result = await sut(
          LoginParams(email: email, password: password),
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Debería retornar failure'),
        );
      },
    );

    // Validación de entrada
    test(
      'DADO un email con formato inválido '
      'CUANDO intenta hacer login '
      'ENTONCES lanza ValidationException sin llamar al repository',
      () async {
        // Arrange
        const invalidEmail = 'not-an-email';
        const password = 'password123';

        // Act & Assert
        expect(
          () => sut(LoginParams(email: invalidEmail, password: password)),
          throwsA(isA<ValidationException>()),
        );
        verifyNever(() => mockRepository.login(any(), any()));
      },
    );
  });
}
```

### 4.3 Fase 3: GENERATE (Generación con IA)

**Objetivo**: La IA genera código que cumpla los contratos.

```yaml
# sdda/04_prompts/generation/usecase_prompt.yaml

prompt_template:
  name: "generate_usecase"
  version: "1.0"

  system_context: |
    Eres un desarrollador Flutter experto. Tu tarea es IMPLEMENTAR código
    que cumpla EXACTAMENTE con los contratos (tests) proporcionados.

    REGLAS ESTRICTAS:
    1. NO inventes APIs o métodos que no estén en el contexto
    2. NO agregues funcionalidad más allá de lo especificado
    3. SIGUE exactamente los patrones del proyecto
    4. El código DEBE pasar todos los tests proporcionados
    5. USA solo las dependencias listadas en pubspec.yaml

  required_context:
    - "architecture_doc"      # Documento de arquitectura
    - "contract_tests"        # Tests que debe pasar
    - "existing_patterns"     # Patrones de código existentes
    - "available_apis"        # APIs disponibles
    - "data_schemas"          # Esquemas de datos

  prompt_structure: |
    ## TAREA
    Implementar: {feature_name}
    Referencia: {spec_id}

    ## ARQUITECTURA DEL PROYECTO
    {architecture_doc}

    ## CONTRATOS (TESTS QUE DEBE PASAR)
    ```dart
    {contract_tests}
    ```

    ## PATRONES DE CÓDIGO EXISTENTES
    Ejemplo de UseCase similar en el proyecto:
    ```dart
    {similar_usecase_example}
    ```

    ## APIs DISPONIBLES
    {available_apis}

    ## ESQUEMAS DE DATOS
    {data_schemas}

    ## INSTRUCCIONES
    1. Analiza los tests y entiende qué debe hacer el código
    2. Revisa los patrones existentes y síguelos exactamente
    3. Implementa SOLO lo necesario para pasar los tests
    4. No agregues código especulativo o "por si acaso"

    ## OUTPUT ESPERADO
    Genera el archivo: lib/features/auth/domain/usecases/login_usecase.dart
```

### 4.4 Fase 4: VALIDATE (Validación)

**Objetivo**: Verificar que el código generado cumple los contratos.

```yaml
# sdda/05_generators/validation_pipeline.yaml

validation_pipeline:
  name: "code_validation"

  steps:
    - name: "syntax_check"
      command: "dart analyze {generated_file}"
      on_failure: "regenerate"

    - name: "format_check"
      command: "dart format --set-exit-if-changed {generated_file}"
      on_failure: "auto_fix"

    - name: "contract_tests"
      command: "flutter test {contract_test_file}"
      on_failure: "regenerate_with_error_context"
      max_retries: 3

    - name: "integration_check"
      command: "flutter test test/integration/"
      on_failure: "report"

    - name: "coverage_check"
      command: "flutter test --coverage"
      threshold: 90
      on_failure: "warn"

  on_success:
    - "commit_code"
    - "update_spec_status"
    - "notify_team"
```

---

## 5. Integración de Metodologías

### 5.1 TDD (Test-Driven Development)

```
┌─────────────────────────────────────────────────────────────────┐
│                    CICLO TDD CON IA                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│    ┌─────────┐                                                  │
│    │  RED    │ ← Humano escribe test que falla                  │
│    └────┬────┘                                                  │
│         │                                                        │
│         ▼                                                        │
│    ┌─────────┐                                                  │
│    │  GREEN  │ ← IA genera código mínimo para pasar test        │
│    └────┬────┘                                                  │
│         │                                                        │
│         ▼                                                        │
│    ┌─────────┐                                                  │
│    │REFACTOR │ ← IA refactoriza manteniendo tests verdes        │
│    └────┬────┘                                                  │
│         │                                                        │
│         └──────────────────────────────────────────────────→    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 5.2 DDD (Domain-Driven Design)

```yaml
# Estructura DDD que la IA debe respetar

domain_structure:
  bounded_contexts:
    - name: "authentication"
      entities:
        - User
        - Session
      value_objects:
        - Email
        - Password
      aggregates:
        - UserAggregate
      repositories:
        - AuthRepository
      services:
        - AuthenticationService
      events:
        - UserLoggedIn
        - UserLoggedOut
        - LoginFailed
```

### 5.3 ATDD (Acceptance Test-Driven Development)

```gherkin
# sdda/02_contracts/acceptance/auth/login.feature

Feature: Login de Usuario
  Como usuario de la aplicación
  Quiero poder iniciar sesión
  Para acceder a mi cuenta

  Background:
    Given la aplicación está iniciada
    And estoy en la pantalla de login

  @smoke @auth
  Scenario: Login exitoso con credenciales válidas
    Given tengo una cuenta registrada con email "user@test.com"
    When ingreso el email "user@test.com"
    And ingreso la contraseña "ValidPass123"
    And presiono el botón "Iniciar Sesión"
    Then debo ver la pantalla de inicio
    And debo ver mi nombre de usuario

  @auth @negative
  Scenario: Login fallido con contraseña incorrecta
    Given tengo una cuenta registrada con email "user@test.com"
    When ingreso el email "user@test.com"
    And ingreso la contraseña "WrongPassword"
    And presiono el botón "Iniciar Sesión"
    Then debo ver el mensaje "Credenciales inválidas"
    And debo permanecer en la pantalla de login

  @auth @edge-case
  Scenario Outline: Validación de formato de email
    When ingreso el email "<email>"
    And ingreso la contraseña "ValidPass123"
    And presiono el botón "Iniciar Sesión"
    Then debo ver el mensaje "<mensaje>"

    Examples:
      | email           | mensaje                    |
      | invalid         | Email con formato inválido |
      | @nodomain       | Email con formato inválido |
      | user@           | Email con formato inválido |
      | user@test.com   | (procede con login)        |
```

### 5.4 E2E Testing

```dart
// sdda/02_contracts/e2e/auth/login_e2e_test.dart

import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'E2E: Flujo completo de login',
    ($) async {
      // Iniciar app
      await $.pumpWidgetAndSettle(const MyApp());

      // Verificar pantalla de login
      expect($(#login_page), findsOneWidget);

      // Ingresar credenciales
      await $(#email_field).enterText('test@example.com');
      await $(#password_field).enterText('password123');

      // Presionar login
      await $(#login_button).tap();

      // Esperar navegación
      await $.pumpAndSettle();

      // Verificar llegada a home
      expect($(#home_page), findsOneWidget);
      expect($(#user_greeting).text, contains('Bienvenido'));
    },
  );
}
```

---

## 6. Próximos Pasos

Este documento establece el plan maestro. Los siguientes documentos detallarán:

1. **01_Infraestructura_Contexto.md** - Cómo construir el contexto para la IA
2. **02_Sistema_Especificaciones.md** - Sistema completo de especificaciones
3. **03_Contratos_Tests.md** - Generación automática de contratos
4. **04_Prompts_Parametrizables.md** - Biblioteca de prompts
5. **05_Pipeline_Validacion.md** - Pipeline de validación automática
6. **06_Integracion_CI_CD.md** - Integración con CI/CD
7. **07_Guia_Implementacion.md** - Guía paso a paso

---

## 7. Referencias

### Herramientas y Frameworks
- [OpenHands](https://openhands.dev/) - Plataforma open source para agentes de código
- [SWE-agent](https://arxiv.org/abs/2407.16741) - Agente de Princeton NLP
- [Welltested AI](https://medium.com/welltested-ai) - Testing Flutter con IA
- [TestSprite](https://www.testsprite.com) - Testing automatizado Flutter

### Conceptos y Metodologías
- [Spec-Driven Development](https://medium.com/@dave-patten/spec-driven-development-designing-before-you-code-again-21023ac91180)
- [Test-Driven Agentic Development](https://medium.com/@JeffInUptown/test-driven-agentic-development-how-tdd-and-specification-as-code-can-enable-autonomous-coding-6b1b4b7dd816)
- [ATDD-Driven AI Development](https://www.paulmduvall.com/atdd-driven-ai-development-how-prompting-and-tests-steer-the-code/)
- [BDD for AI Agents](https://medium.com/@meirgotroot/why-bdd-is-essential-in-the-age-of-ai-agents-65027f47f7f6)

### Guardrails y Validación
- [OpenAI Guardrails Cookbook](https://cookbook.openai.com/examples/how_to_use_guardrails)
- [Guardrails AI](https://www.guardrailsai.com/) - Framework de validación
- [Preventing LLM Hallucinations](https://www.voiceflow.com/blog/prevent-llm-hallucinations)

---

**Documento generado como parte del framework SDDA**
**Versión 1.0 - Noviembre 2025**
