# Guía para Codex: Análisis de Errores y Soluciones

Este documento analiza los errores que Codex generó previamente y proporciona orientación para evitarlos en el futuro.

## Diagnóstico de los Errores Reportados

### Error 1: `fixtureName` y `_fixtureContent` no definidos

**Síntomas reportados:**
```
RepositoryGenerator usaba getters/métodos no definidos: fixtureName y _fixtureContent
```

**Análisis:**
Codex intentó agregar funcionalidad de "fixtures" (datos de prueba) al `RepositoryGenerator`, pero:
1. Creó referencias a métodos/propiedades que nunca implementó
2. No siguió el patrón existente en el código base
3. Hizo cambios parciales sin completar la implementación

**Código actual que funciona:**
```dart
// repository_generator.dart - Líneas 94-142
String _buildInterfaceContent() {
  // Usa métodos existentes: buffer.writeln(), StringBuffer()
  // NO tiene fixtures - genera código base que el usuario completa
}
```

**Lo que Codex probablemente intentó hacer:**
```dart
// INCORRECTO - Codex agregó algo como:
String get fixtureName => '${repositoryName}Fixture';
String _fixtureContent() { ... } // Nunca implementado completamente
```

**Por qué falló:**
- El framework SDDA genera **plantillas/esqueletos**, no código completo
- Los fixtures deben venir de **especificaciones YAML**, no hardcodeados
- El generador actual usa `// TODO:` para indicar qué completar

---

### Error 2: `_validateDependencyGraph` y `_checkLayerEdge` no implementados

**Síntomas reportados:**
```
CodeValidator invocaba métodos no implementados: _validateDependencyGraph y _checkLayerEdge
```

**Análisis:**
Codex intentó agregar validación de dependencias entre capas de Clean Architecture, pero:
1. Agregó llamadas a métodos que nunca definió
2. Intentó implementar validación compleja sin la infraestructura necesaria

**Código actual que funciona:**
```dart
// code_validator.dart - El validador actual valida:
// - Reglas generales (print, debugPrint, TODO, dynamic)
// - Reglas por tipo (usecase, bloc, repository, model, entity)
// - Ubicación de archivos
// NO tiene validación de grafos de dependencia
```

**Lo que Codex probablemente intentó hacer:**
```dart
// INCORRECTO - Codex agregó algo como:
void _validateArchitecture(String filePath) {
  _validateDependencyGraph(filePath); // Método inexistente
  _checkLayerEdge(layer1, layer2);     // Método inexistente
}
```

**Por qué falló:**
- Validar grafos de dependencia requiere:
  1. Parser de imports de Dart
  2. Construcción del grafo
  3. Detección de ciclos
  4. Reglas de capas (domain no importa data, etc.)
- El validador actual usa **regex simple** para detectar imports problemáticos
- Ver líneas 191-196, 229-234: validan imports con `content.contains('/data/')`

---

## Patrones Correctos vs Incorrectos

### ❌ INCORRECTO: Agregar métodos sin implementarlos

```dart
class SomeGenerator {
  void generate() {
    _methodThatDoesNotExist(); // ERROR: Undefined
  }
}
```

### ✅ CORRECTO: Implementar completamente o no agregar

```dart
class SomeGenerator {
  void generate() {
    _implementedMethod(); // OK: Método existe
  }

  void _implementedMethod() {
    // Implementación completa
  }
}
```

---

### ❌ INCORRECTO: Generar código que requiere dependencias inexistentes

```dart
// Generar import a archivo que no existe
buffer.writeln("import '../entities/entity.dart';"); // Si entity.dart no existe
```

### ✅ CORRECTO: Usar tipos genéricos o comentar imports

```dart
// El código actual usa 'Entity' como placeholder genérico
buffer.writeln("import '../entities/\${returnType.toLowerCase()}.dart';");
// O comenta imports que el usuario debe ajustar
buffer.writeln("// import '../entities/your_entity.dart';");
```

---

## Filosofía del Framework SDDA

### 1. Generadores = Plantillas, No Código Final

Los generadores crean **esqueletos** con:
- Estructura correcta
- Imports básicos
- `// TODO:` donde el usuario debe completar
- Comentarios explicativos

**NO deben generar:**
- Lógica de negocio específica
- Fixtures hardcodeados
- Código que asume contexto que no tienen

### 2. Validadores = Reglas Simples, No Análisis Profundo

El validador actual usa:
- `content.contains()` para detectar patrones
- Regex simples para tipos dinámicos
- Verificación de ubicación de archivos

**NO intenta:**
- Parsear AST de Dart
- Construir grafos de dependencia
- Análisis semántico profundo

### 3. El Usuario Completa, La IA No Adivina

El ciclo SDDA es:
```
Especificación YAML → Generador crea plantilla → Usuario completa → Validador verifica
```

**NO es:**
```
IA intenta generar código completo y funcional sin contexto
```

---

## Cómo Contribuir Correctamente

### Si quieres agregar fixtures al RepositoryGenerator:

1. **Primero**: Define el formato en la especificación YAML
```yaml
# sdda/01_specs/templates/repository_spec.yaml
fixtures:
  - name: "testTask"
    entity: "Task"
    values:
      id: "1"
      title: "Test"
```

2. **Luego**: Lee la spec en el generador
```dart
final fixtures = spec['fixtures'] as List? ?? [];
```

3. **Después**: Genera código basado en la spec
```dart
for (final fixture in fixtures) {
  buffer.writeln("final ${fixture['name']} = ${fixture['entity']}(...);");
}
```

### Si quieres agregar validación de dependencias:

1. **Primero**: Implementa el parser de imports
```dart
List<String> _extractImports(String content) {
  final regex = RegExp(r"import\s+'([^']+)'");
  return regex.allMatches(content).map((m) => m.group(1)!).toList();
}
```

2. **Luego**: Implementa la lógica de validación
```dart
void _checkLayerViolation(String filePath, List<String> imports) {
  final layer = _detectLayer(filePath);
  for (final import in imports) {
    if (_violatesLayer(layer, import)) {
      // Agregar error
    }
  }
}
```

3. **Después**: Integra en el validador existente
```dart
void validateFile(String path) {
  // ... código existente ...
  _checkLayerViolation(path, _extractImports(content));
}
```

---

## Resumen de Lecciones

| Problema | Causa | Solución |
|----------|-------|----------|
| Métodos no definidos | Refactor incompleto | Implementar completamente antes de usar |
| Imports rotos | Generar código para archivos inexistentes | Usar placeholders o comentarios |
| Validación compleja | Sobrestimar capacidades actuales | Empezar con validación simple |
| Fixtures hardcodeados | No usar especificaciones | Leer de YAML specs |

---

## Estado Actual del Framework

El framework SDDA **funciona correctamente** en su estado actual:

- ✅ CLI genera código base
- ✅ Validador verifica reglas básicas
- ✅ Estructura Clean Architecture
- ✅ Tests con 100% cobertura (demostrado en `sdda_demo`)

**NO necesita:**
- Fixtures automáticos (el usuario los define)
- Validación de grafos de dependencia (imports simples son suficientes)
- Generación de código "inteligente" (las plantillas funcionan)

---

## Recomendaciones Finales para Codex

1. **Lee el código existente antes de modificar** - Entiende los patrones actuales
2. **No agregues llamadas a métodos inexistentes** - Implementa primero
3. **Prueba incrementalmente** - `dart analyze` después de cada cambio pequeño
4. **Respeta la filosofía SDDA** - Plantillas simples, no código complejo
5. **Si algo parece muy complejo, probablemente lo es** - Simplifica

El framework ya funciona. Mejoras deben ser **incrementales** y **completas**.
