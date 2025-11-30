# Guía de Inicio Rápido

Comienza a usar SDDA en 5 minutos.

---

## Prerrequisitos

- Flutter SDK 3.24+
- Dart SDK 3.5+
- Un proyecto Flutter existente (o crear uno nuevo)

## Paso 1: Instalar SDDA CLI

```bash
# Clonar o copiar el directorio sdda/ a tu proyecto
cp -r path/to/sdda ./

# Instalar dependencias del CLI
cd sdda/05_generators
dart pub get

# Compilar el CLI (opcional, para uso global)
dart compile exe bin/sdda.dart -o sdda

# O ejecutar directamente con dart
dart run bin/sdda.dart --help
```

## Paso 2: Inicializar en tu Proyecto

```bash
# Desde la raíz de tu proyecto Flutter
cd /path/to/your/flutter/project

# Inicializar SDDA
dart run sdda/05_generators/bin/sdda.dart init
```

Esto crea:
- Estructura de carpetas SDDA
- Archivos de configuración base
- Templates de contexto

## Paso 3: Tu Primer Feature

### 3.1 Crear Especificación

Crea `sdda/01_specs/products_spec.yaml`:

```yaml
feature:
  name: products
  description: "Gestión de productos"

entities:
  - name: Product
    properties:
      - name: id
        type: String
        required: true
      - name: name
        type: String
        required: true
      - name: price
        type: double
        required: true

usecases:
  - name: GetProducts
    description: "Obtiene lista de productos"
    return_type: List<Product>
    params: []

  - name: GetProductById
    description: "Obtiene un producto por ID"
    return_type: Product
    params:
      - name: id
        type: String
        required: true
```

### 3.2 Generar Código

```bash
# Generar feature completo
dart run sdda/05_generators/bin/sdda.dart generate feature products \
  --spec=sdda/01_specs/products_spec.yaml
```

### 3.3 Ver Resultado

```
lib/features/products/
├── data/
│   ├── datasources/
│   │   ├── products_remote_datasource.dart
│   │   └── products_local_datasource.dart
│   ├── models/
│   │   └── product_model.dart
│   └── repositories/
│       └── products_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── product.dart
│   ├── repositories/
│   │   └── products_repository.dart
│   └── usecases/
│       ├── get_products_usecase.dart
│       └── get_product_by_id_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── products_bloc.dart
    │   ├── products_event.dart
    │   └── products_state.dart
    └── pages/
        └── products_page.dart
```

## Paso 4: Validar Código

```bash
# Validar que cumple convenciones
dart run sdda/05_generators/bin/sdda.dart validate --feature=products
```

## Paso 5: Ejecutar Tests

```bash
# Ejecutar tests generados
flutter test test/features/products/
```

---

## Comandos Esenciales

| Comando | Descripción |
|---------|-------------|
| `sdda init` | Inicializar SDDA en proyecto |
| `sdda generate feature <nombre>` | Generar feature completo |
| `sdda generate usecase <nombre> -f <feature>` | Generar UseCase |
| `sdda validate --all` | Validar todo el código |
| `sdda prompt usecase -f <feature> -n <nombre>` | Generar prompt para IA |

## Siguiente Paso

Lee la [Guía de Conceptos](./03_CONCEPTOS.md) para entender la filosofía detrás de SDDA.

---

## Ejemplo Completo

Ver `sdda/06_examples/auth/` para un ejemplo completo del feature de autenticación con:
- Especificación YAML
- Tests como contratos
- Documentación de uso
