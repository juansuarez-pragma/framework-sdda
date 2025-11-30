# Guía de Uso en Equipos

Cómo implementar y escalar SDDA en equipos de desarrollo.

---

## Índice

1. [Preparación del Equipo](#preparación-del-equipo)
2. [Roles y Responsabilidades](#roles-y-responsabilidades)
3. [Workflow de Equipo](#workflow-de-equipo)
4. [Estándares Compartidos](#estándares-compartidos)
5. [Onboarding](#onboarding)
6. [Métricas de Equipo](#métricas-de-equipo)

---

## Preparación del Equipo

### Evaluación Inicial

Antes de adoptar SDDA, evalúa tu equipo:

| Factor | Mínimo | Recomendado |
|--------|--------|-------------|
| Conocimiento Flutter | Básico | Intermedio+ |
| Experiencia TDD | Alguna | Práctica regular |
| Tamaño equipo | 2+ | 3-8 |
| Duración proyecto | 2+ meses | 6+ meses |

### Checklist de Preparación

- [ ] Flutter 3.24+ instalado en todas las máquinas
- [ ] Repositorio Git configurado
- [ ] CI/CD básico funcionando
- [ ] Equipo familiarizado con Clean Architecture
- [ ] Acuerdo sobre convenciones de código
- [ ] Tiempo asignado para aprendizaje (1-2 semanas)

---

## Roles y Responsabilidades

### Rol: SDDA Champion

**Responsabilidades**:
- Configurar y mantener el framework SDDA
- Capacitar al equipo
- Resolver problemas técnicos
- Optimizar prompts y contexto
- Monitorear métricas

**Perfil ideal**: Senior developer con experiencia en arquitectura.

**Dedicación**: 20-30% del tiempo inicialmente, 10% en steady state.

---

### Rol: Specification Writer

**Responsabilidades**:
- Escribir especificaciones YAML
- Traducir requisitos de negocio a specs
- Mantener specs actualizadas
- Revisar specs de otros

**Puede ser**: Cualquier developer o Product Owner técnico.

**Habilidades clave**:
- Entendimiento de dominio de negocio
- Pensamiento estructurado
- Atención al detalle

---

### Rol: Contract Writer

**Responsabilidades**:
- Escribir tests-contrato antes de generación
- Definir casos de éxito, error y edge cases
- Revisar tests de otros
- Mantener calidad de tests

**Perfil ideal**: Mid-Senior developer con experiencia en testing.

**Dedicación**: Parte del trabajo normal de desarrollo.

---

### Rol: Code Reviewer

**Responsabilidades**:
- Revisar código generado
- Verificar adherencia a patrones
- Aprobar PRs
- Identificar mejoras al contexto

**Puede ser**: Cualquier Senior developer.

**Criterios de revisión**:
- ¿El código pasa todos los tests?
- ¿Sigue los patrones del proyecto?
- ¿Es mantenible?
- ¿Hay código innecesario?

---

## Workflow de Equipo

### Proceso Estándar

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                        WORKFLOW DE EQUIPO SDDA                                │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│   ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐               │
│   │ PLANEAR │────▶│ESPECIFI-│────▶│CONTRATAR│────▶│ GENERAR │               │
│   │         │     │   CAR   │     │ (tests) │     │         │               │
│   │ Product │     │   Dev   │     │   Dev   │     │   IA    │               │
│   │ Owner + │     │         │     │         │     │         │               │
│   │   Dev   │     │         │     │         │     │         │               │
│   └─────────┘     └─────────┘     └─────────┘     └─────────┘               │
│        │               │               │               │                     │
│        │               │               │               ▼                     │
│        │               │               │         ┌─────────┐                │
│        │               │               │         │ VALIDAR │                │
│        │               │               │         │         │                │
│        │               │               │         │ Tests + │                │
│        │               │               │         │ Review  │                │
│        │               │               │         └────┬────┘                │
│        │               │               │              │                      │
│        │               │               │              ▼                      │
│        │               │               │         ┌─────────┐                │
│        │               │               └────────▶│ INTEGRAR│                │
│        │               │                         │         │                │
│        │               └────────────────────────▶│  Merge  │                │
│        │                                         │   PR    │                │
│        └────────────────────────────────────────▶└─────────┘                │
│                                                                               │
└──────────────────────────────────────────────────────────────────────────────┘
```

### Ceremonias de Equipo

#### 1. Specification Review (Diaria o según necesidad)

**Duración**: 15-30 min
**Participantes**: Spec writer + reviewer
**Objetivo**: Aprobar specs antes de escribir tests

**Agenda**:
1. Presentar spec (5 min)
2. Revisar completitud (10 min)
3. Aprobar o solicitar cambios (5 min)

---

#### 2. Contract Review (Antes de generar)

**Duración**: 15-30 min
**Participantes**: Contract writer + reviewer
**Objetivo**: Validar que tests cubren toda la spec

**Checklist**:
- [ ] ¿Tests cubren todos los UseCases?
- [ ] ¿Tests cubren casos de éxito?
- [ ] ¿Tests cubren validaciones?
- [ ] ¿Tests cubren failures?
- [ ] ¿Tests cubren edge cases?

---

#### 3. SDDA Retrospective (Quincenal o mensual)

**Duración**: 30-60 min
**Participantes**: Todo el equipo
**Objetivo**: Mejorar el proceso SDDA

**Agenda**:
1. Revisar métricas (10 min)
2. ¿Qué funcionó bien? (10 min)
3. ¿Qué podemos mejorar? (10 min)
4. Acciones concretas (10 min)

**Template de Retrospectiva**:
```markdown
# SDDA Retro - [Fecha]

## Métricas
- Features generados: ___
- First-pass success rate: ___%
- Coverage promedio: ___%

## Lo que funcionó
1. ___
2. ___

## Lo que mejorar
1. ___
2. ___

## Acciones
| Acción | Responsable | Fecha |
|--------|-------------|-------|
| ___ | ___ | ___ |
```

---

## Estándares Compartidos

### Repositorio de Contexto

Todo el equipo debe usar el mismo contexto:

```
sdda/03_context/
├── architecture/
│   ├── ARCHITECTURE.md      # Todos leen, Champion actualiza
│   └── decisions/           # ADRs del equipo
│       └── ADR-001-bloc.md
├── patterns/
│   └── examples/            # Ejemplos aprobados por el equipo
│       ├── example_usecase.dart
│       ├── example_bloc.dart
│       └── example_repository.dart
├── conventions/
│   └── CONVENTIONS.md       # Convenciones acordadas
└── glossary/
    └── TERMS.md             # Terminología del dominio
```

### Proceso de Actualización de Contexto

```
┌─────────────────────────────────────────────────────────────────┐
│              ACTUALIZACIÓN DE CONTEXTO                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   Developer propone  ──▶  PR con cambio  ──▶  Review           │
│   cambio al contexto      al contexto         por Champion      │
│                                │                    │           │
│                                │                    ▼           │
│                                │              ¿Aprobado?        │
│                                │              /        \        │
│                                │           Sí           No      │
│                                │           │            │       │
│                                ▼           ▼            ▼       │
│                           Merge PR    Comunicar   Feedback     │
│                                │       al equipo   y ajustar   │
│                                ▼                                │
│                           Actualizar                            │
│                           prompts si                            │
│                           es necesario                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Convenciones de Equipo

Documentar y acordar:

```markdown
# Convenciones del Equipo [Nombre]

## Nombrado
- Features: sustantivos en plural (products, users, orders)
- UseCases: verbos + objeto (get_products, create_order)
- BLoCs: feature + Bloc (ProductBloc, OrderBloc)

## Estructura de Spec
- Siempre incluir: feature, entities, usecases, bloc
- Failures obligatorios: NetworkFailure, ServerFailure, ValidationFailure
- Descripción en español, código en inglés

## Testing
- Mínimo 3 tests por UseCase
- Siempre test de estado inicial para BLoCs
- Prefijo 't' para test data

## Code Review
- Tiempo máximo de review: 24 horas
- Mínimo 1 aprobación para merge
- Champion debe aprobar cambios a contexto
```

---

## Onboarding

### Plan de Onboarding (1-2 semanas)

#### Día 1-2: Fundamentos

| Actividad | Duración | Recurso |
|-----------|----------|---------|
| Leer conceptos SDDA | 2 hrs | 03_CONCEPTOS.md |
| Explorar estructura | 1 hr | Codebase tour |
| Leer arquitectura | 1 hr | ARCHITECTURE.md |
| Leer convenciones | 1 hr | CONVENTIONS.md |

#### Día 3-4: Hands-on con Supervisor

| Actividad | Duración | Recurso |
|-----------|----------|---------|
| Pair: Escribir spec | 2 hrs | Con champion |
| Pair: Escribir tests | 2 hrs | Con senior |
| Observar generación | 1 hr | Demo en vivo |
| Pair: Validar código | 1 hr | Con senior |

#### Día 5-7: Primera Feature Independiente

| Actividad | Duración | Soporte |
|-----------|----------|---------|
| Escribir spec (simple) | 2 hrs | Review disponible |
| Escribir tests | 3 hrs | Review disponible |
| Generar código | 1 hr | Async support |
| Validar e integrar | 2 hrs | Code review |

#### Día 8-10: Feature Real

| Actividad | Duración | Nivel de autonomía |
|-----------|----------|--------------------|
| Feature completo | 3-4 días | Con code review |
| Retrospectiva personal | 30 min | Con champion |

### Checklist de Onboarding

```markdown
# Onboarding SDDA - [Nombre]

## Semana 1
- [ ] Acceso a repositorio
- [ ] CLI instalado y funcionando
- [ ] Leído: CONCEPTOS.md
- [ ] Leído: ARCHITECTURE.md
- [ ] Leído: CONVENTIONS.md
- [ ] Tour del codebase con buddy
- [ ] Pair programming: spec
- [ ] Pair programming: tests

## Semana 2
- [ ] Feature simple completado
- [ ] Code review aprobado
- [ ] Feature real asignado
- [ ] Feature real completado
- [ ] Retrospectiva con champion

## Validación
- [ ] Puede escribir spec sin ayuda
- [ ] Puede escribir tests sin ayuda
- [ ] Entiende el flujo completo
- [ ] Conoce los comandos del CLI

Fecha de completado: ________
Firmado por Champion: ________
```

---

## Métricas de Equipo

### Dashboard de Equipo

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         DASHBOARD SDDA - EQUIPO                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   PRODUCTIVIDAD                        CALIDAD                               │
│   ─────────────                        ───────                               │
│   Features/Sprint: 4.2                 Coverage: 87%                        │
│   First-Pass Rate: 78%                 Mutation Score: 72%                  │
│   Tiempo/Feature: 2.3 días             Bugs Escaped: 1                      │
│                                                                              │
│   POR DESARROLLADOR                    PROCESO                              │
│   ─────────────────                    ───────                              │
│   ┌──────────────────────────┐         Specs/Semana: 6                      │
│   │ Dev A: ████████ 3.2 feat │         Tests/Feature: 12 avg                │
│   │ Dev B: ██████ 2.5 feat   │         Review Time: 4 hrs avg               │
│   │ Dev C: ███████ 2.8 feat  │         Rework Rate: 8%                      │
│   └──────────────────────────┘                                               │
│                                                                              │
│   TENDENCIA (últimos 4 sprints)                                             │
│   ─────────────────────────────                                             │
│        S1    S2    S3    S4                                                 │
│   FP%  65    72    75    78  ↑                                              │
│   Cov  82    84    85    87  ↑                                              │
│   T/F  3.5   3.0   2.8   2.3 ↓ (mejor)                                     │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### KPIs de Equipo

| KPI | Cálculo | Target | Frecuencia |
|-----|---------|--------|------------|
| Features/Sprint | Total features completados | ≥4 | Sprint |
| First-Pass Success | Features OK en 1er intento / Total | ≥75% | Sprint |
| Tiempo por Feature | Hrs totales / Features | ≤24 hrs | Sprint |
| Coverage Promedio | Suma coverages / Features | ≥80% | Sprint |
| Rework Rate | Features con rework / Total | ≤15% | Sprint |
| Review Time | Hrs desde PR hasta merge | ≤8 hrs | Sprint |

### Reporte Semanal de Equipo

```markdown
# Reporte SDDA - Semana [X]

## Resumen
- Features completados: 3
- PRs mergeados: 5
- Coverage promedio: 86%

## Por Developer
| Developer | Features | First-Pass | Coverage |
|-----------|----------|------------|----------|
| Alice | 1.5 | 100% | 88% |
| Bob | 1 | 50% | 84% |
| Carol | 0.5 | 100% | 86% |

## Highlights
- ✅ Feature X completado ahead of schedule
- ⚠️ Feature Y requirió 2 iteraciones

## Blockers
- Ninguno

## Próxima Semana
- Feature Z (Alice)
- Feature W (Bob)
- Mejora de contexto (Carol)
```

---

## Escalamiento

### De 3 a 8 Developers

| Aspecto | 3 devs | 8 devs |
|---------|--------|--------|
| Champions | 1 | 1-2 |
| Spec reviewers | 1 | 2-3 |
| Contexto | Unificado | Unificado con governance |
| Comunicación | Informal | Ceremonias formales |
| Onboarding | Ad-hoc | Estructurado |

### De 8 a 20+ Developers

| Aspecto | Cambio necesario |
|---------|------------------|
| Estructura | Dividir en squads con su contexto |
| Champions | 1 por squad + 1 global |
| Contexto | Core compartido + extensiones por squad |
| Governance | Comité de arquitectura |
| Métricas | Dashboards por squad y global |

### Multi-equipo

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          SDDA MULTI-EQUIPO                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌─────────────────────────────────────────────────────────────┐           │
│   │                    CONTEXTO GLOBAL                           │           │
│   │  - ARCHITECTURE.md (core)                                    │           │
│   │  - CONVENTIONS.md (core)                                     │           │
│   │  - Patrones base                                             │           │
│   └─────────────────────────────────────────────────────────────┘           │
│                              │                                               │
│          ┌───────────────────┼───────────────────┐                          │
│          ▼                   ▼                   ▼                          │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐                  │
│   │   SQUAD A   │     │   SQUAD B   │     │   SQUAD C   │                  │
│   │ ─────────── │     │ ─────────── │     │ ─────────── │                  │
│   │ Champion: X │     │ Champion: Y │     │ Champion: Z │                  │
│   │ Contexto:   │     │ Contexto:   │     │ Contexto:   │                  │
│   │ + específico│     │ + específico│     │ + específico│                  │
│   │ Features:   │     │ Features:   │     │ Features:   │                  │
│   │ auth, users │     │ products,   │     │ orders,     │                  │
│   │             │     │ inventory   │     │ payments    │                  │
│   └─────────────┘     └─────────────┘     └─────────────┘                  │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Siguiente Paso

Ver el [Troubleshooting](./TROUBLESHOOTING.md) para resolver problemas comunes.
