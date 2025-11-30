# 01 - Infraestructura de Contexto para Agentes IA

## El Problema Central: Falta de Contexto

La razón principal por la que los agentes de IA alucinan es la **falta de contexto completo**. Cuando un desarrollador humano trabaja en un proyecto, tiene:

- Conocimiento de la arquitectura completa
- Memoria de decisiones pasadas
- Acceso a documentación interna
- Comprensión de convenciones del equipo
- Visión de código existente similar

**Un agente de IA comienza desde cero cada vez**, a menos que le proporcionemos esta información de forma estructurada.

---

## 1. Arquitectura de Contexto

### 1.1 Estructura de Carpetas

```
sdda/
└── 03_context/
    ├── architecture/
    │   ├── ARCHITECTURE.md           # Documento principal de arquitectura
    │   ├── layers.md                 # Descripción de capas
    │   ├── dependencies.md           # Mapa de dependencias
    │   └── decisions/                # Architecture Decision Records (ADRs)
    │       ├── ADR-001-state-management.md
    │       ├── ADR-002-api-client.md
    │       └── ADR-003-error-handling.md
    │
    ├── patterns/
    │   ├── PATTERNS.md               # Índice de patrones
    │   ├── bloc_pattern.md           # Cómo usar BLoC en este proyecto
    │   ├── repository_pattern.md     # Implementación de repositorios
    │   ├── usecase_pattern.md        # Estructura de casos de uso
    │   └── examples/                 # Ejemplos extraídos del código
    │       ├── example_bloc.dart
    │       ├── example_usecase.dart
    │       └── example_repository.dart
    │
    ├── apis/
    │   ├── API_CATALOG.md            # Catálogo de APIs internas
    │   ├── rest_api.yaml             # OpenAPI spec del backend
    │   ├── graphql_schema.graphql    # Schema GraphQL si aplica
    │   └── internal_services.md      # Servicios internos disponibles
    │
    ├── schemas/
    │   ├── SCHEMAS.md                # Índice de esquemas
    │   ├── user.json                 # Schema de User
    │   ├── product.json              # Schema de Product
    │   └── entities/                 # Definiciones de entidades
    │
    ├── conventions/
    │   ├── CONVENTIONS.md            # Convenciones del proyecto
    │   ├── naming.md                 # Convenciones de nombrado
    │   ├── file_structure.md         # Estructura de archivos
    │   └── code_style.md             # Estilo de código
    │
    └── glossary/
        └── GLOSSARY.md               # Glosario de términos del dominio
```

---

## 2. Documento de Arquitectura

### 2.1 Template de ARCHITECTURE.md

```markdown
# Arquitectura del Proyecto: [Nombre]

## Resumen
[Descripción breve de la aplicación y su propósito]

## Stack Tecnológico

| Categoría | Tecnología | Versión |
|-----------|------------|---------|
| Framework | Flutter | 3.24.x |
| Lenguaje | Dart | 3.5.x |
| State Management | flutter_bloc | 8.x |
| DI | get_it + injectable | latest |
| HTTP Client | dio | 5.x |
| Local Storage | hive | 2.x |
| Testing | flutter_test, mocktail, bloc_test | latest |

## Arquitectura de Capas

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  • Pages (Screens)                                          │
│  • Widgets                                                  │
│  • BLoCs / Cubits                                          │
├─────────────────────────────────────────────────────────────┤
│                     DOMAIN LAYER                             │
│  • Entities (Modelos de dominio puros)                      │
│  • Use Cases (Lógica de negocio)                           │
│  • Repository Interfaces (Contratos)                        │
├─────────────────────────────────────────────────────────────┤
│                      DATA LAYER                              │
│  • Repository Implementations                               │
│  • Data Sources (Remote / Local)                           │
│  • Models (DTOs)                                           │
├─────────────────────────────────────────────────────────────┤
│                      CORE LAYER                              │
│  • Utilities                                                │
│  • Constants                                                │
│  • Error Handling                                           │
│  • Network                                                  │
└─────────────────────────────────────────────────────────────┘
```

## Flujo de Datos

```
UI Event → BLoC → UseCase → Repository → DataSource → API/DB
    ↑                                                    │
    └────────────────────────────────────────────────────┘
                        (Response)
```

## Reglas de Dependencia

1. **Presentation** puede depender de: Domain
2. **Domain** NO depende de ninguna otra capa
3. **Data** puede depender de: Domain
4. **Core** es usado por todas las capas

## Manejo de Errores

Usamos el patrón `Either<Failure, Success>` de `dartz`:

```dart
// Siempre retornar Either, nunca lanzar excepciones
Future<Either<Failure, User>> login(String email, String password);
```

## Inyección de Dependencias

Usamos `get_it` con `injectable` para generación automática:

```dart
// Registrar con anotaciones
@lazySingleton
class MyRepository implements IMyRepository { }

// Acceder
final repo = getIt<IMyRepository>();
```
```

---

## 3. Patrones de Código

### 3.1 Patrón de UseCase

```markdown
# Patrón: UseCase

## Propósito
Encapsular una única operación de negocio.

## Estructura

```dart
/// Cada UseCase:
/// 1. Tiene UNA sola responsabilidad
/// 2. Recibe dependencias por constructor
/// 3. Implementa call() para ejecución
/// 4. Retorna Either<Failure, Success>
/// 5. Usa Params class para múltiples parámetros

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
```

## Ejemplo Real del Proyecto

```dart
// lib/features/auth/domain/usecases/login_usecase.dart

@lazySingleton
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    // Validación de entrada
    if (!EmailValidator.isValid(params.email)) {
      return Left(ValidationFailure('Email inválido'));
    }

    if (params.password.length < 8) {
      return Left(ValidationFailure('Contraseña muy corta'));
    }

    // Delegación al repositorio
    return _repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
```

## Reglas
- ✅ Un UseCase = Una operación
- ✅ Siempre retornar Either
- ✅ Validar entrada antes de procesar
- ✅ No acceder directamente a DataSources
- ❌ No tener lógica de UI
- ❌ No manejar navegación
```

### 3.2 Patrón de BLoC

```markdown
# Patrón: BLoC

## Propósito
Gestionar el estado de una feature específica.

## Estructura

```dart
/// Cada BLoC:
/// 1. Extiende Bloc<Event, State>
/// 2. Recibe UseCases por constructor
/// 3. Usa sealed classes para Events y States
/// 4. Emite estados inmutables

// Events - Lo que puede pasar
sealed class AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested({required this.email, required this.password});
}
class LogoutRequested extends AuthEvent {}

// States - Cómo se ve la UI
sealed class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
```

## Ejemplo Real del Proyecto

```dart
// lib/features/auth/presentation/bloc/auth_bloc.dart

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthBloc(
    this._loginUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase,
  ) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
```

## Reglas
- ✅ Un BLoC por feature/página
- ✅ Events describen acciones del usuario
- ✅ States describen la UI
- ✅ Usar sealed classes (Dart 3)
- ❌ No hacer llamadas HTTP directas
- ❌ No acceder a BuildContext
```

---

## 4. Catálogo de APIs Internas

### 4.1 API_CATALOG.md

```markdown
# Catálogo de APIs Internas

## Servicios Disponibles

### AuthRepository
**Ubicación:** `lib/features/auth/domain/repositories/auth_repository.dart`

```dart
abstract class AuthRepository {
  /// Inicia sesión con email y contraseña
  /// @throws NetworkFailure si no hay conexión
  /// @throws InvalidCredentialsFailure si las credenciales son inválidas
  Future<Either<Failure, User>> login(String email, String password);

  /// Cierra la sesión actual
  Future<Either<Failure, void>> logout();

  /// Obtiene el usuario actualmente autenticado
  /// @returns null si no hay sesión activa
  Future<Either<Failure, User?>> getCurrentUser();

  /// Registra un nuevo usuario
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  });
}
```

### ProductRepository
**Ubicación:** `lib/features/products/domain/repositories/product_repository.dart`

```dart
abstract class ProductRepository {
  /// Obtiene lista paginada de productos
  Future<Either<Failure, PaginatedList<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
  });

  /// Obtiene un producto por ID
  Future<Either<Failure, Product>> getProductById(String id);

  /// Obtiene productos favoritos del usuario
  Future<Either<Failure, List<Product>>> getFavorites();

  /// Agrega/quita producto de favoritos
  Future<Either<Failure, void>> toggleFavorite(String productId);
}
```

## Servicios de Infraestructura

### NetworkService
**Ubicación:** `lib/core/network/network_service.dart`

```dart
/// Cliente HTTP configurado con interceptores
/// - Agrega token de autenticación automáticamente
/// - Maneja refresh de tokens
/// - Logging en modo debug
/// - Timeout: 30 segundos

class NetworkService {
  Future<Response> get(String path, {Map<String, dynamic>? queryParams});
  Future<Response> post(String path, {dynamic data});
  Future<Response> put(String path, {dynamic data});
  Future<Response> delete(String path);
}
```

### StorageService
**Ubicación:** `lib/core/storage/storage_service.dart`

```dart
/// Almacenamiento local seguro
/// Usa Hive para datos no sensibles
/// Usa flutter_secure_storage para tokens

class StorageService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();

  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> clearUser();

  Future<void> clearAll();
}
```
```

---

## 5. Esquemas de Datos

### 5.1 Definición de Entidades

```json
// sdda/03_context/schemas/user.json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "User",
  "description": "Entidad de usuario del sistema",
  "type": "object",
  "properties": {
    "id": {
      "type": "string",
      "description": "Identificador único del usuario"
    },
    "email": {
      "type": "string",
      "format": "email",
      "description": "Email del usuario (único)"
    },
    "name": {
      "type": "string",
      "minLength": 2,
      "maxLength": 100,
      "description": "Nombre completo del usuario"
    },
    "avatarUrl": {
      "type": ["string", "null"],
      "format": "uri",
      "description": "URL del avatar del usuario"
    },
    "createdAt": {
      "type": "string",
      "format": "date-time",
      "description": "Fecha de creación de la cuenta"
    },
    "isVerified": {
      "type": "boolean",
      "default": false,
      "description": "Si el email ha sido verificado"
    }
  },
  "required": ["id", "email", "name", "createdAt"],
  "additionalProperties": false
}
```

### 5.2 Mapeo a Dart

```dart
// Generado desde el schema JSON

/// Entidad de dominio (inmutable, sin dependencias externas)
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final DateTime createdAt;
  final bool isVerified;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.createdAt,
    this.isVerified = false,
  });

  @override
  List<Object?> get props => [id, email, name, avatarUrl, createdAt, isVerified];
}

/// Modelo de datos (con serialización)
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.avatarUrl,
    required super.createdAt,
    super.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
    };
  }

  User toEntity() => User(
    id: id,
    email: email,
    name: name,
    avatarUrl: avatarUrl,
    createdAt: createdAt,
    isVerified: isVerified,
  );
}
```

---

## 6. Convenciones del Proyecto

### 6.1 CONVENTIONS.md

```markdown
# Convenciones del Proyecto

## Nombrado

### Archivos
- `snake_case` para todos los archivos Dart
- Sufijos según tipo:
  - `_page.dart` - Páginas/Screens
  - `_widget.dart` - Widgets reutilizables
  - `_bloc.dart` - BLoCs
  - `_cubit.dart` - Cubits
  - `_event.dart` - Eventos de BLoC
  - `_state.dart` - Estados de BLoC
  - `_repository.dart` - Repositorios
  - `_usecase.dart` - Casos de uso
  - `_model.dart` - Modelos de datos
  - `_service.dart` - Servicios
  - `_test.dart` - Tests

### Clases
- `PascalCase` para clases
- Prefijo `I` para interfaces: `IAuthRepository`
- Sufijo `Impl` para implementaciones: `AuthRepositoryImpl`
- Sufijo `Failure` para errores: `NetworkFailure`

### Variables y Métodos
- `camelCase` para variables y métodos
- Prefijo `_` para privados
- Prefijo `on` para handlers: `onLoginPressed`
- Prefijo `is/has/can` para booleanos: `isLoading`, `hasError`

## Estructura de Carpetas por Feature

```
features/
└── auth/
    ├── data/
    │   ├── datasources/
    │   │   ├── auth_local_datasource.dart
    │   │   └── auth_remote_datasource.dart
    │   ├── models/
    │   │   └── user_model.dart
    │   └── repositories/
    │       └── auth_repository_impl.dart
    ├── domain/
    │   ├── entities/
    │   │   └── user.dart
    │   ├── repositories/
    │   │   └── auth_repository.dart
    │   └── usecases/
    │       ├── login_usecase.dart
    │       └── logout_usecase.dart
    └── presentation/
        ├── bloc/
        │   ├── auth_bloc.dart
        │   ├── auth_event.dart
        │   └── auth_state.dart
        ├── pages/
        │   └── login_page.dart
        └── widgets/
            └── login_form.dart
```

## Imports

Orden de imports:
1. Dart SDK
2. Flutter
3. Paquetes externos (alfabético)
4. Imports del proyecto (relativos)

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/user.dart';
import '../domain/usecases/login_usecase.dart';
```

## Documentación

- Documentar todas las clases públicas
- Documentar métodos complejos
- Usar `///` para documentación Dart
- Incluir ejemplos en documentación de APIs

```dart
/// Caso de uso para iniciar sesión.
///
/// Ejemplo:
/// ```dart
/// final result = await loginUseCase(
///   LoginParams(email: 'user@test.com', password: 'pass123'),
/// );
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (user) => print('Bienvenido ${user.name}'),
/// );
/// ```
class LoginUseCase { }
```
```

---

## 7. Glosario de Dominio

### 7.1 GLOSSARY.md

```markdown
# Glosario de Términos del Dominio

## Autenticación

| Término | Definición | Uso en Código |
|---------|------------|---------------|
| **Usuario** | Persona registrada en el sistema | `User` entity |
| **Sesión** | Período de autenticación activa | `Session` entity |
| **Token** | Credencial de acceso temporal | `String authToken` |
| **Refresh Token** | Token para renovar acceso | `String refreshToken` |

## Productos

| Término | Definición | Uso en Código |
|---------|------------|---------------|
| **Producto** | Artículo disponible para compra | `Product` entity |
| **Categoría** | Clasificación de productos | `Category` entity |
| **SKU** | Código único de producto | `String sku` |
| **Inventario** | Cantidad disponible | `int stockQuantity` |

## Órdenes

| Término | Definición | Uso en Código |
|---------|------------|---------------|
| **Carrito** | Productos seleccionados antes de compra | `Cart` entity |
| **Orden** | Compra confirmada | `Order` entity |
| **Estado de Orden** | Fase del proceso de compra | `OrderStatus` enum |

## Estados de Orden

```dart
enum OrderStatus {
  pending,      // Pendiente de pago
  paid,         // Pagada, esperando envío
  shipped,      // Enviada
  delivered,    // Entregada
  cancelled,    // Cancelada
  refunded,     // Reembolsada
}
```
```

---

## 8. Cómo Usar el Contexto en Prompts

### 8.1 Prompt con Contexto Completo

```markdown
## CONTEXTO DEL PROYECTO

### Arquitectura
[Insertar contenido de ARCHITECTURE.md]

### Patrón a Usar
[Insertar patrón específico de patterns/]

### APIs Disponibles
[Insertar servicios relevantes de API_CATALOG.md]

### Esquemas de Datos
[Insertar schemas relevantes]

### Convenciones
[Insertar CONVENTIONS.md]

### Glosario
[Insertar términos relevantes de GLOSSARY.md]

---

## TAREA

Implementar: [Nombre de la feature]

## TESTS QUE DEBE PASAR

```dart
[Insertar contract tests]
```

## INSTRUCCIONES

1. Sigue EXACTAMENTE los patrones mostrados
2. Usa SOLO las APIs documentadas
3. Respeta las convenciones de nombrado
4. El código debe pasar todos los tests
```

---

## 9. Automatización de Contexto

### 9.1 Script de Generación de Contexto

```dart
// sdda/tools/context_builder.dart

import 'dart:io';

class ContextBuilder {
  final String projectPath;

  ContextBuilder(this.projectPath);

  /// Genera contexto completo para una feature
  Future<String> buildContextForFeature(String featureName) async {
    final buffer = StringBuffer();

    buffer.writeln('## CONTEXTO DEL PROYECTO\n');

    // Arquitectura
    buffer.writeln('### Arquitectura');
    buffer.writeln(await _readFile('sdda/03_context/architecture/ARCHITECTURE.md'));

    // Patrón relevante
    buffer.writeln('### Patrones');
    buffer.writeln(await _readFile('sdda/03_context/patterns/usecase_pattern.md'));
    buffer.writeln(await _readFile('sdda/03_context/patterns/bloc_pattern.md'));

    // APIs relacionadas
    buffer.writeln('### APIs Disponibles');
    buffer.writeln(await _extractRelevantApis(featureName));

    // Convenciones
    buffer.writeln('### Convenciones');
    buffer.writeln(await _readFile('sdda/03_context/conventions/CONVENTIONS.md'));

    return buffer.toString();
  }

  Future<String> _readFile(String path) async {
    final file = File('$projectPath/$path');
    if (await file.exists()) {
      return await file.readAsString();
    }
    return '(Archivo no encontrado: $path)';
  }

  Future<String> _extractRelevantApis(String featureName) async {
    // Lógica para extraer APIs relevantes según la feature
    // ...
    return '';
  }
}
```

---

## Siguiente Documento

El siguiente documento **02_Sistema_Especificaciones.md** detallará cómo crear especificaciones estructuradas que guíen la generación de código.

---

**Documento parte del framework SDDA**
**Versión 1.0 - Noviembre 2025**
