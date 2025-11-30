# 03 - Integración de Metodologías: TDD, DDD, ATDD y E2E

## Visión General

El framework SDDA integra múltiples metodologías de desarrollo y testing para crear un sistema donde la IA genera código con **certeza total**. Cada metodología aporta una capa de especificación que reduce la ambigüedad.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CAPAS DE ESPECIFICACIÓN SDDA                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                         ATDD / BDD                                   │   │
│   │        Especificación de NEGOCIO (Qué quiere el usuario)            │   │
│   │        Lenguaje: Gherkin (Given/When/Then)                          │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                    ▼                                         │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                           DDD                                        │   │
│   │        Especificación de DOMINIO (Cómo se modela el negocio)        │   │
│   │        Lenguaje: Entidades, Value Objects, Aggregates               │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                    ▼                                         │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                           TDD                                        │   │
│   │        Especificación de COMPORTAMIENTO (Cómo debe funcionar)       │   │
│   │        Lenguaje: Tests unitarios y de widget                        │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                    ▼                                         │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                          E2E                                         │   │
│   │        Especificación de FLUJO (Cómo se usa la aplicación)          │   │
│   │        Lenguaje: Tests de integración y Patrol                      │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 1. ATDD - Acceptance Test-Driven Development

### 1.1 Propósito en SDDA

ATDD define **QUÉ** debe hacer el sistema desde la perspectiva del usuario/negocio. Es el punto de entrada para toda nueva funcionalidad.

### 1.2 Flujo ATDD

```
┌─────────────────────────────────────────────────────────────────┐
│                      FLUJO ATDD EN SDDA                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. DEFINIR         2. ESCRIBIR        3. AUTOMATIZAR           │
│  ┌──────────┐       ┌──────────┐       ┌──────────┐            │
│  │ Criterios│ ───→  │ Gherkin  │ ───→  │ Step     │            │
│  │ Acepta-  │       │ Feature  │       │ Defini-  │            │
│  │ ción     │       │ File     │       │ tions    │            │
│  └──────────┘       └──────────┘       └──────────┘            │
│       │                   │                  │                  │
│       │                   │                  ▼                  │
│       │                   │           ┌──────────┐             │
│       │                   │           │ Tests    │             │
│       │                   │           │ Ejecut-  │             │
│       │                   │           │ ables    │             │
│       │                   │           └──────────┘             │
│       │                   │                  │                  │
│       │                   │                  ▼                  │
│       │                   │           ┌──────────┐             │
│       └───────────────────┴──────────→│ IA genera│             │
│                                       │ código   │             │
│                                       └──────────┘             │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 1.3 Estructura de Features Gherkin

```gherkin
# sdda/02_contracts/acceptance/auth/login.feature

@auth @smoke @priority-high
Feature: Autenticación de Usuario
  Como usuario de la aplicación
  Quiero poder iniciar sesión con mis credenciales
  Para acceder a mi cuenta y datos personalizados

  Background:
    Given la aplicación está iniciada
    And el usuario no tiene sesión activa

  # ================================================
  # ESCENARIOS PRINCIPALES (Happy Path)
  # ================================================

  @happy-path
  Scenario: Login exitoso con credenciales válidas
    Given existe un usuario registrado con:
      | email    | test@example.com |
      | password | SecurePass123!   |
      | name     | Juan Test        |
    When navego a la pantalla de login
    And ingreso el email "test@example.com"
    And ingreso la contraseña "SecurePass123!"
    And presiono el botón "Iniciar Sesión"
    Then debo ver la pantalla de inicio
    And debo ver el mensaje "Bienvenido, Juan Test"
    And mi sesión debe estar activa

  # ================================================
  # ESCENARIOS DE ERROR
  # ================================================

  @error-handling
  Scenario: Login fallido con contraseña incorrecta
    Given existe un usuario registrado con email "test@example.com"
    When navego a la pantalla de login
    And ingreso el email "test@example.com"
    And ingreso la contraseña "WrongPassword"
    And presiono el botón "Iniciar Sesión"
    Then debo ver el mensaje de error "Credenciales inválidas"
    And debo permanecer en la pantalla de login
    And mi sesión no debe estar activa

  @error-handling
  Scenario: Login fallido con usuario inexistente
    When navego a la pantalla de login
    And ingreso el email "noexiste@example.com"
    And ingreso la contraseña "AnyPassword123"
    And presiono el botón "Iniciar Sesión"
    Then debo ver el mensaje de error "Usuario no encontrado"

  @error-handling @network
  Scenario: Login fallido sin conexión a internet
    Given no hay conexión a internet
    When navego a la pantalla de login
    And ingreso el email "test@example.com"
    And ingreso la contraseña "SecurePass123!"
    And presiono el botón "Iniciar Sesión"
    Then debo ver el mensaje de error "Sin conexión a internet"
    And debo ver opción para reintentar

  # ================================================
  # VALIDACIONES DE ENTRADA
  # ================================================

  @validation
  Scenario Outline: Validación de formato de email
    When navego a la pantalla de login
    And ingreso el email "<email>"
    And ingreso la contraseña "ValidPass123"
    And presiono el botón "Iniciar Sesión"
    Then debo ver el mensaje de error "<mensaje>"

    Examples:
      | email              | mensaje                       |
      | invalid            | Formato de email inválido     |
      | @nodomain.com      | Formato de email inválido     |
      | user@              | Formato de email inválido     |
      | user @example.com  | Formato de email inválido     |

  @validation
  Scenario: Validación de contraseña muy corta
    When navego a la pantalla de login
    And ingreso el email "test@example.com"
    And ingreso la contraseña "123"
    And presiono el botón "Iniciar Sesión"
    Then debo ver el mensaje de error "La contraseña debe tener al menos 8 caracteres"

  # ================================================
  # ESTADOS DE UI
  # ================================================

  @ui-state
  Scenario: Mostrar loading durante login
    Given existe un usuario registrado con email "test@example.com"
    When navego a la pantalla de login
    And ingreso credenciales válidas
    And presiono el botón "Iniciar Sesión"
    Then debo ver un indicador de carga
    And el botón de login debe estar deshabilitado

  @ui-state
  Scenario: Campos vacíos al iniciar
    When navego a la pantalla de login
    Then el campo de email debe estar vacío
    And el campo de contraseña debe estar vacío
    And el botón "Iniciar Sesión" debe estar habilitado
```

### 1.4 Step Definitions para Flutter

```dart
// integration_test/step_definitions/auth_steps.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:patrol/patrol.dart';

/// Steps para feature de autenticación
class AuthSteps {

  /// Given la aplicación está iniciada
  static StepDefinitionGeneric appIsStarted() {
    return given<PatrolIntegrationTester>(
      'la aplicación está iniciada',
      (context) async {
        await context.tester.pumpWidgetAndSettle(const MyApp());
        expect(context.tester.$(MyApp), findsOneWidget);
      },
    );
  }

  /// Given existe un usuario registrado con:
  static StepDefinitionGeneric userExistsWithTable() {
    return given1<DataTable, PatrolIntegrationTester>(
      'existe un usuario registrado con:',
      (table, context) async {
        final data = table.asMap();
        await TestUserService.createUser(
          email: data['email']!,
          password: data['password']!,
          name: data['name'] ?? 'Test User',
        );
      },
    );
  }

  /// When navego a la pantalla de login
  static StepDefinitionGeneric navigateToLogin() {
    return when<PatrolIntegrationTester>(
      'navego a la pantalla de login',
      (context) async {
        // Si hay splash screen, esperar
        await context.tester.pumpAndSettle();

        // Verificar que estamos en login o navegar
        if (context.tester.$(LoginPage).evaluate().isEmpty) {
          await context.tester.$(#go_to_login_button).tap();
          await context.tester.pumpAndSettle();
        }

        expect(context.tester.$(LoginPage), findsOneWidget);
      },
    );
  }

  /// When ingreso el email "{string}"
  static StepDefinitionGeneric enterEmail() {
    return when1<String, PatrolIntegrationTester>(
      RegExp(r'ingreso el email "([^"]*)"'),
      (email, context) async {
        await context.tester.$(#email_field).enterText(email);
        await context.tester.pump();
      },
    );
  }

  /// When ingreso la contraseña "{string}"
  static StepDefinitionGeneric enterPassword() {
    return when1<String, PatrolIntegrationTester>(
      RegExp(r'ingreso la contraseña "([^"]*)"'),
      (password, context) async {
        await context.tester.$(#password_field).enterText(password);
        await context.tester.pump();
      },
    );
  }

  /// When presiono el botón "{string}"
  static StepDefinitionGeneric pressButton() {
    return when1<String, PatrolIntegrationTester>(
      RegExp(r'presiono el botón "([^"]*)"'),
      (buttonText, context) async {
        await context.tester.$(find.text(buttonText)).tap();
        await context.tester.pumpAndSettle();
      },
    );
  }

  /// Then debo ver la pantalla de inicio
  static StepDefinitionGeneric shouldSeeHomePage() {
    return then<PatrolIntegrationTester>(
      'debo ver la pantalla de inicio',
      (context) async {
        expect(context.tester.$(HomePage), findsOneWidget);
      },
    );
  }

  /// Then debo ver el mensaje "{string}"
  static StepDefinitionGeneric shouldSeeMessage() {
    return then1<String, PatrolIntegrationTester>(
      RegExp(r'debo ver el mensaje "([^"]*)"'),
      (message, context) async {
        expect(context.tester.$(find.text(message)), findsOneWidget);
      },
    );
  }

  /// Then debo ver el mensaje de error "{string}"
  static StepDefinitionGeneric shouldSeeErrorMessage() {
    return then1<String, PatrolIntegrationTester>(
      RegExp(r'debo ver el mensaje de error "([^"]*)"'),
      (message, context) async {
        expect(
          context.tester.$(find.byWidgetPredicate(
            (widget) => widget is Text &&
                widget.data == message &&
                widget.style?.color == Colors.red,
          )),
          findsOneWidget,
        );
      },
    );
  }
}
```

---

## 2. DDD - Domain-Driven Design

### 2.1 Propósito en SDDA

DDD define **CÓMO** se modela el negocio. Proporciona el lenguaje ubicuo y la estructura del dominio que la IA debe respetar.

### 2.2 Modelo de Dominio como Especificación

```yaml
# sdda/01_specifications/domain/auth_domain.yaml

domain:
  name: "authentication"
  description: "Dominio de autenticación y gestión de usuarios"

  ubiquitous_language:
    - term: "Usuario"
      definition: "Persona registrada que puede acceder al sistema"
      code_name: "User"

    - term: "Sesión"
      definition: "Período de tiempo en que un usuario está autenticado"
      code_name: "Session"

    - term: "Credenciales"
      definition: "Par de email y contraseña para autenticación"
      code_name: "Credentials"

    - term: "Token de Acceso"
      definition: "Identificador temporal que autoriza operaciones"
      code_name: "AccessToken"

  entities:
    - name: "User"
      description: "Entidad principal del dominio de autenticación"
      identity: "id"
      properties:
        - name: "id"
          type: "UserId"
          description: "Identificador único del usuario"
        - name: "email"
          type: "Email"
          description: "Email verificado del usuario"
        - name: "name"
          type: "String"
          description: "Nombre completo"
        - name: "createdAt"
          type: "DateTime"
          description: "Fecha de registro"
        - name: "isVerified"
          type: "bool"
          description: "Si el email ha sido verificado"
      invariants:
        - "El email debe ser único en el sistema"
        - "El nombre no puede estar vacío"

  value_objects:
    - name: "Email"
      description: "Dirección de correo electrónico válida"
      properties:
        - name: "value"
          type: "String"
      validations:
        - "Debe tener formato de email válido"
        - "No puede estar vacío"
      code_example: |
        class Email extends Equatable {
          final String value;

          Email._(this.value);

          factory Email(String value) {
            if (!_isValid(value)) {
              throw InvalidEmailException(value);
            }
            return Email._(value.toLowerCase().trim());
          }

          static bool _isValid(String value) {
            return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
          }

          @override
          List<Object> get props => [value];
        }

    - name: "Password"
      description: "Contraseña con requisitos de seguridad"
      properties:
        - name: "value"
          type: "String"
      validations:
        - "Mínimo 8 caracteres"
        - "Al menos una mayúscula"
        - "Al menos un número"
      notes: "Nunca almacenar en texto plano"

  aggregates:
    - name: "UserAggregate"
      root: "User"
      entities: []
      value_objects:
        - "Email"
        - "Password"
      description: "Agregado que gestiona la consistencia del usuario"

  repositories:
    - name: "AuthRepository"
      aggregate: "UserAggregate"
      operations:
        - name: "login"
          input: ["email: String", "password: String"]
          output: "Either<AuthFailure, User>"
          description: "Autentica usuario con credenciales"

        - name: "logout"
          input: []
          output: "Either<AuthFailure, void>"
          description: "Cierra la sesión activa"

        - name: "getCurrentUser"
          input: []
          output: "Either<AuthFailure, User?>"
          description: "Obtiene usuario de la sesión actual"

        - name: "register"
          input: ["email: String", "password: String", "name: String"]
          output: "Either<AuthFailure, User>"
          description: "Registra nuevo usuario"

  domain_events:
    - name: "UserLoggedIn"
      description: "Se dispara cuando un usuario inicia sesión exitosamente"
      payload:
        - "userId: String"
        - "timestamp: DateTime"

    - name: "UserLoggedOut"
      description: "Se dispara cuando un usuario cierra sesión"
      payload:
        - "userId: String"
        - "timestamp: DateTime"

    - name: "LoginFailed"
      description: "Se dispara cuando falla un intento de login"
      payload:
        - "email: String"
        - "reason: String"
        - "timestamp: DateTime"

  failures:
    - name: "AuthFailure"
      description: "Clase base para fallos de autenticación"
      subtypes:
        - name: "InvalidCredentialsFailure"
          message: "Credenciales inválidas"
        - name: "UserNotFoundFailure"
          message: "Usuario no encontrado"
        - name: "NetworkFailure"
          message: "Error de conexión"
        - name: "ServerFailure"
          message: "Error del servidor"
        - name: "SessionExpiredFailure"
          message: "Sesión expirada"
```

### 2.3 Generación de Código desde Modelo DDD

```dart
// sdda/05_generators/domain_generator.dart

/// Genera código de dominio desde especificación YAML
class DomainGenerator {
  final String specPath;

  DomainGenerator(this.specPath);

  /// Genera todos los archivos del dominio
  Future<void> generateDomain(String domainName) async {
    final spec = await _loadSpec('$specPath/domain/${domainName}_domain.yaml');
    final domain = spec['domain'] as Map<String, dynamic>;

    // Generar entidades
    for (final entity in domain['entities'] as List) {
      await _generateEntity(domainName, entity);
    }

    // Generar value objects
    for (final vo in domain['value_objects'] as List) {
      await _generateValueObject(domainName, vo);
    }

    // Generar failures
    await _generateFailures(domainName, domain['failures'] as List);

    // Generar interfaces de repositorio
    for (final repo in domain['repositories'] as List) {
      await _generateRepositoryInterface(domainName, repo);
    }

    // Generar eventos de dominio
    for (final event in domain['domain_events'] as List) {
      await _generateDomainEvent(domainName, event);
    }
  }

  Future<void> _generateEntity(String domain, Map<String, dynamic> entity) async {
    final code = '''
import 'package:equatable/equatable.dart';

/// ${entity['description']}
///
/// Invariantes:
${(entity['invariants'] as List).map((i) => '/// - $i').join('\n')}
class ${entity['name']} extends Equatable {
${(entity['properties'] as List).map((p) => '  final ${p['type']} ${p['name']};').join('\n')}

  const ${entity['name']}({
${(entity['properties'] as List).map((p) => '    required this.${p['name']},').join('\n')}
  });

  @override
  List<Object?> get props => [${(entity['properties'] as List).map((p) => p['name']).join(', ')}];
}
''';

    await _writeFile(
      'lib/features/$domain/domain/entities/${_toSnakeCase(entity['name'])}.dart',
      code,
    );
  }

  // ... más métodos de generación
}
```

---

## 3. TDD - Test-Driven Development

### 3.1 Propósito en SDDA

TDD define el **COMPORTAMIENTO EXACTO** de cada unidad de código. Los tests se escriben ANTES del código y sirven como contrato que la IA debe cumplir.

### 3.2 Ciclo TDD con IA

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         CICLO TDD CON IA                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   HUMANO                          IA                          SISTEMA       │
│   ──────                          ──                          ───────       │
│      │                            │                              │          │
│      │  1. Escribe test           │                              │          │
│      │─────────────────────────────────────────────────────────→│          │
│      │                            │                              │          │
│      │                            │    2. Test falla (RED)       │          │
│      │←─────────────────────────────────────────────────────────│          │
│      │                            │                              │          │
│      │  3. Envía test + contexto  │                              │          │
│      │──────────────────────────→│                              │          │
│      │                            │                              │          │
│      │                            │  4. Genera código            │          │
│      │                            │─────────────────────────────→│          │
│      │                            │                              │          │
│      │                            │    5. Ejecuta test           │          │
│      │                            │←─────────────────────────────│          │
│      │                            │                              │          │
│      │    [Si falla: loop 4-5]    │                              │          │
│      │                            │                              │          │
│      │                            │    6. Test pasa (GREEN)      │          │
│      │←─────────────────────────────────────────────────────────│          │
│      │                            │                              │          │
│      │  7. Solicita refactor      │                              │          │
│      │──────────────────────────→│                              │          │
│      │                            │                              │          │
│      │                            │  8. Refactoriza              │          │
│      │                            │─────────────────────────────→│          │
│      │                            │                              │          │
│      │                            │    9. Tests siguen pasando   │          │
│      │←─────────────────────────────────────────────────────────│          │
│      │                            │                              │          │
│      ▼                            ▼                              ▼          │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3.3 Estructura de Tests como Contrato

```dart
// sdda/02_contracts/unit/auth/login_usecase_contract.dart

/// ══════════════════════════════════════════════════════════════════════════
/// CONTRATO: LoginUseCase
/// ══════════════════════════════════════════════════════════════════════════
///
/// Este archivo define el CONTRATO que debe cumplir LoginUseCase.
/// La IA generará código que pase TODOS estos tests.
///
/// Especificación: AUTH-001
/// Criterios de Aceptación: AC-001, AC-002, AC-003
/// Modelo de Dominio: auth_domain.yaml
///
/// ══════════════════════════════════════════════════════════════════════════

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

// ═══════════════════════════════════════════════════════════════════════════
// SETUP: Interfaces y Mocks que el código generado debe usar
// ═══════════════════════════════════════════════════════════════════════════

// La IA debe implementar esta clase
// ignore: unused_element
abstract class _LoginUseCaseContract {
  Future<Either<AuthFailure, User>> call(LoginParams params);
}

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeUser extends Fake implements User {
  @override
  String get id => 'test-id';
  @override
  String get email => 'test@example.com';
  @override
  String get name => 'Test User';
}

// ═══════════════════════════════════════════════════════════════════════════
// TESTS DE CONTRATO
// ═══════════════════════════════════════════════════════════════════════════

void main() {
  late LoginUseCase sut;
  late MockAuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeUser());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    sut = LoginUseCase(repository: mockRepository);
  });

  group('LoginUseCase', () {
    // ─────────────────────────────────────────────────────────────────────
    // GRUPO 1: Casos de Éxito (Happy Path)
    // ─────────────────────────────────────────────────────────────────────

    group('Casos de éxito', () {
      test(
        'debe retornar User cuando las credenciales son válidas',
        () async {
          // Arrange
          const email = 'user@example.com';
          const password = 'ValidPass123';
          final expectedUser = User(
            id: '123',
            email: email,
            name: 'Test User',
            createdAt: DateTime.now(),
          );

          when(() => mockRepository.login(email, password))
              .thenAnswer((_) async => Right(expectedUser));

          // Act
          final result = await sut(LoginParams(
            email: email,
            password: password,
          ));

          // Assert
          expect(result.isRight(), true);
          result.fold(
            (failure) => fail('No debería fallar'),
            (user) {
              expect(user.id, '123');
              expect(user.email, email);
            },
          );
          verify(() => mockRepository.login(email, password)).called(1);
        },
      );
    });

    // ─────────────────────────────────────────────────────────────────────
    // GRUPO 2: Casos de Error
    // ─────────────────────────────────────────────────────────────────────

    group('Casos de error', () {
      test(
        'debe retornar InvalidCredentialsFailure cuando las credenciales son inválidas',
        () async {
          // Arrange
          const email = 'user@example.com';
          const password = 'WrongPassword';

          when(() => mockRepository.login(email, password))
              .thenAnswer((_) async => Left(InvalidCredentialsFailure()));

          // Act
          final result = await sut(LoginParams(
            email: email,
            password: password,
          ));

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
            (_) => fail('Debería retornar failure'),
          );
        },
      );

      test(
        'debe retornar NetworkFailure cuando no hay conexión',
        () async {
          // Arrange
          const email = 'user@example.com';
          const password = 'ValidPass123';

          when(() => mockRepository.login(email, password))
              .thenAnswer((_) async => Left(NetworkFailure()));

          // Act
          final result = await sut(LoginParams(
            email: email,
            password: password,
          ));

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('Debería retornar failure'),
          );
        },
      );
    });

    // ─────────────────────────────────────────────────────────────────────
    // GRUPO 3: Validaciones de Entrada
    // ─────────────────────────────────────────────────────────────────────

    group('Validaciones de entrada', () {
      test(
        'debe retornar ValidationFailure cuando el email tiene formato inválido',
        () async {
          // Arrange
          const invalidEmail = 'not-an-email';
          const password = 'ValidPass123';

          // Act
          final result = await sut(LoginParams(
            email: invalidEmail,
            password: password,
          ));

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<ValidationFailure>());
              expect(failure.message, contains('email'));
            },
            (_) => fail('Debería retornar validation failure'),
          );
          verifyNever(() => mockRepository.login(any(), any()));
        },
      );

      test(
        'debe retornar ValidationFailure cuando la contraseña es muy corta',
        () async {
          // Arrange
          const email = 'user@example.com';
          const shortPassword = '123';

          // Act
          final result = await sut(LoginParams(
            email: email,
            password: shortPassword,
          ));

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<ValidationFailure>());
              expect(failure.message, contains('contraseña'));
            },
            (_) => fail('Debería retornar validation failure'),
          );
          verifyNever(() => mockRepository.login(any(), any()));
        },
      );

      test(
        'debe retornar ValidationFailure cuando el email está vacío',
        () async {
          // Arrange
          const emptyEmail = '';
          const password = 'ValidPass123';

          // Act
          final result = await sut(LoginParams(
            email: emptyEmail,
            password: password,
          ));

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<ValidationFailure>()),
            (_) => fail('Debería retornar validation failure'),
          );
          verifyNever(() => mockRepository.login(any(), any()));
        },
      );
    });

    // ─────────────────────────────────────────────────────────────────────
    // GRUPO 4: Edge Cases
    // ─────────────────────────────────────────────────────────────────────

    group('Edge cases', () {
      test(
        'debe normalizar el email a minúsculas antes de enviar',
        () async {
          // Arrange
          const emailWithCaps = 'User@EXAMPLE.com';
          const password = 'ValidPass123';
          final expectedUser = FakeUser();

          when(() => mockRepository.login('user@example.com', password))
              .thenAnswer((_) async => Right(expectedUser));

          // Act
          await sut(LoginParams(
            email: emailWithCaps,
            password: password,
          ));

          // Assert - debe llamar con email normalizado
          verify(() => mockRepository.login('user@example.com', password)).called(1);
        },
      );

      test(
        'debe trimear espacios del email',
        () async {
          // Arrange
          const emailWithSpaces = '  user@example.com  ';
          const password = 'ValidPass123';
          final expectedUser = FakeUser();

          when(() => mockRepository.login('user@example.com', password))
              .thenAnswer((_) async => Right(expectedUser));

          // Act
          await sut(LoginParams(
            email: emailWithSpaces,
            password: password,
          ));

          // Assert
          verify(() => mockRepository.login('user@example.com', password)).called(1);
        },
      );
    });
  });
}
```

---

## 4. E2E - End-to-End Testing

### 4.1 Propósito en SDDA

E2E verifica que todos los componentes funcionan correctamente **integrados** y que los flujos de usuario completos funcionan en dispositivos reales.

### 4.2 Tests E2E con Patrol

```dart
// integration_test/flows/auth_flow_test.dart

import 'package:patrol/patrol.dart';
import 'package:my_app/main.dart' as app;

void main() {
  patrolTest(
    'Flujo completo: Login → Home → Logout',
    ($) async {
      // ═══════════════════════════════════════════════════════════════════
      // SETUP
      // ═══════════════════════════════════════════════════════════════════

      // Iniciar app
      app.main();
      await $.pumpAndSettle();

      // Crear usuario de prueba en backend
      await TestApiClient.createTestUser(
        email: 'e2e@test.com',
        password: 'TestPass123!',
        name: 'E2E User',
      );

      // ═══════════════════════════════════════════════════════════════════
      // PASO 1: Login
      // ═══════════════════════════════════════════════════════════════════

      // Verificar que estamos en login
      expect($(#login_page), findsOneWidget);

      // Ingresar credenciales
      await $(#email_field).enterText('e2e@test.com');
      await $(#password_field).enterText('TestPass123!');

      // Screenshot antes de login
      await $.takeScreenshot(name: 'login_filled');

      // Presionar login
      await $(#login_button).tap();

      // Esperar transición
      await $.pumpAndSettle(timeout: Duration(seconds: 10));

      // ═══════════════════════════════════════════════════════════════════
      // PASO 2: Verificar Home
      // ═══════════════════════════════════════════════════════════════════

      // Verificar que llegamos al home
      expect($(#home_page), findsOneWidget);

      // Verificar saludo personalizado
      expect($(find.textContaining('E2E User')), findsOneWidget);

      // Screenshot del home
      await $.takeScreenshot(name: 'home_after_login');

      // ═══════════════════════════════════════════════════════════════════
      // PASO 3: Logout
      // ═══════════════════════════════════════════════════════════════════

      // Abrir menú
      await $(#menu_button).tap();
      await $.pumpAndSettle();

      // Presionar logout
      await $(#logout_button).tap();
      await $.pumpAndSettle();

      // Confirmar logout en diálogo
      await $(find.text('Cerrar Sesión')).tap();
      await $.pumpAndSettle();

      // ═══════════════════════════════════════════════════════════════════
      // VERIFICACIÓN FINAL
      // ═══════════════════════════════════════════════════════════════════

      // Verificar que volvimos a login
      expect($(#login_page), findsOneWidget);

      // Screenshot final
      await $.takeScreenshot(name: 'back_to_login');

      // ═══════════════════════════════════════════════════════════════════
      // CLEANUP
      // ═══════════════════════════════════════════════════════════════════

      await TestApiClient.deleteTestUser('e2e@test.com');
    },
  );

  patrolTest(
    'Manejo de error de red durante login',
    nativeAutomation: true,
    ($) async {
      app.main();
      await $.pumpAndSettle();

      // Navegar a login
      expect($(#login_page), findsOneWidget);

      // Llenar credenciales
      await $(#email_field).enterText('test@example.com');
      await $(#password_field).enterText('TestPass123!');

      // Desactivar WiFi (requiere nativeAutomation)
      await $.native.disableWifi();

      // Intentar login
      await $(#login_button).tap();
      await $.pumpAndSettle();

      // Verificar mensaje de error de red
      expect($(find.text('Sin conexión a internet')), findsOneWidget);

      // Verificar botón de reintentar
      expect($(#retry_button), findsOneWidget);

      // Reactivar WiFi
      await $.native.enableWifi();
      await Future.delayed(Duration(seconds: 2));

      // Reintentar
      await $(#retry_button).tap();
      await $.pumpAndSettle();

      // Ahora debería funcionar
      expect($(#home_page), findsOneWidget);
    },
  );
}
```

### 4.3 Robot Pattern para E2E

```dart
// integration_test/robots/auth_robot.dart

/// Robot para interactuar con flujos de autenticación
class AuthRobot {
  final PatrolIntegrationTester $;

  AuthRobot(this.$);

  /// Verifica que estamos en la pantalla de login
  Future<void> verifyOnLoginPage() async {
    expect($(#login_page), findsOneWidget);
  }

  /// Ingresa credenciales de login
  Future<void> enterCredentials({
    required String email,
    required String password,
  }) async {
    await $(#email_field).enterText(email);
    await $(#password_field).enterText(password);
  }

  /// Presiona el botón de login
  Future<void> tapLogin() async {
    await $(#login_button).tap();
    await $.pumpAndSettle();
  }

  /// Realiza login completo
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await verifyOnLoginPage();
    await enterCredentials(email: email, password: password);
    await tapLogin();
  }

  /// Verifica que el login fue exitoso
  Future<void> verifyLoginSuccess() async {
    expect($(#home_page), findsOneWidget);
  }

  /// Verifica mensaje de error específico
  Future<void> verifyErrorMessage(String message) async {
    expect($(find.text(message)), findsOneWidget);
  }

  /// Realiza logout
  Future<void> logout() async {
    await $(#menu_button).tap();
    await $.pumpAndSettle();
    await $(#logout_button).tap();
    await $.pumpAndSettle();
    await $(find.text('Cerrar Sesión')).tap();
    await $.pumpAndSettle();
  }
}

// Uso en tests:
void main() {
  patrolTest('Login con robot', ($) async {
    app.main();
    await $.pumpAndSettle();

    final authRobot = AuthRobot($);

    await authRobot.login(
      email: 'test@example.com',
      password: 'TestPass123!',
    );

    await authRobot.verifyLoginSuccess();

    await authRobot.logout();

    await authRobot.verifyOnLoginPage();
  });
}
```

---

## 5. Pipeline de Integración

### 5.1 Flujo Completo desde Especificación hasta Código

```yaml
# sdda/pipeline.yaml

pipeline:
  name: "feature_development"
  description: "Pipeline completo de desarrollo de features"

  stages:
    # ═══════════════════════════════════════════════════════════════════════
    # STAGE 1: Especificación
    # ═══════════════════════════════════════════════════════════════════════
    - name: "specify"
      description: "Crear especificaciones de la feature"
      human_tasks:
        - "Definir requisitos de negocio"
        - "Escribir criterios de aceptación"
        - "Crear feature file Gherkin (ATDD)"
        - "Definir modelo de dominio (DDD)"
      outputs:
        - "sdda/01_specifications/features/{feature}/spec.yaml"
        - "sdda/01_specifications/domain/{feature}_domain.yaml"
        - "sdda/02_contracts/acceptance/{feature}/*.feature"

    # ═══════════════════════════════════════════════════════════════════════
    # STAGE 2: Contratos (Tests primero - TDD)
    # ═══════════════════════════════════════════════════════════════════════
    - name: "contract"
      description: "Crear tests de contrato antes del código"
      human_tasks:
        - "Escribir tests unitarios de contrato"
        - "Escribir tests de widget de contrato"
        - "Revisar y aprobar contratos"
      ai_tasks:
        - name: "Sugerir edge cases"
          prompt: "suggest_edge_cases"
        - name: "Generar tests de error"
          prompt: "generate_error_tests"
      outputs:
        - "sdda/02_contracts/unit/{feature}/*_contract_test.dart"
        - "sdda/02_contracts/widget/{feature}/*_contract_test.dart"

    # ═══════════════════════════════════════════════════════════════════════
    # STAGE 3: Generación (IA genera código)
    # ═══════════════════════════════════════════════════════════════════════
    - name: "generate"
      description: "IA genera código que cumple contratos"
      ai_tasks:
        - name: "Generar entidades"
          prompt: "generate_entity"
          for_each: "domain.entities"

        - name: "Generar value objects"
          prompt: "generate_value_object"
          for_each: "domain.value_objects"

        - name: "Generar repository interface"
          prompt: "generate_repository_interface"

        - name: "Generar usecases"
          prompt: "generate_usecase"
          for_each: "domain.usecases"

        - name: "Generar BLoC"
          prompt: "generate_bloc"

        - name: "Generar widgets"
          prompt: "generate_widget"
          for_each: "spec.widgets"

        - name: "Generar page"
          prompt: "generate_page"

      validation:
        - "flutter analyze"
        - "dart format --set-exit-if-changed ."
        - "flutter test {contract_tests}"

    # ═══════════════════════════════════════════════════════════════════════
    # STAGE 4: Integración
    # ═══════════════════════════════════════════════════════════════════════
    - name: "integrate"
      description: "Integrar con el resto del sistema"
      ai_tasks:
        - name: "Generar repository implementation"
          prompt: "generate_repository_impl"

        - name: "Actualizar DI"
          prompt: "update_di_config"

        - name: "Generar step definitions"
          prompt: "generate_step_definitions"

      validation:
        - "flutter test"
        - "flutter test integration_test/"

    # ═══════════════════════════════════════════════════════════════════════
    # STAGE 5: E2E
    # ═══════════════════════════════════════════════════════════════════════
    - name: "e2e"
      description: "Verificar flujos completos"
      human_tasks:
        - "Revisar tests E2E generados"
        - "Ejecutar en dispositivos reales"
      ai_tasks:
        - name: "Generar tests E2E"
          prompt: "generate_e2e_tests"

      validation:
        - "patrol test"
        - "firebase test lab"

    # ═══════════════════════════════════════════════════════════════════════
    # STAGE 6: Review
    # ═══════════════════════════════════════════════════════════════════════
    - name: "review"
      description: "Revisión final antes de merge"
      ai_tasks:
        - name: "Code review"
          prompt: "code_review"
        - name: "Security review"
          prompt: "security_review"

      human_tasks:
        - "Aprobar PR"

      validation:
        - "sonarqube analysis"
        - "coverage >= 80%"
```

---

## 6. Matriz de Trazabilidad

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    MATRIZ DE TRAZABILIDAD SDDA                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  REQUISITO      →    SPEC        →    CONTRACT    →    CODE      →   TEST   │
│  ──────────          ────             ────────         ────          ────    │
│                                                                              │
│  AUTH-001           spec.yaml        login_          LoginUseCase   unit/   │
│  "Login de          (AC-001,         contract_                      widget/ │
│   usuario"           AC-002,         test.dart                      e2e/    │
│                      AC-003)                                                 │
│       │                 │                │                │            │     │
│       │                 │                │                │            │     │
│       └─────────────────┴────────────────┴────────────────┴────────────┘     │
│                                                                              │
│  Cada requisito tiene trazabilidad completa desde negocio hasta código      │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Siguiente Documento

El siguiente documento **04_Guia_Implementacion.md** proporcionará la guía paso a paso para implementar SDDA en un proyecto real.

---

**Documento parte del framework SDDA**
**Versión 1.0 - Noviembre 2025**
