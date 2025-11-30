# Ejemplo Completo: Feature Auth

Este directorio contiene un ejemplo completo del flujo SDDA para el feature de autenticación.

## Estructura

```
auth/
├── specs/                          # Especificaciones
│   └── auth_feature_spec.yaml      # Spec completa del feature
│
├── contracts/                      # Tests como contratos
│   ├── login_usecase_test.dart     # Contrato para LoginUseCase
│   └── auth_bloc_test.dart         # Contrato para AuthBloc
│
└── generated/                      # Código generado por IA
    └── (vacío - aquí va el código)
```

## Flujo SDDA

### 1. SPECIFY (Especificar)
El archivo `specs/auth_feature_spec.yaml` define completamente:
- Entidades del dominio (User)
- Casos de uso (Login, Logout, Register, etc.)
- Repository con sus métodos
- Endpoints de API
- Eventos y estados del BLoC
- Componentes de UI

### 2. CONTRACT (Contratar)
Los archivos en `contracts/` definen los tests que el código debe pasar:
- `login_usecase_test.dart`: Tests para validaciones, casos de éxito y error
- `auth_bloc_test.dart`: Tests de estados y transiciones del BLoC

### 3. GENERATE (Generar)
Usando SDDA, la IA genera el código:

```bash
# Generar el feature completo
sdda generate feature auth --spec=specs/auth_feature_spec.yaml

# O generar componentes individuales
sdda generate usecase Login --feature=auth
sdda generate bloc Auth --feature=auth
sdda generate repository Auth --feature=auth
```

### 4. VALIDATE (Validar)

```bash
# Validar que el código cumple convenciones
sdda validate --feature=auth

# Ejecutar tests (contratos)
flutter test test/features/auth/
```

## Prompt para Generación Manual

Si prefieres usar el prompt directamente con una IA:

```bash
# Generar prompt para LoginUseCase
sdda prompt usecase \
  --feature=auth \
  --name=Login \
  --return=User \
  --params=email:String,password:String

# Generar prompt para AuthBloc
sdda prompt bloc \
  --feature=auth \
  --name=Auth \
  --usecases=LoginUseCase,LogoutUseCase
```

## Archivos Esperados Después de Generación

```
lib/features/auth/
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart
│   │   └── auth_local_datasource.dart
│   ├── models/
│   │   └── user_model.dart
│   └── repositories/
│       └── auth_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   └── user.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── login_usecase.dart
│       ├── logout_usecase.dart
│       ├── register_usecase.dart
│       ├── get_current_user_usecase.dart
│       └── check_auth_status_usecase.dart
│
└── presentation/
    ├── bloc/
    │   ├── auth_bloc.dart
    │   ├── auth_event.dart
    │   └── auth_state.dart
    ├── pages/
    │   ├── login_page.dart
    │   └── register_page.dart
    └── widgets/
        ├── email_text_field.dart
        ├── password_text_field.dart
        └── login_button.dart

test/features/auth/
├── domain/usecases/
│   ├── login_usecase_test.dart
│   ├── logout_usecase_test.dart
│   └── ...
├── data/repositories/
│   └── auth_repository_impl_test.dart
└── presentation/bloc/
    └── auth_bloc_test.dart
```

## Criterios de Aceptación

El código generado DEBE:

1. **Pasar todos los tests** en `contracts/`
2. **Seguir la arquitectura** definida en `ARCHITECTURE.md`
3. **Cumplir convenciones** de `CONVENTIONS.md`
4. **Implementar exactamente** lo especificado en `auth_feature_spec.yaml`
5. **No tener errores** de análisis estático
6. **Tener cobertura** mínima del 80%

## Ejemplo de Uso del Feature

```dart
// En main.dart o router
BlocProvider(
  create: (context) => getIt<AuthBloc>()
    ..add(const CheckAuthStatusRequested()),
  child: BlocListener<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is AuthAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (state is AuthUnauthenticated) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    },
    child: const SplashPage(),
  ),
)

// En LoginPage
ElevatedButton(
  onPressed: () {
    context.read<AuthBloc>().add(LoginRequested(
      email: _emailController.text,
      password: _passwordController.text,
    ));
  },
  child: const Text('Iniciar Sesión'),
)
```
