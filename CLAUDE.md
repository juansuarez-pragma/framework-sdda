# CLAUDE.md

Este archivo proporciona orientación a Claude Code (claude.ai/code) cuando trabaja con código en este repositorio.

## Descripción del Proyecto

Este proyecto implementa **SDDA (Specification-Driven Development for AI Agents)**, un framework completo que permite la generación de código 100% automatizada con IA para aplicaciones Flutter, eliminando alucinaciones mediante especificaciones estructuradas y tests como contratos.

### Principio Fundamental

```
"La IA NO imagina código, la IA IMPLEMENTA especificaciones"

Entrada: Especificación + Tests + Contexto → Salida: Código Validado
```

## Estructura del Proyecto

```
QEaC/
├── docs/                           # Documentación teórica del framework
│   ├── 00_SDDA_Plan_Maestro.md
│   ├── 01_Infraestructura_Contexto.md
│   ├── 02_Prompts_Parametrizables.md
│   ├── 03_Integracion_Metodologias.md
│   └── 04_Guia_Implementacion.md
│
├── sdda/                           # Framework SDDA IMPLEMENTADO
│   ├── sdda.yaml                   # Configuración principal
│   ├── analysis_options.yaml       # Reglas de linting estrictas
│   │
│   ├── 03_context/                 # Contexto para la IA
│   │   ├── architecture/
│   │   │   └── ARCHITECTURE.md     # Arquitectura Clean + BLoC
│   │   ├── conventions/
│   │   │   └── CONVENTIONS.md      # Convenciones de código
│   │   └── patterns/
│   │       └── examples/           # Patrones de referencia
│   │           ├── example_usecase.dart
│   │           ├── example_bloc.dart
│   │           └── example_repository.dart
│   │
│   ├── 04_prompts/                 # Prompts parametrizables
│   │   ├── system/
│   │   │   └── base_system_prompt.md
│   │   ├── generation/
│   │   │   ├── usecase_prompt.yaml
│   │   │   ├── bloc_prompt.yaml
│   │   │   ├── repository_prompt.yaml
│   │   │   └── feature_prompt.yaml
│   │   ├── testing/
│   │   │   ├── usecase_test_prompt.yaml
│   │   │   └── bloc_test_prompt.yaml
│   │   └── validation/
│   │       └── code_review_prompt.yaml
│   │
│   ├── 05_generators/              # CLI de generación
│   │   ├── pubspec.yaml
│   │   ├── bin/sdda.dart           # Entry point CLI
│   │   └── lib/
│   │       ├── commands/           # Comandos: generate, validate, prompt, init
│   │       ├── generators/         # Generadores de código
│   │       ├── validators/         # Validadores de código
│   │       ├── prompt_engine/      # Constructor de prompts
│   │       └── utils/
│   │
│   └── 06_examples/                # Ejemplos completos
│       └── auth/
│           ├── specs/auth_feature_spec.yaml
│           ├── contracts/          # Tests como contratos
│           └── README.md
│
└── QEaC_Flutter_Investigacion.md   # Documento de investigación base
```

## Flujo de Trabajo SDDA

```
1. SPECIFY    →    2. CONTRACT    →    3. GENERATE    →    4. VALIDATE
(Requisitos)       (Tests TDD)        (IA genera)        (Tests pasan)
```

### Metodologías Integradas

- **ATDD**: Define QUÉ debe hacer el sistema (Gherkin)
- **DDD**: Define CÓMO se modela el dominio
- **TDD**: Define el COMPORTAMIENTO exacto (tests primero)
- **E2E**: Verifica FLUJOS completos

## Comandos CLI SDDA

```bash
# Instalar CLI (desde sdda/05_generators/)
dart pub get
dart compile exe bin/sdda.dart -o sdda

# Inicializar SDDA en proyecto Flutter existente
sdda init

# Generar código
sdda generate feature <nombre>                    # Feature completo
sdda generate usecase <nombre> --feature=<feat>   # UseCase individual
sdda generate bloc <nombre> --feature=<feat>      # BLoC individual
sdda generate repository <nombre> --feature=<feat> # Repository

# Validar código
sdda validate --all                    # Todo el proyecto
sdda validate --feature=auth           # Un feature específico
sdda validate path/to/file.dart        # Archivo específico

# Generar prompts para IA
sdda prompt usecase --feature=auth --name=Login --return=User
sdda prompt bloc --feature=auth --name=Auth --usecases=LoginUseCase
sdda prompt review --file=path/to/file.dart
```

## Para Agentes de IA

### REGLAS OBLIGATORIAS al Generar Código

1. **LEER CONTEXTO PRIMERO**:
   - `sdda/03_context/architecture/ARCHITECTURE.md` - Arquitectura
   - `sdda/03_context/conventions/CONVENTIONS.md` - Convenciones
   - `sdda/03_context/patterns/examples/` - Patrones de referencia

2. **NO INVENTAR**: Solo usar APIs y patrones documentados
3. **SEGUIR PATRONES**: Replicar EXACTAMENTE los ejemplos
4. **PASAR TESTS**: El código DEBE pasar los contratos
5. **MÍNIMO NECESARIO**: Solo implementar lo especificado
6. **USAR Either<Failure, T>**: No lanzar excepciones

### Antes de Generar Cualquier Código

```
CHECKLIST:
[ ] Leí ARCHITECTURE.md
[ ] Leí CONVENTIONS.md
[ ] Revisé el patrón de ejemplo correspondiente
[ ] Tengo la especificación completa
[ ] Conozco los tests que debe pasar
```

### Estructura de Prompts

```
1. System Context (rol y reglas base)
2. Project Context (arquitectura, patrones, convenciones)
3. Contracts (tests que debe pasar el código)
4. Task Specification (qué implementar exactamente)
5. Output Format (código completo, listo para copiar)
```

### Archivos de Referencia Clave

| Componente | Patrón de Referencia |
|------------|---------------------|
| UseCase | `sdda/03_context/patterns/examples/example_usecase.dart` |
| BLoC | `sdda/03_context/patterns/examples/example_bloc.dart` |
| Repository | `sdda/03_context/patterns/examples/example_repository.dart` |
| Prompts | `sdda/04_prompts/generation/` |

## Arquitectura Flutter Target

```
lib/
├── core/                    # Código compartido
│   ├── error/               # Failures
│   ├── network/             # HTTP client
│   └── di/                  # GetIt + Injectable
│
└── features/
    └── [feature]/
        ├── data/            # Implementaciones
        ├── domain/          # Entidades, UseCases, Interfaces
        └── presentation/    # BLoCs, Pages, Widgets
```

## Testing

```bash
# Tests unitarios de contrato
flutter test sdda/02_contracts/unit/

# Tests de widget
flutter test sdda/02_contracts/widget/

# Tests E2E con Patrol
patrol test

# Cobertura
flutter test --coverage
```

## Quality Gates

- **Cobertura**: ≥80% líneas
- **Mutation Score**: ≥70%
- **Análisis estático**: 0 errores, 0 warnings

## Ejemplo de Uso

Ver `sdda/06_examples/auth/` para un ejemplo completo que incluye:
- Especificación YAML del feature
- Tests como contratos (que el código debe pasar)
- README con instrucciones

## Stack Tecnológico

| Categoría | Tecnología |
|-----------|------------|
| Framework | Flutter 3.24.x |
| State Management | flutter_bloc 8.x |
| DI | get_it + injectable |
| HTTP | dio 5.x |
| Functional | dartz (Either) |
| Testing | flutter_test, mocktail, bloc_test |
| E2E | patrol |

## Referencias

- [OpenHands](https://openhands.dev/) - Plataforma de agentes de código
- [Spec-Driven Development](https://medium.com/@dave-patten/spec-driven-development-designing-before-you-code-again-21023ac91180)
- [Test-Driven Agentic Development](https://medium.com/@JeffInUptown/test-driven-agentic-development-how-tdd-and-specification-as-code-can-enable-autonomous-coding-6b1b4b7dd816)

## Idioma

**Importante**: Toda la documentación y respuestas deben ser en español.
