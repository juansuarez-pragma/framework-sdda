# CLAUDE.md

Este archivo proporciona orientación a Claude Code (claude.ai/code) cuando trabaja con código en este repositorio.

## Descripción del Proyecto

Este proyecto implementa **SDDA (Specification-Driven Development for AI Agents)**, un framework completo que permite la generación de código 100% automatizada con IA para aplicaciones Flutter, eliminando alucinaciones mediante especificaciones estructuradas y tests como contratos.

### Principio Fundamental

```
"La IA NO imagina código, la IA IMPLEMENTA especificaciones"

Entrada: Especificación + Tests + Contexto → Salida: Código 100% Validado
```

### Filosofía de Cobertura

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│   SDDA REQUIERE 100% DE COBERTURA EN CÓDIGO TESTEABLE                      │
│                                                                             │
│   "Si el código tiene lógica, DEBE tener test"                             │
│   "Si no tiene test, NO se genera"                                          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Estructura del Proyecto

```
QEaC/
├── README.md                       # Documentación principal del framework
├── LICENSE                         # MIT License
├── CLAUDE.md                       # Este archivo (contexto para Claude)
│
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
│   ├── 01_specs/                   # Especificaciones YAML
│   │   ├── templates/              # Plantillas de especificación
│   │   └── features/               # Specs por feature
│   │
│   ├── 02_contracts/               # Tests-Contrato (TDD)
│   │   ├── unit/                   # Tests unitarios
│   │   ├── widget/                 # Tests de widget
│   │   ├── integration/            # Tests de integración
│   │   └── e2e/                    # Tests end-to-end
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
│   ├── 06_examples/                # Ejemplos completos
│   │   └── auth/
│   │       ├── specs/auth_feature_spec.yaml
│   │       ├── contracts/          # Tests como contratos
│   │       └── README.md
│   │
│   └── docs/                       # Documentación del framework
│       ├── 00_INDICE.md            # Índice de documentación
│       ├── guides/                 # Guías de usuario
│       │   ├── 01_QUICK_START.md
│       │   ├── 02_INSTALACION.md
│       │   ├── 03_CONCEPTOS.md
│       │   ├── 04_TUTORIAL_FEATURE.md
│       │   ├── 05_FLUJO_TRABAJO.md
│       │   ├── CI_CD.md
│       │   ├── EQUIPOS.md
│       │   ├── TROUBLESHOOTING.md
│       │   └── FAQ.md
│       ├── metrics/                # Métricas y evaluación
│       │   ├── METRICAS.md
│       │   ├── EVALUACION.md
│       │   └── BENCHMARKS.md
│       └── api/                    # Referencia de API
│           ├── CLI_REFERENCE.md
│           ├── PROMPTS_REFERENCE.md
│           └── VALIDATORS_REFERENCE.md
│
└── QEaC_Flutter_Investigacion.md   # Documento de investigación base
```

## Flujo de Trabajo SDDA

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                           CICLO SDDA                                          │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐              │
│   │ SPECIFY  │───▶│ CONTRACT │───▶│ GENERATE │───▶│ VALIDATE │              │
│   │          │    │          │    │          │    │          │              │
│   │ Escribir │    │ Escribir │    │ IA genera│    │ 100%     │              │
│   │ spec.yaml│    │ tests    │    │ código   │    │ coverage │              │
│   └──────────┘    └──────────┘    └──────────┘    └──────────┘              │
│        │                                               │                     │
│        │              Si falla, iterar                 │                     │
│        └───────────────────────────────────────────────┘                     │
│                                                                               │
└──────────────────────────────────────────────────────────────────────────────┘
```

### Metodologías Integradas

- **ATDD**: Define QUÉ debe hacer el sistema (Gherkin)
- **DDD**: Define CÓMO se modela el dominio
- **TDD**: Define el COMPORTAMIENTO exacto (tests primero)
- **E2E**: Verifica FLUJOS completos

## Estándares de Calidad (NO NEGOCIABLES)

| Métrica | Estándar | Negociable |
|---------|----------|------------|
| Coverage (código testeable) | **100%** | ❌ No |
| Test Pass Rate | **100%** | ❌ No |
| Contract Coverage | **100%** | ❌ No |
| Architecture Violations | **0** | ❌ No |
| Mutation Score | **≥95%** | ⚠️ Mínimo 90% |
| First-Pass Success | **≥95%** | ⚠️ Mínimo 85% |
| Hallucination Rate | **<1%** | ⚠️ Máximo 5% |

### Excepciones de Coverage (Únicas Permitidas)

**✅ Código que SÍ puede excluirse del 100%:**

| Tipo | Patrón | Razón |
|------|--------|-------|
| Auto-generado JSON | `*.g.dart` | json_serializable |
| Auto-generado Freezed | `*.freezed.dart` | freezed |
| Assets generados | `*.gen.dart` | flutter_gen |
| Localizaciones | `l10n/*.dart` | intl |
| Entry point | `main.dart` | Bootstrap sin lógica |
| DI Setup | `injection.dart` | Configuración declarativa |
| Firebase config | `firebase_options.dart` | Auto-generado |

**❌ Código que NUNCA puede excluirse:**

| Tipo | Razón |
|------|-------|
| UseCases | Lógica de negocio |
| BLoCs/Cubits | Gestión de estado |
| Repository Implementations | Coordinación de datos |
| Validators | Reglas críticas |
| Mappers/Converters | Transformaciones |
| Error Handlers | Flujo de errores |

### Configuración de Exclusiones en lcov

```bash
lcov --remove coverage/lcov.info \
  '**/*.g.dart' \
  '**/*.freezed.dart' \
  '**/*.gen.dart' \
  '**/l10n/*' \
  '**/main.dart' \
  '**/injection.dart' \
  '**/firebase_options.dart' \
  -o coverage/lcov_filtered.info
```

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

# Validar código (debe ser 100% coverage)
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
5. **100% COVERAGE**: Todo código con lógica DEBE tener test
6. **MÍNIMO NECESARIO**: Solo implementar lo especificado
7. **USAR Either<Failure, T>**: No lanzar excepciones

### Antes de Generar Cualquier Código

```
CHECKLIST:
[ ] Leí ARCHITECTURE.md
[ ] Leí CONVENTIONS.md
[ ] Revisé el patrón de ejemplo correspondiente
[ ] Tengo la especificación completa
[ ] Conozco los tests que debe pasar
[ ] El código tendrá 100% de cobertura
```

### Estructura de Prompts

```
1. System Context (rol y reglas base)
2. Project Context (arquitectura, patrones, convenciones)
3. Contracts (tests que debe pasar el código)
4. Task Specification (qué implementar exactamente)
5. Output Format (código completo + tests completos)
```

### Archivos de Referencia Clave

| Componente | Patrón de Referencia |
|------------|---------------------|
| UseCase | `sdda/03_context/patterns/examples/example_usecase.dart` |
| BLoC | `sdda/03_context/patterns/examples/example_bloc.dart` |
| Repository | `sdda/03_context/patterns/examples/example_repository.dart` |
| Prompts | `sdda/04_prompts/generation/` |
| Métricas | `sdda/docs/metrics/METRICAS.md` |
| Benchmarks | `sdda/docs/metrics/BENCHMARKS.md` |

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
        │   ├── models/      # DTOs (*.g.dart excluido de coverage)
        │   ├── repositories/# Impl (100% coverage)
        │   └── datasources/ # Remote/Local (100% coverage)
        ├── domain/          # Entidades, UseCases, Interfaces
        │   ├── entities/    # Puras (100% coverage)
        │   ├── repositories/# Interfaces (N/A)
        │   └── usecases/    # Lógica (100% coverage)
        └── presentation/    # BLoCs, Pages, Widgets
            ├── bloc/        # State mgmt (100% coverage)
            └── pages/       # UI (100% coverage en lógica)
```

## Testing

```bash
# Tests unitarios de contrato
flutter test sdda/02_contracts/unit/

# Tests de widget
flutter test sdda/02_contracts/widget/

# Tests E2E con Patrol
patrol test

# Cobertura (debe ser 100%)
flutter test --coverage
lcov --summary coverage/lcov.info

# Filtrar código auto-generado
lcov --remove coverage/lcov.info '**/*.g.dart' '**/*.freezed.dart' \
  -o coverage/lcov_filtered.info
lcov --summary coverage/lcov_filtered.info
```

## Quality Gates (CI/CD)

| Métrica | Target | Bloquea Deploy |
|---------|--------|----------------|
| Coverage (testeable) | 100% | ✅ Sí |
| Test Pass Rate | 100% | ✅ Sí |
| Mutation Score | ≥95% | ✅ Sí |
| Análisis estático | 0 errores | ✅ Sí |
| Architecture Violations | 0 | ✅ Sí |

## Documentación Completa

| Documento | Ubicación | Descripción |
|-----------|-----------|-------------|
| Quick Start | `sdda/docs/guides/01_QUICK_START.md` | Inicio en 5 minutos |
| Instalación | `sdda/docs/guides/02_INSTALACION.md` | Configuración completa |
| Conceptos | `sdda/docs/guides/03_CONCEPTOS.md` | Filosofía SDDA |
| Tutorial | `sdda/docs/guides/04_TUTORIAL_FEATURE.md` | Paso a paso |
| Flujo | `sdda/docs/guides/05_FLUJO_TRABAJO.md` | Ciclo completo |
| **Métricas** | `sdda/docs/metrics/METRICAS.md` | KPIs y 100% coverage |
| **Benchmarks** | `sdda/docs/metrics/BENCHMARKS.md` | Comparativas |
| Evaluación | `sdda/docs/metrics/EVALUACION.md` | Cómo evaluar |
| CI/CD | `sdda/docs/guides/CI_CD.md` | Integración continua |
| Equipos | `sdda/docs/guides/EQUIPOS.md` | Adopción en equipos |
| CLI | `sdda/docs/api/CLI_REFERENCE.md` | Comandos |
| Prompts | `sdda/docs/api/PROMPTS_REFERENCE.md` | Sistema de prompts |
| Validadores | `sdda/docs/api/VALIDATORS_REFERENCE.md` | Reglas |
| Troubleshooting | `sdda/docs/guides/TROUBLESHOOTING.md` | Problemas comunes |
| FAQ | `sdda/docs/guides/FAQ.md` | Preguntas frecuentes |

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
| Coverage | lcov |
| Mutation | stryker-mutator |

## Comparación: Sin SDDA vs Con SDDA

| Métrica | Sin SDDA | Con SDDA |
|---------|----------|----------|
| Alucinaciones | 30-50% | **<1%** |
| First-Pass Success | 40-50% | **95-99%** |
| Rework necesario | 40-60% | **<5%** |
| Coverage | 40-60% | **100%** |
| Bugs en producción | 15-25/kloc | **0-2/kloc** |

## Referencias

- [Very Good Ventures - 100% Coverage](https://www.verygood.ventures/blog/road-to-100-test-coverage)
- [OpenHands](https://openhands.dev/) - Plataforma de agentes de código
- [Spec-Driven Development](https://medium.com/@dave-patten/spec-driven-development-designing-before-you-code-again-21023ac91180)
- [Test-Driven Agentic Development](https://medium.com/@JeffInUptown/test-driven-agentic-development-how-tdd-and-specification-as-code-can-enable-autonomous-coding-6b1b4b7dd816)

## Idioma

**Importante**: Toda la documentación y respuestas deben ser en español.
