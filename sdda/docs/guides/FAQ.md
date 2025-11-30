# Preguntas Frecuentes (FAQ)

Respuestas a las preguntas más comunes sobre SDDA.

---

## Índice

1. [Conceptos Generales](#conceptos-generales)
2. [Especificaciones](#especificaciones)
3. [Generación de Código](#generación-de-código)
4. [Testing](#testing)
5. [Integración con IA](#integración-con-ia)
6. [Mejores Prácticas](#mejores-prácticas)

---

## Conceptos Generales

### ¿Qué significa SDDA?

**SDDA** = **Specification-Driven Development for AI Agents**

Es una metodología que estructura el desarrollo asistido por IA mediante:
- **Especificaciones** formales antes de generar código
- **Tests como contratos** que definen el comportamiento esperado
- **Contexto estructurado** que guía a la IA
- **Validación automática** del código generado

---

### ¿Por qué no simplemente pedirle a la IA que genere código?

Sin estructura, la IA tiende a:

| Problema | Sin SDDA | Con SDDA |
|----------|----------|----------|
| Alucinaciones | 30-50% | <10% |
| Código inconsistente | Frecuente | Raro |
| No compila | Común | Raro |
| No sigue patrones | Siempre | Casi nunca |
| Difícil de mantener | Sí | No |

SDDA reduce el "efecto lotería" de la generación con IA.

---

### ¿SDDA reemplaza a los desarrolladores?

**No.** SDDA cambia el rol del desarrollador:

```
ANTES (Desarrollo Tradicional):
Desarrollador → Escribe código → Debug → Refactor

AHORA (Con SDDA):
Desarrollador → Especifica → Contrata (tests) → Valida → Integra
```

El desarrollador se convierte en **arquitecto y validador**, no en "escribidor de código".

---

### ¿Qué nivel de experiencia necesito?

| Tarea | Nivel Requerido |
|-------|-----------------|
| Escribir especificaciones | Junior+ (con guía) |
| Escribir tests-contrato | Mid+ |
| Configurar SDDA | Mid+ |
| Optimizar prompts | Senior |
| Diseñar arquitectura | Senior |

---

### ¿Funciona con otros frameworks además de Flutter?

SDDA está diseñado para Flutter, pero los principios aplican a cualquier stack:

- **React/Next.js**: Adaptable con modificaciones
- **Node.js/Express**: Adaptable
- **Swift/iOS**: Adaptable
- **Kotlin/Android**: Adaptable

Los cambios necesarios:
1. Adaptar estructura de carpetas
2. Crear patrones de ejemplo para el stack
3. Ajustar convenciones de nombrado

---

## Especificaciones

### ¿Qué tan detallada debe ser una especificación?

**Regla general**: Si la IA tiene que "adivinar", falta detalle.

```yaml
# ❌ Demasiado vago
usecases:
  - name: GetProducts
    description: "Obtiene productos"

# ✅ Suficiente detalle
usecases:
  - name: GetProducts
    description: "Obtiene lista paginada de productos activos"
    return_type: Either<Failure, PaginatedList<Product>>
    params:
      - name: page
        type: int
        required: false
        default: 1
        validation: "page >= 1"
      - name: pageSize
        type: int
        required: false
        default: 20
        validation: "pageSize >= 1 && pageSize <= 100"
    failures:
      - NetworkFailure: "Sin conexión"
      - ServerFailure: "Error del servidor"
```

---

### ¿Debo especificar TODOS los campos de una entidad?

**Sí**, incluyendo:
- Tipo de dato exacto
- Si es requerido
- Validaciones
- Valores por defecto

```yaml
entities:
  - name: Product
    properties:
      - name: id
        type: String
        required: true
        validation: "UUID format"
      - name: name
        type: String
        required: true
        validation: "length >= 3 && length <= 100"
      - name: price
        type: double
        required: true
        validation: "price > 0"
      - name: discount
        type: double
        required: false
        default: 0.0
        validation: "discount >= 0 && discount <= 100"
```

---

### ¿Cómo documento los failures/errores posibles?

Listarlos explícitamente con condiciones:

```yaml
failures:
  - ValidationFailure: "Cuando los parámetros no pasan validación"
  - NetworkFailure: "Cuando no hay conexión a internet"
  - ServerFailure: "Cuando el servidor retorna 5xx"
  - NotFoundFailure: "Cuando el recurso no existe (404)"
  - UnauthorizedFailure: "Cuando el token es inválido (401)"
  - CacheFailure: "Cuando falla la lectura/escritura de cache local"
```

---

### ¿Puedo tener múltiples archivos de especificación?

**Sí**, se recomienda para features complejos:

```
sdda/01_specs/features/ecommerce/
├── spec.yaml           # Metadata y overview
├── entities.yaml       # Todas las entidades
├── usecases.yaml       # Todos los UseCases
├── api.yaml            # Definición de API
└── bloc.yaml           # Estados y eventos
```

El CLI puede combinarlos:
```bash
sdda generate feature ecommerce --spec=sdda/01_specs/features/ecommerce/
```

---

## Generación de Código

### ¿Cuánto código genera SDDA automáticamente?

| Componente | % Generado | Manual |
|------------|-----------|--------|
| Entities | 95% | Lógica de negocio compleja |
| Models | 95% | Mapeos especiales |
| Repository Interface | 98% | Casi nada |
| Repository Impl | 80% | Lógica de cache, retry |
| DataSources | 75% | Configuraciones específicas |
| UseCases | 85% | Lógica compleja |
| BLoC | 80% | Estados complejos |
| Widgets | 50% | Diseño UI personalizado |
| Tests | 90% | Edge cases específicos |

---

### ¿Puedo generar solo parte de un feature?

**Sí**, usando comandos específicos:

```bash
# Solo UseCases
sdda generate usecases --feature=products

# Solo un UseCase específico
sdda generate usecase get_products --feature=products

# Solo BLoC
sdda generate bloc --feature=products

# Solo Repository
sdda generate repository --feature=products

# Solo Tests
sdda generate tests --feature=products
```

---

### ¿Qué hago si el código generado tiene errores?

1. **Primero, validar**:
```bash
sdda validate --feature=products
flutter analyze lib/features/products/
```

2. **Si es error de compilación**:
   - Verificar imports
   - Verificar tipos
   - Regenerar con más contexto

3. **Si es error de lógica**:
   - Revisar especificación
   - Mejorar los tests-contrato
   - Regenerar

4. **Si persiste**:
   - Editar manualmente
   - Documentar el fix para futuros prompts

---

### ¿Cómo evito sobrescribir código que modifiqué manualmente?

1. **Usar --no-overwrite**:
```bash
sdda generate feature products --no-overwrite
# Solo genera archivos que no existen
```

2. **Generar componentes específicos**:
```bash
# Solo regenerar lo que necesitas
sdda generate usecase new_usecase --feature=products
```

3. **Usar control de versiones**:
```bash
# Siempre commit antes de regenerar
git add -A && git commit -m "antes de regenerar"

# Regenerar
sdda generate feature products --force

# Revisar cambios
git diff
```

---

## Testing

### ¿Por qué debo escribir tests ANTES de generar código?

Los tests-contrato sirven como:

1. **Especificación ejecutable**: Definen EXACTAMENTE qué debe hacer el código
2. **Validación automática**: Verifican que el código generado es correcto
3. **Documentación viva**: Explican el comportamiento esperado
4. **Guía para la IA**: Le dicen a la IA qué implementar

```
Sin tests previos:
  IA genera código → ¿Está bien? → ¿Quién sabe? → Debug manual

Con tests previos:
  Tests definen comportamiento → IA genera → Tests validan → ✓ o ✗ claro
```

---

### ¿Cuántos tests debo escribir por UseCase?

**Mínimo recomendado**:

| Categoría | Tests Mínimos |
|-----------|---------------|
| Caso de éxito | 1-2 |
| Validaciones | 1 por validación |
| Casos de error | 1 por failure |
| Edge cases | 2-3 |

**Ejemplo para GetProducts**:
```dart
group('GetProducts', () {
  // Éxito
  test('retorna productos cuando el repository tiene éxito', ...);
  test('retorna lista vacía cuando no hay productos', ...);

  // Validaciones
  test('falla con ValidationFailure cuando page < 1', ...);
  test('falla con ValidationFailure cuando pageSize > 100', ...);

  // Errores
  test('retorna NetworkFailure cuando no hay conexión', ...);
  test('retorna ServerFailure cuando el servidor falla', ...);

  // Edge cases
  test('maneja correctamente caracteres especiales en búsqueda', ...);
  test('funciona con pageSize = 1', ...);
});
```

---

### ¿Qué cobertura de código debo alcanzar?

| Capa | Target | Mínimo |
|------|--------|--------|
| Domain (UseCases) | 95% | 90% |
| Data (Repository) | 85% | 80% |
| Presentation (BLoC) | 90% | 85% |
| Presentation (Widgets) | 70% | 60% |
| **Global** | **85%** | **80%** |

---

### ¿Cómo organizo los tests?

```
test/
├── features/
│   └── products/
│       ├── domain/
│       │   └── usecases/
│       │       ├── get_products_test.dart
│       │       └── get_product_by_id_test.dart
│       ├── data/
│       │   └── repositories/
│       │       └── product_repository_impl_test.dart
│       └── presentation/
│           └── bloc/
│               └── product_bloc_test.dart
├── fixtures/           # Datos de prueba compartidos
│   └── product_fixtures.dart
└── helpers/            # Utilidades de test
    ├── mock_helpers.dart
    └── test_helpers.dart
```

---

## Integración con IA

### ¿Qué IA funciona mejor con SDDA?

| IA | Calidad | Notas |
|----|---------|-------|
| Claude 3.5 Sonnet | Excelente | Mejor para código Flutter |
| GPT-4 | Muy buena | Bueno con contexto largo |
| GPT-4 Turbo | Buena | Más rápido, menos preciso |
| Gemini Pro | Buena | Mejorando rápidamente |
| Claude 3 Opus | Excelente | Mejor razonamiento |

**Recomendación**: Claude 3.5 Sonnet o GPT-4 para generación de código Flutter.

---

### ¿Cuánto contexto debo incluir en el prompt?

**Balance óptimo**:

```
Contexto mínimo (rápido pero impreciso):
- Solo especificación
- ~500-1000 tokens
- First-pass success: 40-50%

Contexto óptimo (balanceado):
- Especificación
- 1-2 ejemplos de patrones
- Convenciones principales
- ~2000-4000 tokens
- First-pass success: 70-80%

Contexto máximo (preciso pero costoso):
- Todo lo anterior
- Múltiples ejemplos
- Tests existentes
- ~8000+ tokens
- First-pass success: 85-95%
```

---

### ¿Cómo reduzco las alucinaciones de la IA?

1. **Documentar APIs exactas**:
```markdown
## Repository Interface (SOLO estos métodos)
- getProducts(): Future<Either<Failure, List<Product>>>
- getProductById(String id): Future<Either<Failure, Product>>
NO HAY OTROS MÉTODOS
```

2. **Proporcionar ejemplos completos**:
```markdown
## Ejemplo completo de UseCase
[Código completo que funciona]
```

3. **Ser explícito sobre restricciones**:
```markdown
## RESTRICCIONES
- NO usar paquetes que no estén en pubspec.yaml
- NO crear métodos nuevos en interfaces existentes
- NO usar try/catch (usar Either)
```

4. **Validar inmediatamente**:
```bash
flutter analyze lib/features/[nuevo]/
```

---

### ¿Puedo usar SDDA sin IA?

**Sí**, SDDA también funciona como:
- Sistema de documentación estructurada
- Framework de testing organizado
- Guía de arquitectura
- Generador de boilerplate (sin IA)

```bash
# Generar estructura sin código
sdda generate feature products --skeleton-only

# Luego implementar manualmente siguiendo la estructura
```

---

## Mejores Prácticas

### ¿Cómo empiezo con SDDA en un proyecto existente?

1. **Semana 1**: Setup e inventario
```bash
# Instalar SDDA
sdda init

# Documentar arquitectura existente
# Llenar ARCHITECTURE.md y CONVENTIONS.md
```

2. **Semana 2-3**: Crear ejemplos de patrones
```bash
# Extraer 1 feature existente como ejemplo
# Documentar en sdda/03_context/patterns/examples/
```

3. **Semana 4+**: Usar para nuevos features
```bash
# Cada nuevo feature usa el flujo completo
sdda generate feature [nuevo] --spec=...
```

---

### ¿Cuánto tiempo toma adoptar SDDA?

| Fase | Tiempo | Actividad |
|------|--------|-----------|
| Setup inicial | 1-2 días | Instalar, configurar |
| Documentar contexto | 2-3 días | ARCHITECTURE.md, ejemplos |
| Primer feature | 1-2 días | Aprender el flujo |
| Productividad | ~2 semanas | Flujo natural |
| Optimizado | ~1 mes | Prompts ajustados, métricas |

**ROI**: Después de 3-4 features, el tiempo se recupera.

---

### ¿Cómo mantengo actualizado el contexto?

1. **Con cada cambio arquitectónico**:
```bash
# Actualizar documentación
nano sdda/03_context/architecture/ARCHITECTURE.md
```

2. **Con cada nuevo patrón**:
```bash
# Agregar ejemplo
cp lib/features/.../nuevo_patron.dart sdda/03_context/patterns/examples/
```

3. **Revisión periódica**:
```bash
# Cada sprint, verificar que el contexto refleja el código actual
sdda validate --context
```

---

### ¿Qué errores debo evitar?

| Error | Consecuencia | Solución |
|-------|--------------|----------|
| Especificaciones vagas | IA adivina mal | Ser específico |
| No escribir tests primero | Sin validación | TDD estricto |
| Contexto desactualizado | Código inconsistente | Actualizar con cada cambio |
| Saltar validación | Bugs en producción | Validar siempre |
| No medir métricas | Sin mejora | Registrar todo |

---

### ¿Cómo escalo SDDA a un equipo grande?

1. **Estandarizar**:
   - Un solo sdda.yaml para el proyecto
   - Contexto compartido en repositorio
   - Convenciones documentadas

2. **Capacitar**:
   - Sesión de 2-3 horas para todo el equipo
   - Pair programming en primeros features
   - Code review enfocado en adherencia a patrones

3. **Medir**:
   - Dashboard de métricas compartido
   - Retrospectivas sobre el proceso
   - Ajustar basado en datos

4. **Iterar**:
   - Mejorar prompts con aprendizajes
   - Expandir ejemplos
   - Optimizar CI/CD

---

## Siguiente Paso

Ver la [Referencia del CLI](../api/CLI_REFERENCE.md) para comandos detallados.
