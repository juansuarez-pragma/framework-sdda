# Métricas del Framework SDDA

Indicadores clave para medir la efectividad del desarrollo con SDDA.

---

## Categorías de Métricas

1. [Métricas de Calidad de Código](#métricas-de-calidad-de-código)
2. [Métricas de Testing](#métricas-de-testing)
3. [Métricas de Productividad](#métricas-de-productividad)
4. [Métricas de Proceso](#métricas-de-proceso)
5. [Métricas de IA](#métricas-de-ia)

---

## Métricas de Calidad de Código

### 1. Code Coverage (Cobertura de Código)

**Definición**: Porcentaje de líneas de código ejecutadas por tests.

| Nivel | Cobertura | Estado |
|-------|-----------|--------|
| Crítico | < 60% | 🔴 Inaceptable |
| Bajo | 60-79% | 🟡 Mejorar |
| **Target** | **≥ 80%** | 🟢 **Aceptable** |
| Excelente | ≥ 90% | 🟢 Óptimo |

**Cómo medir**:
```bash
flutter test --coverage
lcov --summary coverage/lcov.info

# Output esperado:
# lines......: 85.3% (1234 of 1447 lines)
```

**Por capa**:
| Capa | Target Mínimo |
|------|---------------|
| Domain (UseCases) | 95% |
| Data (Repositories) | 85% |
| Presentation (BLoC) | 90% |
| Presentation (Widgets) | 70% |

### 2. Mutation Score (Puntuación de Mutación)

**Definición**: Porcentaje de mutantes (código modificado) detectados por tests.

| Nivel | Score | Interpretación |
|-------|-------|----------------|
| Bajo | < 50% | Tests débiles |
| Medio | 50-69% | Tests moderados |
| **Target** | **≥ 70%** | **Tests robustos** |
| Alto | ≥ 85% | Tests muy robustos |

**Cómo medir**:
```bash
# Usando mutation testing (ejemplo con stryker)
dart run stryker:stryker

# Output:
# Mutation Score: 75.2%
# Killed: 188, Survived: 62, Timeout: 5
```

### 3. Complejidad Ciclomática

**Definición**: Número de caminos linealmente independientes en el código.

| Complejidad | Riesgo | Acción |
|-------------|--------|--------|
| 1-10 | Bajo | ✅ Aceptable |
| 11-20 | Medio | ⚠️ Revisar |
| 21-50 | Alto | 🔴 Refactorizar |
| > 50 | Muy Alto | 🔴 Dividir |

**Target SDDA**: Máximo 10 por método.

**Cómo medir**:
```bash
dart run dart_code_metrics:metrics analyze lib/

# O con flutter analyze
flutter analyze --no-fatal-infos
```

### 4. Violaciones de Arquitectura

**Definición**: Imports que violan las reglas de dependencia de Clean Architecture.

| Violación | Severidad |
|-----------|-----------|
| Domain importa Data | 🔴 Crítica |
| Domain importa Presentation | 🔴 Crítica |
| Presentation importa Data | 🟡 Alta |
| Data importa Presentation | 🔴 Crítica |

**Target**: 0 violaciones.

**Cómo medir**:
```bash
sdda validate --all --architecture

# Output:
# Architecture violations: 0
```

---

## Métricas de Testing

### 5. Test Pass Rate

**Definición**: Porcentaje de tests que pasan.

| Rate | Estado |
|------|--------|
| < 100% | 🔴 No desplegar |
| **100%** | 🟢 **Requerido** |

**Cómo medir**:
```bash
flutter test

# Output:
# 00:05 +45: All tests passed!
```

### 6. Test Execution Time

**Definición**: Tiempo total para ejecutar todos los tests.

| Tipo | Target |
|------|--------|
| Unit Tests (1000) | < 30 segundos |
| Widget Tests (100) | < 60 segundos |
| Integration Tests (20) | < 5 minutos |
| E2E Tests (10) | < 10 minutos |

**Cómo medir**:
```bash
time flutter test

# Output:
# real    0m28.456s
```

### 7. Test Distribution

**Definición**: Proporción de tests por tipo (Pirámide de Testing).

```
                    ┌───────────┐
                    │   E2E     │  5-10%
                    │   Tests   │
                   ─┴───────────┴─
                  ┌───────────────┐
                  │ Integration   │  15-20%
                  │    Tests      │
                 ─┴───────────────┴─
                ┌───────────────────┐
                │   Widget Tests    │  20-25%
               ─┴───────────────────┴─
              ┌───────────────────────┐
              │     Unit Tests        │  50-60%
              └───────────────────────┘
```

**Target Distribution**:
| Tipo | Porcentaje |
|------|------------|
| Unit | 50-60% |
| Widget | 20-25% |
| Integration | 15-20% |
| E2E | 5-10% |

### 8. Flaky Test Rate

**Definición**: Porcentaje de tests que fallan intermitentemente.

| Rate | Estado |
|------|--------|
| > 5% | 🔴 Crítico |
| 1-5% | 🟡 Atención |
| **< 1%** | 🟢 **Target** |
| 0% | 🟢 Óptimo |

---

## Métricas de Productividad

### 9. Feature Delivery Time

**Definición**: Tiempo desde especificación hasta código validado.

| Complejidad | Target |
|-------------|--------|
| Simple (1-2 UseCases) | 1-2 días |
| Media (3-5 UseCases) | 3-5 días |
| Compleja (6+ UseCases) | 1-2 semanas |

**Desglose típico**:
```
┌────────────────────────────────────────────────────┐
│              Feature Delivery Time                  │
├────────────────────────────────────────────────────┤
│                                                     │
│   SPECIFY    ████████░░░░░░░░░░░░░░  20%           │
│   CONTRACT   ████████████░░░░░░░░░░  30%           │
│   GENERATE   ████████░░░░░░░░░░░░░░  20%           │
│   VALIDATE   ██████████████░░░░░░░░  30%           │
│                                                     │
└────────────────────────────────────────────────────┘
```

### 10. Code Generation Ratio

**Definición**: Porcentaje de código generado automáticamente vs manual.

| Ratio | Nivel de Automatización |
|-------|------------------------|
| < 50% | Bajo |
| 50-70% | Medio |
| **70-85%** | **Target SDDA** |
| > 85% | Alto |

**Por componente**:
| Componente | % Generado Esperado |
|------------|---------------------|
| Entities | 90% |
| Models | 95% |
| Repository Interface | 95% |
| Repository Impl | 80% |
| UseCases | 85% |
| BLoC | 80% |
| Widgets | 50% |

### 11. Rework Rate

**Definición**: Porcentaje de código que necesita ser reescrito después de generación.

| Rate | Estado |
|------|--------|
| > 30% | 🔴 Especificación pobre |
| 15-30% | 🟡 Mejorar contexto |
| **5-15%** | 🟢 **Normal** |
| < 5% | 🟢 Excelente |

---

## Métricas de Proceso

### 12. Specification Completeness

**Definición**: Qué tan completas están las especificaciones antes de generar.

**Checklist** (cada ítem vale 10%):
- [ ] Entidades definidas con todos los campos
- [ ] UseCases con params y return types
- [ ] Validaciones especificadas
- [ ] Failures documentados
- [ ] API endpoints definidos
- [ ] Eventos del BLoC listados
- [ ] Estados del BLoC listados
- [ ] Requisitos de negocio claros
- [ ] Criterios de aceptación
- [ ] Dependencias identificadas

**Target**: ≥ 80% antes de GENERATE.

### 13. Contract Coverage

**Definición**: Porcentaje de especificación cubierta por tests-contrato.

| Coverage | Estado |
|----------|--------|
| < 70% | 🔴 Insuficiente |
| 70-89% | 🟡 Aceptable |
| **≥ 90%** | 🟢 **Target** |

**Fórmula**:
```
Contract Coverage = (Tests escritos / Comportamientos especificados) × 100
```

### 14. First-Pass Success Rate

**Definición**: Porcentaje de generaciones que pasan validación en el primer intento.

| Rate | Estado |
|------|--------|
| < 50% | 🔴 Contexto insuficiente |
| 50-70% | 🟡 Mejorar patrones |
| **70-85%** | 🟢 **Normal** |
| > 85% | 🟢 Excelente |

---

## Métricas de IA

### 15. Hallucination Rate

**Definición**: Frecuencia con que la IA genera código que referencia APIs/métodos inexistentes.

| Rate | Estado |
|------|--------|
| > 20% | 🔴 Contexto muy pobre |
| 10-20% | 🟡 Mejorar documentación |
| **< 10%** | 🟢 **Target** |
| < 5% | 🟢 Excelente |

**Cómo detectar**:
```bash
# Compilar código generado
flutter analyze lib/features/[nuevo]/

# Errores de "undefined" indican alucinaciones
# Analyzing...
# error: Undefined name 'NonExistentClass'
```

### 16. Pattern Adherence

**Definición**: Qué tan bien el código generado sigue los patrones de ejemplo.

**Criterios** (escala 1-5):
| Criterio | 1 | 5 |
|----------|---|---|
| Estructura de archivos | Diferente | Idéntica |
| Nombrado de clases | Inconsistente | Consistente |
| Manejo de errores | Diferente | Igual al patrón |
| Documentación | Ausente | Completa |
| Imports | Desordenados | Según convención |

**Target**: Promedio ≥ 4.0

### 17. Prompt Efficiency

**Definición**: Número de iteraciones de prompt necesarias para obtener código correcto.

| Iteraciones | Eficiencia |
|-------------|------------|
| 1 | 🟢 Excelente |
| **2-3** | 🟢 **Normal** |
| 4-5 | 🟡 Revisar prompt |
| > 5 | 🔴 Rediseñar prompt |

---

## Dashboard de Métricas

### Template de Reporte Semanal

```markdown
# Reporte SDDA - Semana [X]

## Resumen Ejecutivo
| Métrica | Target | Actual | Estado |
|---------|--------|--------|--------|
| Coverage | ≥80% | 85% | 🟢 |
| Test Pass | 100% | 100% | 🟢 |
| Mutation Score | ≥70% | 72% | 🟢 |
| First-Pass Success | ≥70% | 75% | 🟢 |
| Hallucination Rate | <10% | 8% | 🟢 |

## Features Completados
| Feature | Tiempo | Coverage | Tests |
|---------|--------|----------|-------|
| auth | 3 días | 92% | 45 |
| products | 4 días | 88% | 62 |

## Áreas de Mejora
1. [Área 1]
2. [Área 2]

## Acciones
1. [Acción 1]
2. [Acción 2]
```

---

## Herramientas de Medición

| Métrica | Herramienta |
|---------|-------------|
| Coverage | `flutter test --coverage` + lcov |
| Mutation | stryker-mutator |
| Complejidad | dart_code_metrics |
| Arquitectura | `sdda validate` |
| Tiempo | Git commits, JIRA |

---

## Siguiente Paso

Ver la [Guía de Evaluación](./EVALUACION.md) para interpretar estas métricas.
