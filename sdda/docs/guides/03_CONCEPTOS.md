# Conceptos Fundamentales de SDDA

Entender la filosofía y principios detrás del framework.

---

## Tabla de Contenidos

1. [El Problema que Resuelve SDDA](#el-problema-que-resuelve-sdda)
2. [Principio Fundamental](#principio-fundamental)
3. [Los Cuatro Pilares](#los-cuatro-pilares)
4. [Metodologías Integradas](#metodologías-integradas)
5. [El Contexto como Guardrail](#el-contexto-como-guardrail)
6. [Tests como Contratos](#tests-como-contratos)

---

## El Problema que Resuelve SDDA

### Problemas con IA Generativa de Código

| Problema | Descripción | Impacto |
|----------|-------------|---------|
| **Alucinaciones** | La IA inventa APIs, métodos o patrones que no existen | Código que no compila |
| **Inconsistencia** | Cada generación usa patrones diferentes | Base de código caótica |
| **Sin verificación** | No hay forma de saber si el código es correcto | Bugs en producción |
| **Desconexión** | El código generado no sigue la arquitectura del proyecto | Deuda técnica |

### La Solución SDDA

```
┌─────────────────────────────────────────────────────────────────┐
│                    ANTES (Generación Libre)                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Prompt vago  ───▶  IA imagina  ───▶  Código aleatorio        │
│                                                                 │
│   "Crea un login"    "Invento algo"    Puede o no funcionar    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    DESPUÉS (SDDA)                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Spec + Tests + Contexto  ───▶  IA implementa  ───▶  Validado │
│                                                                 │
│   Exacto y verificable         Sin inventar        Pasa tests  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Principio Fundamental

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║   "La IA NO imagina código, la IA IMPLEMENTA especificaciones"   ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
```

### Implicaciones

1. **La IA es un implementador, no un arquitecto**
   - No diseña, ejecuta diseños
   - No decide patrones, sigue patrones dados
   - No inventa APIs, usa APIs documentadas

2. **Todo debe estar especificado ANTES de generar**
   - Qué entidades existen
   - Qué métodos tienen
   - Qué tests deben pasar

3. **El código es verificable**
   - Contratos (tests) definen comportamiento correcto
   - Si pasa los tests, el código es correcto
   - Si no pasa, se regenera

---

## Los Cuatro Pilares

### 1. SPECIFY (Especificar)

```yaml
# ¿Qué se va a construir?
feature:
  name: auth

entities:
  - name: User
    properties:
      - name: id
        type: String

usecases:
  - name: Login
    params:
      - email: String
      - password: String
    return_type: User
```

**Propósito**: Definir EXACTAMENTE qué se necesita, sin ambigüedad.

### 2. CONTRACT (Contratar)

```dart
// ¿Cómo se comporta correctamente?
test('debe retornar User cuando credenciales son válidas', () async {
  // Arrange
  when(() => mockRepo.login(any(), any()))
      .thenAnswer((_) async => Right(tUser));

  // Act
  final result = await sut(LoginParams(email: tEmail, password: tPassword));

  // Assert
  expect(result, Right(tUser));
});
```

**Propósito**: Los tests definen el CONTRATO que el código debe cumplir.

### 3. GENERATE (Generar)

```bash
# La IA genera código que cumple el contrato
sdda generate feature auth --spec=auth_spec.yaml
```

**Propósito**: La IA implementa las especificaciones siguiendo el contexto.

### 4. VALIDATE (Validar)

```bash
# Verificar que cumple
flutter test test/features/auth/
sdda validate --feature=auth
```

**Propósito**: Confirmar que el código generado pasa todos los contratos.

---

## Metodologías Integradas

SDDA integra cuatro metodologías de desarrollo:

### ATDD (Acceptance Test-Driven Development)

**Define QUÉ debe hacer el sistema desde perspectiva de usuario**

```gherkin
Feature: Autenticación de usuario

  Scenario: Login exitoso
    Given un usuario registrado con email "test@test.com"
    When ingresa sus credenciales correctas
    Then debe ver la pantalla principal
    And su sesión debe estar activa
```

### TDD (Test-Driven Development)

**Define el COMPORTAMIENTO exacto de cada unidad**

```dart
// Test PRIMERO
test('debe retornar ValidationFailure cuando email está vacío', () async {
  final result = await sut(LoginParams(email: '', password: 'password'));
  expect(result.isLeft(), true);
});

// Código DESPUÉS
Future<Either<Failure, User>> call(LoginParams params) async {
  if (params.email.isEmpty) {
    return const Left(ValidationFailure('Email requerido'));
  }
  // ...
}
```

### DDD (Domain-Driven Design)

**Define CÓMO se modela el dominio**

```
┌─────────────────────────────────────────────────────────────┐
│                    DOMAIN LAYER                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   Entities        Value Objects       Aggregates            │
│   ─────────       ─────────────       ──────────            │
│   User            Email               UserAccount           │
│   Product         Money               ShoppingCart          │
│                   Password                                   │
│                                                              │
│   Repository Interfaces    Use Cases                        │
│   ─────────────────────    ─────────                        │
│   AuthRepository           LoginUseCase                     │
│   ProductRepository        GetProductsUseCase               │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### E2E (End-to-End Testing)

**Verifica FLUJOS completos de usuario**

```dart
// Con Patrol
patrolTest('usuario puede hacer login y ver productos', ($) async {
  // Navegar a login
  await $.pumpWidgetAndSettle(MyApp());

  // Ingresar credenciales
  await $(#emailField).enterText('test@test.com');
  await $(#passwordField).enterText('password123');
  await $(#loginButton).tap();

  // Verificar navegación
  expect($(#productsPage), findsOneWidget);
});
```

---

## El Contexto como Guardrail

### ¿Por qué el Contexto es Crítico?

El contexto previene que la IA "alucine" al darle:

1. **Arquitectura documentada** → Sabe dónde poner cada cosa
2. **Patrones de ejemplo** → Sabe CÓMO escribir el código
3. **Convenciones** → Sabe nombrar correctamente
4. **APIs disponibles** → Sabe qué puede usar

### Estructura del Contexto

```
03_context/
├── architecture/
│   └── ARCHITECTURE.md      # Capas, dependencias, flujo de datos
│
├── conventions/
│   └── CONVENTIONS.md       # Nombrado, formato, imports
│
├── patterns/
│   └── examples/
│       ├── example_usecase.dart      # "Así se ve un UseCase"
│       ├── example_bloc.dart         # "Así se ve un BLoC"
│       └── example_repository.dart   # "Así se ve un Repository"
│
├── api/
│   └── endpoints.yaml       # "Estas APIs existen"
│
└── schemas/
    └── models.yaml          # "Estos modelos de datos existen"
```

### Prompt con Contexto vs Sin Contexto

```
❌ SIN CONTEXTO:
"Crea un UseCase de login"
→ La IA inventa estructura, nombrado, patrones

✅ CON CONTEXTO:
"Crea un UseCase de login siguiendo:
 - Arquitectura: ARCHITECTURE.md
 - Patrón: example_usecase.dart
 - Convenciones: CONVENTIONS.md
 - Tests que debe pasar: login_usecase_test.dart"
→ La IA replica exactamente el patrón
```

---

## Tests como Contratos

### Filosofía

> "Un test no es verificación después del hecho, es un CONTRATO que define comportamiento correcto ANTES de implementar"

### Tipos de Contratos en SDDA

| Tipo | Define | Ejemplo |
|------|--------|---------|
| **Unit Tests** | Comportamiento de una unidad | "LoginUseCase retorna User cuando credenciales válidas" |
| **Widget Tests** | Comportamiento de UI | "LoginPage muestra error cuando login falla" |
| **BLoC Tests** | Transiciones de estado | "AuthBloc emite [Loading, Authenticated] en login exitoso" |
| **Integration Tests** | Interacción entre capas | "Repository coordina remote y local datasource" |
| **E2E Tests** | Flujos completos | "Usuario puede registrarse y hacer login" |

### El Contrato como Especificación Ejecutable

```dart
// Este test ES la especificación de LoginUseCase
group('LoginUseCase', () {
  // CONTRATO 1: Éxito
  test('debe retornar User cuando credenciales son válidas', () async {
    // ...
  });

  // CONTRATO 2: Validación de email
  test('debe retornar ValidationFailure cuando email está vacío', () async {
    // ...
  });

  // CONTRATO 3: Validación de password
  test('debe retornar ValidationFailure cuando password < 6 chars', () async {
    // ...
  });

  // CONTRATO 4: Error de servidor
  test('debe propagar ServerFailure del repository', () async {
    // ...
  });
});
```

Si el código generado pasa TODOS estos tests, cumple el contrato y es correcto.

---

## Resumen

| Concepto | Descripción |
|----------|-------------|
| **Spec-Driven** | Todo comienza con especificaciones claras |
| **Contract-First** | Tests definen comportamiento antes de código |
| **Context-Aware** | IA tiene todo el contexto necesario |
| **Validated Output** | Código verificado automáticamente |

---

## Siguiente Paso

Continúa con el [Tutorial de Feature](./04_TUTORIAL_FEATURE.md) para aplicar estos conceptos.
