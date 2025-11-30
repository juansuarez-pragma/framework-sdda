# Métricas del Framework SDDA

Indicadores clave para medir la efectividad del desarrollo con SDDA.

---

## Principio Fundamental de Cobertura

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

El objetivo de SDDA es generar código **100% correcto**. Esto solo es verificable con **100% de cobertura** en código que contiene lógica.

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
| Crítico | < 80% | 🔴 Inaceptable |
| Insuficiente | 80-94% | 🟡 Mejorar |
| Aceptable | 95-99% | 🟢 Casi completo |
| **Target SDDA** | **100%*** | 🟢 **Requerido** |

*\*100% del código testeable (ver [Excepciones Justificadas](#excepciones-justificadas-al-100))*

**Cómo medir**:
```bash
flutter test --coverage
lcov --summary coverage/lcov.info

# Output esperado:
# lines......: 100.0% (1447 of 1447 lines)
```

**Por capa (OBLIGATORIO)**:
| Capa | Target | Justificación |
|------|--------|---------------|
| Domain (Entities) | 100% | Lógica de negocio pura |
| Domain (UseCases) | 100% | Reglas de negocio críticas |
| Data (Repositories) | 100% | Coordinación de datos |
| Data (DataSources) | 100% | Comunicación externa |
| Data (Models) | 100%* | Serialización JSON |
| Presentation (BLoC) | 100% | Gestión de estado |
| Presentation (Widgets) | 100%** | Comportamiento UI |

*\*Excluir código auto-generado (.g.dart)*
*\*\*Excluir widgets puramente declarativos sin lógica*

---

### Excepciones Justificadas al 100%

Basado en investigación de [Very Good Ventures](https://www.verygood.ventures/blog/road-to-100-test-coverage) y mejores prácticas de la industria, las **únicas excepciones válidas** son:

#### ✅ Código que PUEDE excluirse del coverage

| Tipo | Razón | Ejemplo |
|------|-------|---------|
| **Código auto-generado** | No es código que escribimos | `*.g.dart`, `*.freezed.dart` |
| **Localizaciones generadas** | Generado por herramientas | `l10n/*.dart` |
| **Assets generados** | Referencias automáticas | `assets.gen.dart` |
| **Constructores const** | Ejecutados antes de tests | `const MyWidget()` |
| **main() de la app** | Punto de entrada | `lib/main.dart` |
| **Configuración de DI** | Setup de inyección | `injection.dart` |

#### ❌ Código que NUNCA puede excluirse

| Tipo | Razón |
|------|-------|
| **UseCases** | Contienen lógica de negocio |
| **BLoCs/Cubits** | Contienen lógica de estado |
| **Repository Implementations** | Contienen lógica de coordinación |
| **Validaciones** | Contienen reglas críticas |
| **Mappers/Converters** | Contienen transformaciones |
| **Error Handlers** | Contienen flujo de errores |

#### Configuración de Exclusiones

```yaml
# lcov.yaml o en CI/CD
exclude:
  - "**/*.g.dart"           # json_serializable
  - "**/*.freezed.dart"     # freezed
  - "**/*.gen.dart"         # assets
  - "**/l10n/**"            # localizaciones
  - "**/injection.dart"     # DI setup
  - "**/main.dart"          # entry point
  - "**/firebase_options.dart"  # config generado
```

```bash
# Comando para filtrar coverage
lcov --remove coverage/lcov.info \
  '**/*.g.dart' \
  '**/*.freezed.dart' \
  '**/l10n/*' \
  -o coverage/lcov_filtered.info
```

---

### 2. Mutation Score (Puntuación de Mutación)

**Definición**: Porcentaje de mutantes (código modificado) detectados por tests.

| Nivel | Score | Interpretación |
|-------|-------|----------------|
| Crítico | < 70% | Tests no detectan cambios |
| Insuficiente | 70-84% | Tests parcialmente efectivos |
| Bueno | 85-94% | Tests robustos |
| **Target SDDA** | **≥ 95%** | **Tests exhaustivos** |

> **Nota**: 100% de coverage NO garantiza tests de calidad. El mutation score verifica que los tests realmente detectan errores.

**Cómo medir**:
```bash
dart run stryker:stryker

# Output esperado:
# Mutation Score: 96.2%
# Killed: 245, Survived: 10, Timeout: 3
```

---

### 3. Complejidad Ciclomática

**Definición**: Número de caminos linealmente independientes en el código.

| Complejidad | Riesgo | Acción |
|-------------|--------|--------|
| 1-10 | Bajo | ✅ Aceptable |
| 11-20 | Medio | ⚠️ Revisar |
| 21-50 | Alto | 🔴 Refactorizar |
| > 50 | Muy Alto | 🔴 Dividir |

**Target SDDA**: Máximo 10 por método.

> **Justificación**: Código con complejidad > 10 es difícil de testear al 100%. Si la complejidad es alta, el código debe refactorizarse ANTES de generar tests.

---

### 4. Violaciones de Arquitectura

**Definición**: Imports que violan las reglas de dependencia de Clean Architecture.

| Violación | Severidad |
|-----------|-----------|
| Domain importa Data | 🔴 Crítica |
| Domain importa Presentation | 🔴 Crítica |
| Presentation importa Data | 🔴 Crítica |
| Data importa Presentation | 🔴 Crítica |

**Target**: 0 violaciones (no negociable).

---

## Métricas de Testing

### 5. Test Pass Rate

**Definición**: Porcentaje de tests que pasan.

| Rate | Estado |
|------|--------|
| < 100% | 🔴 **BLOQUEA DEPLOY** |
| **100%** | 🟢 **Único valor aceptable** |

> En SDDA, un test que falla significa que el código generado es incorrecto. **No se despliega código con tests fallando.**

---

### 6. Contract Coverage (Cobertura de Contrato)

**Definición**: Porcentaje de comportamientos especificados cubiertos por tests-contrato.

| Coverage | Estado |
|----------|--------|
| < 90% | 🔴 Especificación incompleta |
| 90-99% | 🟡 Casi completo |
| **100%** | 🟢 **Requerido** |

**Fórmula**:
```
Contract Coverage = (Tests escritos / Comportamientos en spec) × 100
```

**Cada spec DEBE tener tests para**:
- ✅ Todos los casos de éxito
- ✅ Todas las validaciones
- ✅ Todos los failures definidos
- ✅ Todos los edge cases identificados

---

### 7. Test Distribution (Pirámide)

```
                    ┌───────────┐
                    │   E2E     │  5%
                    │   Tests   │
                   ─┴───────────┴─
                  ┌───────────────┐
                  │ Integration   │  15%
                  │    Tests      │
                 ─┴───────────────┴─
                ┌───────────────────┐
                │   Widget Tests    │  25%
               ─┴───────────────────┴─
              ┌───────────────────────┐
              │     Unit Tests        │  55%
              └───────────────────────┘
```

| Tipo | Porcentaje | Coverage interno |
|------|------------|------------------|
| Unit | 55% | 100% |
| Widget | 25% | 100% |
| Integration | 15% | 100% |
| E2E | 5% | Flujos críticos |

---

### 8. Flaky Test Rate

**Definición**: Porcentaje de tests que fallan intermitentemente.

| Rate | Estado |
|------|--------|
| > 1% | 🔴 Inaceptable |
| 0.1-1% | 🟡 Investigar |
| **0%** | 🟢 **Target** |

> Tests flaky indican problemas de diseño. En SDDA, un test flaky es un **bug** que debe corregirse inmediatamente.

---

## Métricas de Productividad

### 9. Feature Delivery Time

| Complejidad | Target |
|-------------|--------|
| Simple (1-2 UseCases) | 1-2 días |
| Media (3-5 UseCases) | 3-5 días |
| Compleja (6+ UseCases) | 1-2 semanas |

**Desglose típico SDDA**:
```
┌────────────────────────────────────────────────────┐
│              Feature Delivery Time                  │
├────────────────────────────────────────────────────┤
│                                                     │
│   SPECIFY    ████████░░░░░░░░░░░░░░  20%           │
│   CONTRACT   ████████████░░░░░░░░░░  30%           │
│   GENERATE   ██████░░░░░░░░░░░░░░░░  15%           │
│   VALIDATE   ██████████████████░░░░  35%           │
│                                                     │
└────────────────────────────────────────────────────┘
```

> **Nota**: VALIDATE incluye asegurar 100% coverage. El tiempo adicional se compensa con **0 bugs en producción**.

---

### 10. Code Generation Ratio

| Ratio | Nivel |
|-------|-------|
| < 70% | Bajo |
| 70-85% | Medio |
| **85-95%** | **Target SDDA** |
| > 95% | Óptimo |

**Por componente**:
| Componente | % Generado | % Tests Generados |
|------------|------------|-------------------|
| Entities | 95% | 100% |
| Models | 98% | 100% |
| Repository Interface | 98% | N/A |
| Repository Impl | 90% | 100% |
| UseCases | 95% | 100% |
| BLoC | 90% | 100% |
| Widgets | 60% | 100% |

---

### 11. Rework Rate

| Rate | Estado |
|------|--------|
| > 15% | 🔴 Especificación deficiente |
| 5-15% | 🟡 Mejorar contexto |
| **< 5%** | 🟢 **Target** |
| 0% | 🟢 Óptimo |

---

## Métricas de Proceso

### 12. Specification Completeness

**Checklist OBLIGATORIO** (100% requerido):

- [ ] Entidades definidas con todos los campos
- [ ] Tipos de datos especificados
- [ ] Validaciones documentadas
- [ ] Failures listados exhaustivamente
- [ ] UseCases con params y return types
- [ ] API endpoints definidos (si aplica)
- [ ] Eventos del BLoC listados
- [ ] Estados del BLoC con propiedades
- [ ] Criterios de aceptación claros
- [ ] Edge cases identificados

**Target**: 100% antes de escribir tests.

---

### 13. First-Pass Success Rate

| Rate | Estado |
|------|--------|
| < 70% | 🔴 Contexto insuficiente |
| 70-85% | 🟡 Mejorar patrones |
| 85-95% | 🟢 Bueno |
| **> 95%** | 🟢 **Target** |

---

## Métricas de IA

### 14. Hallucination Rate

| Rate | Estado |
|------|--------|
| > 10% | 🔴 Contexto muy pobre |
| 5-10% | 🟡 Mejorar documentación |
| 1-5% | 🟢 Aceptable |
| **< 1%** | 🟢 **Target** |

---

### 15. Pattern Adherence

**Criterios** (escala 1-5):
| Criterio | 1 | 5 |
|----------|---|---|
| Estructura de archivos | Diferente | Idéntica |
| Nombrado de clases | Inconsistente | Consistente |
| Manejo de errores | Diferente | Igual al patrón |
| Documentación | Ausente | Completa |
| Imports | Desordenados | Según convención |

**Target**: 5.0 (perfecto)

---

### 16. Prompt Efficiency

| Iteraciones | Eficiencia |
|-------------|------------|
| **1** | 🟢 **Target** |
| 2 | 🟢 Aceptable |
| 3 | 🟡 Revisar prompt |
| > 3 | 🔴 Rediseñar |

---

## Dashboard de Métricas

### Template de Reporte Semanal

```markdown
# Reporte SDDA - Semana [X]

## Resumen Ejecutivo
| Métrica | Target | Actual | Estado |
|---------|--------|--------|--------|
| Coverage (testeable) | 100% | 100% | 🟢 |
| Test Pass | 100% | 100% | 🟢 |
| Mutation Score | ≥95% | 96% | 🟢 |
| First-Pass Success | ≥95% | 97% | 🟢 |
| Hallucination Rate | <1% | 0.5% | 🟢 |
| Rework Rate | <5% | 3% | 🟢 |

## Features Completados
| Feature | Tiempo | Coverage | Mutation | Tests |
|---------|--------|----------|----------|-------|
| auth | 3 días | 100% | 96% | 45 |
| products | 4 días | 100% | 95% | 62 |

## Código Excluido del Coverage
| Archivo | Razón | Aprobado |
|---------|-------|----------|
| *.g.dart | Auto-generado | ✅ |
| l10n/* | Localizaciones | ✅ |
```

---

## Herramientas de Medición

| Métrica | Herramienta |
|---------|-------------|
| Coverage | `flutter test --coverage` + lcov |
| Mutation | stryker-mutator |
| Complejidad | dart_code_metrics |
| Arquitectura | `sdda validate` |

---

## Resumen de Targets SDDA

| Métrica | Target | Negociable |
|---------|--------|------------|
| Code Coverage (testeable) | 100% | ❌ No |
| Test Pass Rate | 100% | ❌ No |
| Mutation Score | ≥95% | ⚠️ Mínimo 90% |
| Architecture Violations | 0 | ❌ No |
| Contract Coverage | 100% | ❌ No |
| Flaky Tests | 0% | ❌ No |
| First-Pass Success | ≥95% | ⚠️ Mínimo 85% |
| Hallucination Rate | <1% | ⚠️ Máximo 5% |
| Rework Rate | <5% | ⚠️ Máximo 10% |

---

## Siguiente Paso

Ver la [Guía de Evaluación](./EVALUACION.md) para interpretar estas métricas.

---

## Referencias

- [Very Good Ventures - Road to 100% Coverage](https://www.verygood.ventures/blog/road-to-100-test-coverage)
- [Stack Overflow - What should NOT be unit tested](https://stackoverflow.com/questions/1084336/what-should-not-be-unit-tested)
- [100% Coverage is not trivial](https://blog.ploeh.dk/2025/11/10/100-coverage-is-not-that-trivial/)
