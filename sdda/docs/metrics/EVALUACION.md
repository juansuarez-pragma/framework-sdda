# Guía de Evaluación

Cómo evaluar la efectividad del proceso SDDA y la calidad del código generado.

---

## Tipos de Evaluación

1. [Evaluación de Feature Individual](#evaluación-de-feature-individual)
2. [Evaluación de Proceso](#evaluación-de-proceso)
3. [Evaluación de Madurez](#evaluación-de-madurez)
4. [Evaluación Comparativa](#evaluación-comparativa)

---

## Evaluación de Feature Individual

### Checklist de Evaluación Post-Generación

Completar después de generar cada feature:

#### 1. Completitud (¿Se generó todo?)

| Ítem | ✓/✗ |
|------|-----|
| Entity generada | |
| Model con fromJson/toJson | |
| Repository interface | |
| Repository implementation | |
| DataSources (remote/local) | |
| Todos los UseCases | |
| BLoC con events y states | |
| Page básica | |
| Tests unitarios | |
| Tests de BLoC | |

**Score**: ___ / 10

#### 2. Corrección (¿Funciona correctamente?)

| Ítem | ✓/✗ |
|------|-----|
| Compila sin errores | |
| Pasa análisis estático | |
| Todos los tests pasan | |
| Coverage ≥ 80% | |
| No hay imports incorrectos | |
| Sigue convenciones de nombrado | |

**Score**: ___ / 6

#### 3. Adherencia a Patrones (¿Sigue los ejemplos?)

| Ítem | 1-5 |
|------|-----|
| Estructura de UseCase igual al ejemplo | |
| Estructura de BLoC igual al ejemplo | |
| Estructura de Repository igual al ejemplo | |
| Manejo de errores consistente | |
| Documentación presente | |

**Score**: ___ / 25

#### 4. Calidad de Código

| Ítem | 1-5 |
|------|-----|
| Código legible y claro | |
| Sin código duplicado | |
| Complejidad ciclomática < 10 | |
| Sin warnings de linter | |
| Bien estructurado | |

**Score**: ___ / 25

### Cálculo de Score Total

```
Score Total = (Completitud × 2) + (Corrección × 3) + Adherencia + Calidad
             ─────────────────────────────────────────────────────────────
                                         88

Máximo posible: (10×2) + (6×3) + 25 + 25 = 88 puntos
```

| Score | Calificación |
|-------|--------------|
| 80-88 | A (Excelente) |
| 70-79 | B (Bueno) |
| 60-69 | C (Aceptable) |
| 50-59 | D (Mejorar) |
| < 50 | F (Inaceptable) |

---

## Evaluación de Proceso

### Formulario de Evaluación del Ciclo SDDA

Completar al final de cada sprint:

#### Fase SPECIFY

| Pregunta | 1-5 |
|----------|-----|
| ¿Las especificaciones fueron suficientemente detalladas? | |
| ¿Se identificaron todas las entidades necesarias? | |
| ¿Los UseCases cubrieron todos los requisitos? | |
| ¿Las validaciones estaban claras? | |
| ¿Los failures posibles estaban documentados? | |

**Subtotal SPECIFY**: ___ / 25

#### Fase CONTRACT

| Pregunta | 1-5 |
|----------|-----|
| ¿Los tests cubrieron casos de éxito? | |
| ¿Los tests cubrieron casos de error? | |
| ¿Los tests cubrieron validaciones? | |
| ¿Los tests de BLoC cubrieron todas las transiciones? | |
| ¿Los tests fueron escritos ANTES de generar? | |

**Subtotal CONTRACT**: ___ / 25

#### Fase GENERATE

| Pregunta | 1-5 |
|----------|-----|
| ¿La generación fue eficiente (pocas iteraciones)? | |
| ¿El código generado compiló en primer intento? | |
| ¿No hubo alucinaciones (APIs inventadas)? | |
| ¿El código siguió los patrones de ejemplo? | |
| ¿La documentación fue generada correctamente? | |

**Subtotal GENERATE**: ___ / 25

#### Fase VALIDATE

| Pregunta | 1-5 |
|----------|-----|
| ¿Los tests pasaron en primer intento? | |
| ¿La cobertura alcanzó el target (≥80%)? | |
| ¿No hubo violaciones de arquitectura? | |
| ¿El análisis estático fue limpio? | |
| ¿El rework necesario fue mínimo? | |

**Subtotal VALIDATE**: ___ / 25

### Score de Proceso

```
Score Proceso = SPECIFY + CONTRACT + GENERATE + VALIDATE
                ─────────────────────────────────────────
                              100
```

| Score | Calificación | Acción |
|-------|--------------|--------|
| 90-100 | Excelente | Mantener |
| 80-89 | Bueno | Mejoras menores |
| 70-79 | Aceptable | Revisar fases débiles |
| 60-69 | Regular | Plan de mejora |
| < 60 | Deficiente | Reentrenamiento |

---

## Evaluación de Madurez

### Modelo de Madurez SDDA

#### Nivel 1: Inicial
- [ ] CLI instalado y funcionando
- [ ] Estructura de carpetas creada
- [ ] Al menos 1 feature generado
- [ ] Tests básicos implementados

#### Nivel 2: Repetible
- [ ] Patrones de ejemplo documentados
- [ ] Convenciones definidas
- [ ] ≥3 features generados exitosamente
- [ ] Coverage promedio ≥70%
- [ ] Proceso documentado

#### Nivel 3: Definido
- [ ] Arquitectura completamente documentada
- [ ] Todos los patrones con ejemplos
- [ ] Prompts optimizados
- [ ] Coverage promedio ≥80%
- [ ] Métricas registradas
- [ ] ≥10 features generados

#### Nivel 4: Gestionado
- [ ] Métricas automatizadas
- [ ] CI/CD integrado
- [ ] Dashboard de métricas
- [ ] First-pass success ≥80%
- [ ] Hallucination rate <5%
- [ ] Proceso de mejora continua

#### Nivel 5: Optimizado
- [ ] Generación casi completamente automatizada
- [ ] Retroalimentación automática a prompts
- [ ] Coverage promedio ≥90%
- [ ] Mutation score ≥80%
- [ ] Tiempo de feature reducido >50%
- [ ] Equipo completamente capacitado

### Checklist de Madurez

```
Nivel Actual: ___

Próximo nivel requiere:
1. [ ] ____________________
2. [ ] ____________________
3. [ ] ____________________
```

---

## Evaluación Comparativa

### Antes vs Después de SDDA

#### Métricas de Productividad

| Métrica | Sin SDDA | Con SDDA | Mejora |
|---------|----------|----------|--------|
| Tiempo por feature | ___ días | ___ días | ___% |
| Bugs en producción | ___ /mes | ___ /mes | ___% |
| Cobertura promedio | ___% | ___% | ___% |
| Tiempo en rework | ___ hrs | ___ hrs | ___% |

#### Métricas de Calidad

| Métrica | Sin SDDA | Con SDDA | Mejora |
|---------|----------|----------|--------|
| Complejidad promedio | ___ | ___ | ___% |
| Violaciones arq. | ___ | ___ | ___% |
| Test flakiness | ___% | ___% | ___% |
| Code review issues | ___ | ___ | ___% |

### Cálculo de ROI

```
Horas ahorradas por feature:
  Sin SDDA: ___ horas
  Con SDDA: ___ horas
  Ahorro:   ___ horas

Features por mes: ___

Ahorro mensual: ___ horas × ___ features = ___ horas

Costo por hora desarrollador: $___

ROI mensual: ___ horas × $___ = $___
```

---

## Templates de Evaluación

### Template: Evaluación Post-Feature

```markdown
# Evaluación de Feature: [nombre]

**Fecha**: ____
**Evaluador**: ____

## Especificación
- Archivo: ____
- Completitud: ___/10

## Generación
- Método: CLI / IA directa / Híbrido
- Iteraciones: ___
- Tiempo: ___

## Validación
- Tests: ___ pasaron / ___ total
- Coverage: ___%
- Análisis: ✓ Limpio / ✗ ___ issues

## Score Total: ___/88 = [A/B/C/D/F]

## Observaciones
- ____
- ____

## Mejoras para próximo feature
1. ____
2. ____
```

### Template: Retrospectiva Sprint SDDA

```markdown
# Retrospectiva SDDA - Sprint [X]

**Fecha**: ____
**Participantes**: ____

## Métricas del Sprint
| Métrica | Target | Actual |
|---------|--------|--------|
| Features completados | ___ | ___ |
| Coverage promedio | ≥80% | ___% |
| First-pass success | ≥70% | ___% |

## ¿Qué funcionó bien?
1. ____
2. ____

## ¿Qué podemos mejorar?
1. ____
2. ____

## Acciones para próximo sprint
| Acción | Responsable | Fecha |
|--------|-------------|-------|
| ____ | ____ | ____ |
| ____ | ____ | ____ |
```

---

## Proceso de Mejora Continua

### Ciclo PDCA para SDDA

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   ┌─────────┐                         ┌─────────┐              │
│   │  PLAN   │──────────────────────▶│   DO    │              │
│   │         │                         │         │              │
│   │ Definir │                         │ Ejecutar│              │
│   │ mejoras │                         │ sprint  │              │
│   └─────────┘                         └─────────┘              │
│        ▲                                    │                   │
│        │                                    │                   │
│        │                                    ▼                   │
│   ┌─────────┐                         ┌─────────┐              │
│   │   ACT   │◀──────────────────────│  CHECK  │              │
│   │         │                         │         │              │
│   │Ajustar  │                         │ Evaluar │              │
│   │proceso  │                         │métricas │              │
│   └─────────┘                         └─────────┘              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Frecuencia de Evaluación

| Evaluación | Frecuencia |
|------------|------------|
| Feature individual | Cada feature |
| Proceso | Cada sprint |
| Madurez | Mensual |
| Comparativa | Trimestral |

---

## Siguiente Paso

Ver los [Benchmarks](./BENCHMARKS.md) para comparar con estándares de la industria.
