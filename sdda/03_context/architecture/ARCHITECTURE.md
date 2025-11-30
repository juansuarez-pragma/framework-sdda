# Arquitectura del Proyecto

## Resumen

Este proyecto Flutter sigue **Clean Architecture** con separación estricta de capas y el patrón **BLoC** para gestión de estado.

---

## Stack Tecnológico

| Categoría | Tecnología | Versión | Propósito |
|-----------|------------|---------|-----------|
| Framework | Flutter | 3.24.x | UI multiplataforma |
| Lenguaje | Dart | 3.5.x | Programación |
| State Management | flutter_bloc | 8.x | Gestión de estado |
| DI | get_it + injectable | latest | Inyección de dependencias |
| HTTP Client | dio | 5.x | Llamadas API |
| Local Storage | hive | 2.x | Persistencia local |
| Secure Storage | flutter_secure_storage | 9.x | Datos sensibles |
| Functional | dartz | 0.10.x | Either, Option |
| Equality | equatable | 2.x | Value equality |

---

## Diagrama de Capas

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────────────────┐  │
│  │   Pages     │  │   Widgets   │  │           BLoCs / Cubits            │  │
│  │  (Screens)  │  │(Reutilizab.)│  │  (State Management)                 │  │
│  └─────────────┘  └─────────────┘  └─────────────────────────────────────┘  │
│                            │ Solo conoce Domain                              │
├────────────────────────────┼────────────────────────────────────────────────┤
│                            ▼                                                 │
│                         DOMAIN LAYER                                         │
│  ┌─────────────┐  ┌─────────────────┐  ┌─────────────────────────────────┐  │
│  │  Entities   │  │    Use Cases    │  │    Repository Interfaces        │  │
│  │  (Modelos   │  │  (Lógica de     │  │    (Contratos)                  │  │
│  │   puros)    │  │   negocio)      │  │                                 │  │
│  └─────────────┘  └─────────────────┘  └─────────────────────────────────┘  │
│                            │ No depende de nada externo                      │
├────────────────────────────┼────────────────────────────────────────────────┤
│                            ▼                                                 │
│                          DATA LAYER                                          │
│  ┌─────────────────────┐  ┌─────────────────┐  ┌───────────────────────┐   │
│  │ Repository Impls    │  │  Data Sources   │  │       Models          │   │
│  │ (Implementaciones)  │  │ (Remote/Local)  │  │       (DTOs)          │   │
│  └─────────────────────┘  └─────────────────┘  └───────────────────────┘   │
│                            │ Implementa interfaces de Domain                 │
├────────────────────────────┼────────────────────────────────────────────────┤
│                            ▼                                                 │
│                          CORE LAYER                                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐    │
│  │   Error     │  │   Network   │  │     DI      │  │    Utils        │    │
│  │  Handling   │  │   Client    │  │  Container  │  │   Constants     │    │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────────┘    │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Reglas de Dependencia

```
┌────────────────────────────────────────────────────────────────────┐
│                    REGLAS DE DEPENDENCIA                            │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   Presentation  ───────────────────────────────────→  Domain       │
│        │                                                            │
│        │  ✅ Presentation PUEDE usar Domain                        │
│        │  ❌ Presentation NO PUEDE usar Data                       │
│        │                                                            │
│   Domain  ───────────────────────────────────────→  (Nada)         │
│        │                                                            │
│        │  ✅ Domain NO depende de nada                             │
│        │  ❌ Domain NO PUEDE usar Presentation ni Data             │
│        │                                                            │
│   Data  ─────────────────────────────────────────→  Domain         │
│        │                                                            │
│        │  ✅ Data PUEDE implementar interfaces de Domain           │
│        │  ❌ Data NO PUEDE usar Presentation                       │
│        │                                                            │
│   Core  ─────────────────────────────────────────→  (Todos)        │
│        │                                                            │
│        │  ✅ Core es usado por todas las capas                     │
│        │  ✅ Core no depende de ninguna capa específica            │
│                                                                     │
└────────────────────────────────────────────────────────────────────┘
```

---

## Estructura de Carpetas

```
lib/
├── core/                           # Código compartido
│   ├── constants/
│   │   └── app_constants.dart
│   ├── di/
│   │   ├── injection.dart          # Configuración GetIt
│   │   └── injection.config.dart   # Generado
│   ├── error/
│   │   ├── exceptions.dart         # Excepciones técnicas
│   │   └── failures.dart           # Errores de dominio
│   ├── network/
│   │   ├── api_client.dart         # Cliente Dio configurado
│   │   ├── api_interceptors.dart   # Interceptores
│   │   └── network_info.dart       # Conectividad
│   ├── storage/
│   │   ├── local_storage.dart      # Hive wrapper
│   │   └── secure_storage.dart     # Datos sensibles
│   └── utils/
│       ├── extensions/
│       └── helpers/
│
├── features/                       # Features por dominio
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       └── logout_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   └── login_page.dart
│   │       └── widgets/
│   │           └── login_form.dart
│   │
│   └── [otras_features]/
│
├── shared/                         # Widgets y utilidades compartidas
│   ├── widgets/
│   │   ├── buttons/
│   │   ├── inputs/
│   │   └── dialogs/
│   └── theme/
│       ├── app_theme.dart
│       └── app_colors.dart
│
└── main.dart                       # Entry point
```

---

## Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           FLUJO DE DATOS                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   1. Usuario interactúa con UI                                              │
│      │                                                                       │
│      ▼                                                                       │
│   2. Page envía Event al BLoC                                               │
│      │                                                                       │
│      │   LoginRequested(email, password)                                    │
│      ▼                                                                       │
│   3. BLoC ejecuta UseCase                                                   │
│      │                                                                       │
│      │   final result = await loginUseCase(params);                         │
│      ▼                                                                       │
│   4. UseCase valida y llama Repository                                      │
│      │                                                                       │
│      │   return repository.login(email, password);                          │
│      ▼                                                                       │
│   5. Repository coordina DataSources                                        │
│      │                                                                       │
│      │   try { remote } catch { local fallback }                            │
│      ▼                                                                       │
│   6. DataSource hace operación real                                         │
│      │                                                                       │
│      │   apiClient.post('/login', data)                                     │
│      ▼                                                                       │
│   7. Respuesta sube por la cadena                                           │
│      │                                                                       │
│      │   Either<Failure, User>                                              │
│      ▼                                                                       │
│   8. BLoC emite nuevo State                                                 │
│      │                                                                       │
│      │   emit(AuthAuthenticated(user))                                      │
│      ▼                                                                       │
│   9. UI se reconstruye con BlocBuilder                                      │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Manejo de Errores

### Patrón Either

Usamos `Either<Failure, Success>` de `dartz` para manejar errores de forma funcional:

```dart
// ❌ MAL: Excepciones
Future<User> login(String email, String password) async {
  try {
    return await api.login(email, password);
  } catch (e) {
    throw LoginException(e.message);
  }
}

// ✅ BIEN: Either
Future<Either<Failure, User>> login(String email, String password) async {
  try {
    final user = await api.login(email, password);
    return Right(user);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on NetworkException {
    return Left(NetworkFailure());
  }
}
```

### Jerarquía de Failures

```dart
// core/error/failures.dart

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Failures de infraestructura
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Error del servidor']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Sin conexión a internet']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Error de caché']) : super(message);
}

// Failures de dominio
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure([String message = 'Error de autenticación']) : super(message);
}

class InvalidCredentialsFailure extends AuthenticationFailure {
  const InvalidCredentialsFailure() : super('Credenciales inválidas');
}
```

---

## Inyección de Dependencias

Usamos `get_it` con `injectable` para generación automática:

```dart
// core/di/injection.dart

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```

### Anotaciones

```dart
// Singleton (una instancia compartida)
@lazySingleton
class ApiClient { }

// Singleton con interfaz
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository { }

// Factory (nueva instancia cada vez)
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> { }
```

---

## Referencias

- [Clean Architecture - Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter BLoC](https://bloclibrary.dev/)
- [Injectable](https://pub.dev/packages/injectable)
- [Dartz](https://pub.dev/packages/dartz)
