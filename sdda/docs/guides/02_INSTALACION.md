# Guía de Instalación

Instrucciones detalladas para instalar y configurar SDDA.

---

## Tabla de Contenidos

1. [Requisitos del Sistema](#requisitos-del-sistema)
2. [Instalación del CLI](#instalación-del-cli)
3. [Configuración del Proyecto](#configuración-del-proyecto)
4. [Verificación de Instalación](#verificación-de-instalación)
5. [Actualización](#actualización)

---

## Requisitos del Sistema

### Software Requerido

| Software | Versión Mínima | Verificar |
|----------|----------------|-----------|
| Flutter | 3.24.0 | `flutter --version` |
| Dart | 3.5.0 | `dart --version` |
| Git | 2.0+ | `git --version` |

### Dependencias del Proyecto Flutter

Asegúrate de tener estas dependencias en tu `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.0
  equatable: ^2.0.5

  # Dependency Injection
  get_it: ^7.6.0
  injectable: ^2.3.0

  # Functional Programming
  dartz: ^0.10.1

  # HTTP
  dio: ^5.4.0

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Secure Storage
  flutter_secure_storage: ^9.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Mocking
  mocktail: ^1.0.0

  # BLoC Testing
  bloc_test: ^9.1.0

  # Code Generation
  injectable_generator: ^2.4.0
  build_runner: ^2.4.0

  # Linting
  flutter_lints: ^3.0.0
```

---

## Instalación del CLI

### Opción 1: Integrado en Proyecto (Recomendado)

```bash
# 1. Copiar directorio sdda a tu proyecto
cp -r /path/to/sdda ./sdda

# 2. Instalar dependencias
cd sdda/05_generators
dart pub get

# 3. Crear alias (opcional)
echo 'alias sdda="dart run $(pwd)/bin/sdda.dart"' >> ~/.bashrc
source ~/.bashrc
```

### Opción 2: Instalación Global

```bash
# 1. Ir al directorio del CLI
cd sdda/05_generators

# 2. Compilar ejecutable
dart compile exe bin/sdda.dart -o sdda

# 3. Mover a PATH
sudo mv sdda /usr/local/bin/

# 4. Verificar
sdda --version
```

### Opción 3: Ejecución Directa

```bash
# Ejecutar sin instalar
dart run /path/to/sdda/05_generators/bin/sdda.dart <comando>
```

---

## Configuración del Proyecto

### Inicializar SDDA

```bash
# Desde la raíz de tu proyecto Flutter
sdda init
```

Esto crea la siguiente estructura:

```
sdda/
├── sdda.yaml                 # Configuración principal
├── analysis_options.yaml     # Reglas de linting
├── 01_specs/                 # Especificaciones
├── 02_contracts/             # Tests como contratos
├── 03_context/               # Contexto para IA
│   ├── architecture/
│   ├── conventions/
│   └── patterns/
└── 04_prompts/               # Templates de prompts
```

### Configurar sdda.yaml

Edita `sdda/sdda.yaml` según tu proyecto:

```yaml
version: "1.0"
name: "Mi Proyecto"

# Configuración de IA
ai_providers:
  default: "claude"
  providers:
    - name: "claude"
      model: "claude-sonnet-4-20250514"

# Arquitectura
architecture:
  pattern: "clean_architecture"
  state_management: "bloc"
  di_framework: "get_it_injectable"

# Testing
testing:
  unit:
    framework: "flutter_test"
    mocking: "mocktail"
    coverage_threshold: 80
  bloc:
    framework: "bloc_test"

# Quality Gates
quality:
  require_tests: true
  require_documentation: true
  max_complexity: 10
```

### Configurar Contexto

1. **Documentar tu Arquitectura**:
   ```bash
   # Editar arquitectura específica de tu proyecto
   nano sdda/03_context/architecture/ARCHITECTURE.md
   ```

2. **Definir Convenciones**:
   ```bash
   # Ajustar convenciones a tu equipo
   nano sdda/03_context/conventions/CONVENTIONS.md
   ```

3. **Agregar Patrones de Ejemplo**:
   - Copia ejemplos de código existente de tu proyecto
   - Colócalos en `sdda/03_context/patterns/examples/`

---

## Verificación de Instalación

### Test de CLI

```bash
# Verificar versión
sdda --version
# Output: SDDA CLI v1.0.0

# Verificar ayuda
sdda --help
```

### Test de Generación

```bash
# Crear feature de prueba
sdda generate feature test_feature

# Verificar archivos generados
ls -la lib/features/test_feature/

# Limpiar
rm -rf lib/features/test_feature/
rm -rf test/features/test_feature/
```

### Test de Validación

```bash
# Validar proyecto
sdda validate --all
```

---

## Actualización

### Actualizar CLI

```bash
cd sdda/05_generators
git pull origin main
dart pub get

# Si está compilado globalmente
dart compile exe bin/sdda.dart -o sdda
sudo mv sdda /usr/local/bin/
```

### Actualizar Contexto

```bash
# Sincronizar templates
cp -r /path/to/new/sdda/03_context/patterns ./sdda/03_context/

# Mantener tus customizaciones en:
# - sdda/03_context/architecture/
# - sdda/03_context/conventions/
```

---

## Problemas Comunes de Instalación

### Error: "dart: command not found"

```bash
# Agregar Flutter/Dart al PATH
export PATH="$PATH:/path/to/flutter/bin"
```

### Error: "Package not found"

```bash
cd sdda/05_generators
dart pub get
```

### Error de Permisos

```bash
# En macOS/Linux
chmod +x sdda/05_generators/bin/sdda.dart
```

---

## Siguiente Paso

Continúa con la [Guía de Conceptos](./03_CONCEPTOS.md) para entender la filosofía de SDDA.
