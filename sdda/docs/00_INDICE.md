# SDDA - Documentación Completa

## Specification-Driven Development for AI Agents

Framework para generación de código Flutter 100% automatizada con IA.

---

## Índice de Documentación

### Inicio Rápido
- [01_QUICK_START.md](./guides/01_QUICK_START.md) - Comenzar en 5 minutos

### Guías de Usuario
- [02_INSTALACION.md](./guides/02_INSTALACION.md) - Instalación y configuración
- [03_CONCEPTOS.md](./guides/03_CONCEPTOS.md) - Conceptos fundamentales
- [04_TUTORIAL_FEATURE.md](./guides/04_TUTORIAL_FEATURE.md) - Tutorial paso a paso
- [05_FLUJO_TRABAJO.md](./guides/05_FLUJO_TRABAJO.md) - Flujo de trabajo completo

### Referencia de API
- [CLI_REFERENCE.md](./api/CLI_REFERENCE.md) - Referencia completa del CLI
- [PROMPTS_REFERENCE.md](./api/PROMPTS_REFERENCE.md) - Sistema de prompts
- [VALIDATORS_REFERENCE.md](./api/VALIDATORS_REFERENCE.md) - Validadores

### Métricas y Evaluación
- [METRICAS.md](./metrics/METRICAS.md) - Métricas del framework
- [EVALUACION.md](./metrics/EVALUACION.md) - Cómo evaluar resultados
- [BENCHMARKS.md](./metrics/BENCHMARKS.md) - Benchmarks esperados

### Integración
- [CI_CD.md](./guides/CI_CD.md) - Integración con CI/CD
- [EQUIPOS.md](./guides/EQUIPOS.md) - Uso en equipos

### Solución de Problemas
- [TROUBLESHOOTING.md](./guides/TROUBLESHOOTING.md) - Problemas comunes
- [FAQ.md](./guides/FAQ.md) - Preguntas frecuentes

---

## Principio Fundamental

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   "La IA NO imagina código, la IA IMPLEMENTA especificaciones" │
│                                                                 │
│   Entrada: Especificación + Tests + Contexto                    │
│   Salida:  Código Validado que pasa los tests                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Flujo SDDA

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ SPECIFY  │───▶│ CONTRACT │───▶│ GENERATE │───▶│ VALIDATE │
│          │    │          │    │          │    │          │
│ Escribir │    │ Escribir │    │ IA genera│    │ Tests    │
│ specs    │    │ tests    │    │ código   │    │ pasan    │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
```

## Versión

- **SDDA Framework**: 1.0.0
- **Flutter**: 3.24.x
- **Dart**: 3.5.x
