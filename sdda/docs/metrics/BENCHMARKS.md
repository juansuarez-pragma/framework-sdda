# Benchmarks y Estándares

Valores de referencia y comparación con la industria.

---

## Benchmarks de SDDA

### Métricas Target por Fase de Madurez

#### Nivel 1-2 (Inicial)

| Métrica | Mínimo | Target | Óptimo |
|---------|--------|--------|--------|
| Coverage | 60% | 70% | 80% |
| Test Pass Rate | 95% | 100% | 100% |
| First-Pass Success | 40% | 50% | 60% |
| Hallucination Rate | 30% | 20% | 15% |
| Feature Time (medio) | 7 días | 5 días | 4 días |

#### Nivel 3-4 (Definido/Gestionado)

| Métrica | Mínimo | Target | Óptimo |
|---------|--------|--------|--------|
| Coverage | 75% | 85% | 90% |
| Test Pass Rate | 100% | 100% | 100% |
| Mutation Score | 60% | 70% | 75% |
| First-Pass Success | 60% | 75% | 85% |
| Hallucination Rate | 15% | 8% | 5% |
| Feature Time (medio) | 5 días | 3 días | 2 días |

#### Nivel 5 (Optimizado)

| Métrica | Mínimo | Target | Óptimo |
|---------|--------|--------|--------|
| Coverage | 85% | 92% | 95% |
| Mutation Score | 75% | 82% | 90% |
| First-Pass Success | 85% | 92% | 98% |
| Hallucination Rate | 5% | 2% | <1% |
| Feature Time (medio) | 2 días | 1 día | 0.5 días |
| Code Gen Ratio | 80% | 88% | 95% |

---

## Comparación con Desarrollo Tradicional

### Tiempo de Desarrollo

| Complejidad | Tradicional | SDDA | Reducción |
|-------------|-------------|------|-----------|
| Feature Simple | 3-5 días | 1-2 días | 50-60% |
| Feature Medio | 1-2 semanas | 3-5 días | 50-65% |
| Feature Complejo | 3-4 semanas | 1-2 semanas | 50% |

### Calidad de Código

| Métrica | Tradicional* | SDDA Target |
|---------|--------------|-------------|
| Coverage promedio | 40-60% | 80-90% |
| Bugs post-release | 15-25/kloc | 5-10/kloc |
| Deuda técnica | Alta | Baja |
| Consistencia código | Variable | Alta |

*Promedios de la industria según estudios de Capers Jones y otros.

### Distribución de Tiempo

```
DESARROLLO TRADICIONAL:
┌─────────────────────────────────────────────────────────────────┐
│ Diseño  │    Coding     │ Testing │ Debug │ Rework  │ Review  │
│  10%    │      40%      │   20%   │  15%  │   10%   │   5%    │
└─────────────────────────────────────────────────────────────────┘

DESARROLLO SDDA:
┌─────────────────────────────────────────────────────────────────┐
│ Specify │ Contract │ Generate│Validate │ Integrate │  Review  │
│   20%   │   30%    │   15%   │   20%   │    10%    │    5%    │
└─────────────────────────────────────────────────────────────────┘
```

---

## Benchmarks de Industria Flutter

### Coverage por Tipo de App

| Tipo | Promedio Industria | SDDA Target |
|------|-------------------|-------------|
| MVP/Startup | 20-40% | 70% |
| B2B App | 50-70% | 85% |
| B2C App | 40-60% | 80% |
| Fintech | 70-85% | 90% |
| Healthcare | 75-90% | 95% |

### Test Distribution (Empresas Top)

| Empresa/Estándar | Unit | Widget | Integration | E2E |
|------------------|------|--------|-------------|-----|
| Google (Flutter team) | 60% | 25% | 10% | 5% |
| Muy Good Ventures | 55% | 25% | 15% | 5% |
| **SDDA Target** | **55%** | **25%** | **15%** | **5%** |

### Tiempo de CI/CD

| Pipeline | Industria | SDDA Target |
|----------|-----------|-------------|
| Build | 3-10 min | <5 min |
| Unit Tests | 2-5 min | <2 min |
| Widget Tests | 3-8 min | <3 min |
| Integration | 5-15 min | <10 min |
| **Total** | **15-40 min** | **<20 min** |

---

## Benchmarks de IA Code Generation

### Comparación de Enfoques

| Enfoque | Success Rate | Hallucinations | Rework |
|---------|--------------|----------------|--------|
| Prompt simple | 30-50% | 30-50% | Alto |
| Prompt + Context | 50-70% | 15-25% | Medio |
| **SDDA (Spec+Contract+Context)** | **75-90%** | **5-10%** | **Bajo** |
| Human coding | 85-95% | 0% | Bajo |

### Iteraciones Necesarias

| Enfoque | Iteraciones promedio |
|---------|---------------------|
| Prompt simple | 5-8 |
| Prompt + Context | 3-5 |
| **SDDA** | **1-3** |

---

## KPIs Recomendados por Rol

### Para Tech Lead

| KPI | Frecuencia | Target |
|-----|------------|--------|
| Feature Delivery Time | Semanal | -30% vs baseline |
| First-Pass Success Rate | Semanal | ≥75% |
| Technical Debt | Mensual | Decreciente |
| Team Velocity | Sprint | +20% vs sin SDDA |

### Para QA Lead

| KPI | Frecuencia | Target |
|-----|------------|--------|
| Coverage | Por feature | ≥80% |
| Mutation Score | Mensual | ≥70% |
| Bugs Escaped | Sprint | <2 |
| Test Flakiness | Semanal | <1% |

### Para Engineering Manager

| KPI | Frecuencia | Target |
|-----|------------|--------|
| Time to Market | Mensual | -40% |
| Cost per Feature | Trimestral | -30% |
| Developer Satisfaction | Trimestral | ≥4/5 |
| Process Maturity | Trimestral | Nivel +1 |

---

## Calculadora de Ahorro

### Fórmula de ROI

```
Ahorro por Feature = (Tiempo_Tradicional - Tiempo_SDDA) × Costo_Hora

Ejemplo:
- Feature tradicional: 40 horas
- Feature SDDA: 20 horas
- Costo/hora: $50

Ahorro = (40 - 20) × $50 = $1,000 por feature
```

### Tabla de Ahorro Proyectado

| Features/Mes | Ahorro Mensual | Ahorro Anual |
|--------------|----------------|--------------|
| 2 | $2,000 | $24,000 |
| 4 | $4,000 | $48,000 |
| 8 | $8,000 | $96,000 |
| 12 | $12,000 | $144,000 |

### Costos de Implementación

| Ítem | Costo Único | Costo Mensual |
|------|-------------|---------------|
| Setup inicial | 40 hrs | - |
| Capacitación | 16 hrs/dev | - |
| Mantenimiento | - | 4 hrs |
| Herramientas IA | - | $20-100 |

### Break-Even

```
Break-Even = Costo_Implementación / Ahorro_por_Feature

Ejemplo:
- Implementación: 56 horas × $50 = $2,800
- Ahorro/feature: $1,000

Break-Even = $2,800 / $1,000 = 2.8 features

→ ROI positivo después de 3 features
```

---

## Metas por Trimestre

### Q1: Establecer Baseline

| Meta | Criterio de Éxito |
|------|-------------------|
| Instalar SDDA | CLI funcionando |
| Documentar contexto | ARCHITECTURE.md, CONVENTIONS.md |
| Generar 3 features | Coverage ≥70% cada uno |
| Medir métricas base | Dashboard inicial |

### Q2: Optimizar

| Meta | Criterio de Éxito |
|------|-------------------|
| First-pass success ≥60% | Reducir iteraciones |
| Coverage promedio ≥80% | Tests más completos |
| Tiempo -30% | vs Q1 baseline |
| Nivel madurez 3 | Checklist completo |

### Q3: Escalar

| Meta | Criterio de Éxito |
|------|-------------------|
| Todo el equipo usa SDDA | 100% features via SDDA |
| CI/CD integrado | Validación automática |
| Mutation testing | Score ≥70% |
| Nivel madurez 4 | Métricas automatizadas |

### Q4: Optimizar

| Meta | Criterio de Éxito |
|------|-------------------|
| First-pass success ≥85% | Prompts optimizados |
| Tiempo -50% | vs inicio de año |
| ROI documentado | $X ahorrados |
| Nivel madurez 5 | Proceso maduro |

---

## Siguiente Paso

Ver la [Guía de CI/CD](../guides/CI_CD.md) para automatizar la validación.
