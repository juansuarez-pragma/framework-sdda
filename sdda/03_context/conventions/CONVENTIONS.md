# Convenciones del Proyecto

Este documento define las convenciones que DEBEN seguirse en todo el código del proyecto.

---

## 1. Nombrado de Archivos

### Regla General
Todos los archivos Dart usan `snake_case`.

### Sufijos por Tipo

| Tipo | Sufijo | Ejemplo |
|------|--------|---------|
| Page/Screen | `_page.dart` | `login_page.dart` |
| Widget reutilizable | `_widget.dart` | `custom_button_widget.dart` |
| BLoC | `_bloc.dart` | `auth_bloc.dart` |
| BLoC Events | `_event.dart` | `auth_event.dart` |
| BLoC State | `_state.dart` | `auth_state.dart` |
| Cubit | `_cubit.dart` | `counter_cubit.dart` |
| UseCase | `_usecase.dart` | `login_usecase.dart` |
| Repository (interfaz) | `_repository.dart` | `auth_repository.dart` |
| Repository (impl) | `_repository_impl.dart` | `auth_repository_impl.dart` |
| DataSource | `_datasource.dart` | `auth_remote_datasource.dart` |
| Model/DTO | `_model.dart` | `user_model.dart` |
| Entity | `.dart` (sin sufijo) | `user.dart` |
| Service | `_service.dart` | `analytics_service.dart` |
| Test | `_test.dart` | `login_usecase_test.dart` |

---

## 2. Nombrado de Clases

### Regla General
`PascalCase` para todas las clases.

### Convenciones Específicas

```dart
// Interfaces/Abstracciones - NO usar prefijo I
abstract class AuthRepository { }  // ✅
abstract class IAuthRepository { } // ❌

// Implementaciones - Sufijo Impl
class AuthRepositoryImpl implements AuthRepository { }  // ✅

// Failures - Sufijo Failure
class InvalidCredentialsFailure extends Failure { }  // ✅

// Exceptions - Sufijo Exception
class ServerException implements Exception { }  // ✅

// Events de BLoC - Verbos en pasado o sustantivos
class LoginRequested extends AuthEvent { }     // ✅
class UserLoggedIn extends AuthEvent { }       // ✅

// States de BLoC - Adjetivos o estados
class AuthLoading extends AuthState { }        // ✅
class AuthAuthenticated extends AuthState { }  // ✅

// Params de UseCase - Sufijo Params
class LoginParams extends Equatable { }        // ✅
```

---

## 3. Nombrado de Variables y Métodos

### Regla General
`camelCase` para variables y métodos.

### Prefijos Especiales

```dart
// Privados - prefijo underscore
final _authRepository;
void _handleLogin() { }

// Booleanos - prefijos is/has/can/should
bool isLoading = false;
bool hasError = true;
bool canSubmit = true;
bool shouldRefresh = false;

// Callbacks/Handlers - prefijo on
void onLoginPressed() { }
void onEmailChanged(String value) { }

// Getters de estado - sin prefijo get
User get currentUser => _user;  // ✅
User getCurrentUser() { }        // ❌ (para métodos async sí)
```

### Variables de Test

```dart
// Prefijo t para test data
const tEmail = 'test@example.com';
const tPassword = 'password123';
final tUser = User(id: '1', email: tEmail);

// sut para System Under Test
late LoginUseCase sut;

// mock para mocks
late MockAuthRepository mockRepository;
```

---

## 4. Estructura de Feature

Cada feature sigue esta estructura exacta:

```
features/
└── [nombre_feature]/
    ├── data/
    │   ├── datasources/
    │   │   ├── [feature]_local_datasource.dart
    │   │   └── [feature]_remote_datasource.dart
    │   ├── models/
    │   │   └── [entity]_model.dart
    │   └── repositories/
    │       └── [feature]_repository_impl.dart
    │
    ├── domain/
    │   ├── entities/
    │   │   └── [entity].dart
    │   ├── repositories/
    │   │   └── [feature]_repository.dart
    │   └── usecases/
    │       └── [action]_usecase.dart
    │
    └── presentation/
        ├── bloc/
        │   ├── [feature]_bloc.dart
        │   ├── [feature]_event.dart
        │   └── [feature]_state.dart
        ├── pages/
        │   └── [nombre]_page.dart
        └── widgets/
            └── [nombre]_widget.dart
```

---

## 5. Imports

### Orden de Imports

1. Dart SDK
2. Flutter
3. Paquetes externos (alfabético)
4. Imports del proyecto (relativos preferidos dentro de feature)

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Paquetes externos (alfabético)
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 4. Imports del proyecto
import '../../../core/error/failures.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/auth_repository.dart';
```

### Separación
Una línea en blanco entre cada grupo.

---

## 6. Documentación

### Cuándo Documentar

- ✅ Clases públicas
- ✅ Métodos públicos complejos
- ✅ Parámetros no obvios
- ❌ Código auto-explicativo
- ❌ Getters/setters simples

### Formato

```dart
/// Caso de uso para autenticar un usuario.
///
/// Valida las credenciales y retorna el usuario autenticado
/// o un [Failure] si las credenciales son inválidas.
///
/// Ejemplo:
/// ```dart
/// final result = await loginUseCase(
///   LoginParams(email: 'user@test.com', password: 'pass123'),
/// );
/// ```
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository _repository;

  /// Crea una instancia de [LoginUseCase].
  ///
  /// Requiere un [AuthRepository] para realizar la autenticación.
  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    // Implementación...
  }
}
```

---

## 7. Formato de Código

### Llaves

```dart
// ✅ BIEN: Llaves en la misma línea
if (condition) {
  doSomething();
}

// ❌ MAL: Llaves en línea siguiente
if (condition)
{
  doSomething();
}
```

### Trailing Commas

```dart
// ✅ BIEN: Trailing comma para mejor formato
final user = User(
  id: '1',
  email: 'test@example.com',
  name: 'Test User',
);

// Widget con trailing comma
Container(
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
);
```

### Expresiones Largas

```dart
// ✅ BIEN: Dividir en múltiples líneas
final result = await repository
    .getProducts(page: 1, limit: 20)
    .then((products) => products.where((p) => p.isAvailable));

// ✅ BIEN: Cascade notation
final user = User()
  ..name = 'John'
  ..email = 'john@test.com'
  ..age = 30;
```

---

## 8. BLoC / State Management

### Estructura de BLoC

```dart
// [feature]_bloc.dart
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc(
    this._loginUseCase,
    this._logoutUseCase,
  ) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
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

### Events (sealed class)

```dart
// [feature]_event.dart
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
```

### States (sealed class)

```dart
// [feature]_state.dart
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
```

---

## 9. Testing

### Estructura AAA

```dart
test('descripción clara del comportamiento esperado', () async {
  // Arrange - Preparar datos y mocks
  when(() => mockRepository.login(any(), any()))
      .thenAnswer((_) async => Right(tUser));

  // Act - Ejecutar la acción
  final result = await sut(LoginParams(email: tEmail, password: tPassword));

  // Assert - Verificar resultados
  expect(result, Right(tUser));
  verify(() => mockRepository.login(tEmail, tPassword)).called(1);
});
```

### Naming de Tests

```dart
// Formato: "debe [acción] cuando [condición]"
test('debe retornar User cuando las credenciales son válidas', () { });
test('debe retornar InvalidCredentialsFailure cuando la contraseña es incorrecta', () { });
test('debe llamar al repository exactamente una vez', () { });
```

### Grupos de Tests

```dart
void main() {
  group('LoginUseCase', () {
    group('casos de éxito', () {
      test('debe retornar User cuando login es exitoso', () { });
    });

    group('casos de error', () {
      test('debe retornar failure cuando credenciales inválidas', () { });
    });

    group('validaciones', () {
      test('debe validar formato de email', () { });
    });
  });
}
```

---

## 10. Keys para Widgets

### Convención de Keys

```dart
// Keys para testing - usar ValueKey con string descriptivo
TextField(
  key: const ValueKey('email_field'),
);

ElevatedButton(
  key: const ValueKey('login_button'),
);

// Keys semánticas - usar Key con prefijo del widget
class LoginPage extends StatelessWidget {
  static const pageKey = Key('login_page');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: pageKey,
      // ...
    );
  }
}
```

---

## Checklist de Revisión

Antes de hacer commit, verificar:

- [ ] Archivos siguen convención de nombrado
- [ ] Clases siguen PascalCase
- [ ] Variables siguen camelCase
- [ ] Imports están ordenados
- [ ] Trailing commas donde corresponde
- [ ] Tests siguen patrón AAA
- [ ] Documentación en APIs públicas
- [ ] Keys en widgets testeables
