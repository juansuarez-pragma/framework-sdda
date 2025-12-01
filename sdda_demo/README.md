# SDDA Demo - Proyecto de Prueba del Framework

Este proyecto demuestra el funcionamiento del framework **SDDA (Specification-Driven Development for AI Agents)** con una aplicación Flutter de gestión de tareas.

## Resultados de la Prueba

| Métrica | Resultado |
|---------|-----------|
| Tests | **44 pasando** |
| Cobertura | **100%** |
| Análisis estático | **0 errores** |

### Cobertura por Archivo

| Archivo | Líneas | Cobertura |
|---------|--------|-----------|
| `failures.dart` | 7/7 | 100% |
| `usecase.dart` | 3/3 | 100% |
| `task.dart` | 10/10 | 100% |
| `create_task_usecase.dart` | 8/8 | 100% |
| `get_tasks_usecase.dart` | 3/3 | 100% |
| `tasks_bloc.dart` | 28/28 | 100% |
| `tasks_event.dart` | 8/8 | 100% |
| `tasks_state.dart` | 11/11 | 100% |

## Estructura del Proyecto

```
sdda_demo/
├── lib/
│   ├── core/
│   │   ├── error/
│   │   │   ├── failures.dart
│   │   │   └── exceptions.dart
│   │   ├── usecases/
│   │   │   └── usecase.dart
│   │   └── network/
│   │       └── network_info.dart
│   └── features/
│       └── tasks/
│           ├── domain/
│           │   ├── entities/
│           │   │   └── task.dart
│           │   ├── repositories/
│           │   │   └── tasks_repository.dart
│           │   └── usecases/
│           │       ├── get_tasks_usecase.dart
│           │       └── create_task_usecase.dart
│           ├── data/
│           │   ├── repositories/
│           │   │   └── tasks_repository_impl.dart
│           │   └── datasources/
│           │       ├── tasks_remote_datasource.dart
│           │       └── tasks_local_datasource.dart
│           └── presentation/
│               ├── bloc/
│               │   ├── tasks_bloc.dart
│               │   ├── tasks_event.dart
│               │   └── tasks_state.dart
│               └── pages/
│                   └── tasks_page.dart
└── test/
    ├── core/
    │   ├── error/
    │   │   └── failures_test.dart
    │   └── usecases/
    │       └── usecase_test.dart
    └── features/
        └── tasks/
            ├── domain/
            │   ├── entities/
            │   │   └── task_test.dart
            │   └── usecases/
            │       ├── get_tasks_usecase_test.dart
            │       └── create_task_usecase_test.dart
            └── presentation/
                └── bloc/
                    └── tasks_bloc_test.dart
```

## Comandos SDDA Utilizados

```bash
# Inicializar SDDA en el proyecto
sdda init

# Generar feature completo
sdda generate feature tasks

# Generar usecases individuales
sdda generate usecase GetTasks --feature=tasks
sdda generate usecase CreateTask --feature=tasks
```

## Ejecutar Tests

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar con cobertura
flutter test --coverage

# Ver resumen de cobertura
cat coverage/lcov.info | grep -E "^(SF:|LF:|LH:)" | paste - - - | awk -F'[:\t]' '{file=$2; lf=$4; lh=$6; pct=(lf>0)?int(lh*100/lf):100; printf "%-60s %d/%d (%d%%)\n", file, lh, lf, pct}'
```

## Notas Técnicas

### Conflicto de Nombres con dartz

El paquete `dartz` exporta una clase `Task` que entra en conflicto con nuestra entidad `Task`. La solución es usar `hide Task` en las importaciones:

```dart
import 'package:dartz/dartz.dart' hide Task;
```

### Dependencias Principales

- `flutter_bloc`: Gestión de estado
- `dartz`: Programación funcional (Either)
- `equatable`: Comparación de objetos
- `get_it` + `injectable`: Inyección de dependencias
- `mocktail`: Mocking en tests
- `bloc_test`: Testing de BLoCs

## Licencia

MIT
