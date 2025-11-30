# Troubleshooting

Soluciones a problemas comunes en SDDA.

---

## Índice de Problemas

1. [Problemas de Instalación](#problemas-de-instalación)
2. [Problemas de Generación](#problemas-de-generación)
3. [Problemas de Validación](#problemas-de-validación)
4. [Problemas de Tests](#problemas-de-tests)
5. [Problemas de IA](#problemas-de-ia)
6. [Problemas de CI/CD](#problemas-de-cicd)

---

## Problemas de Instalación

### Error: "sdda command not found"

**Síntoma**:
```bash
$ sdda --version
bash: sdda: command not found
```

**Causas y soluciones**:

1. **No está en el PATH**:
```bash
# Agregar al PATH (bash)
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.bashrc
source ~/.bashrc

# Para zsh
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

2. **No se instaló globalmente**:
```bash
# Instalar globalmente
dart pub global activate --source path sdda/05_generators
```

3. **Usar directamente con dart run**:
```bash
dart run sdda/05_generators/bin/sdda.dart --version
```

---

### Error: "Could not find package"

**Síntoma**:
```bash
$ dart run sdda/05_generators/bin/sdda.dart
Could not find package "sdda" in "sdda/05_generators"
```

**Solución**:
```bash
# 1. Verificar que estás en la raíz del proyecto
pwd  # Debe mostrar la raíz del proyecto Flutter

# 2. Ejecutar pub get
cd sdda/05_generators
dart pub get
cd ../..

# 3. Verificar estructura
ls sdda/05_generators/pubspec.yaml  # Debe existir
```

---

### Error: "Dart SDK version incompatible"

**Síntoma**:
```
The current Dart SDK version is 3.2.0.
Because sdda requires SDK version >=3.5.0, version solving failed.
```

**Solución**:
```bash
# 1. Verificar versión actual
dart --version

# 2. Actualizar Flutter (incluye Dart)
flutter upgrade

# 3. O instalar Dart directamente
# En macOS con Homebrew
brew upgrade dart

# Verificar nueva versión
dart --version  # Debe ser >= 3.5.0
```

---

## Problemas de Generación

### Error: "Specification file not found"

**Síntoma**:
```bash
$ sdda generate feature products --spec=path/to/spec.yaml
Error: Specification file not found: path/to/spec.yaml
```

**Solución**:
```bash
# 1. Verificar que el archivo existe
ls -la sdda/01_specs/features/products/spec.yaml

# 2. Usar ruta correcta (relativa o absoluta)
sdda generate feature products --spec=sdda/01_specs/features/products/spec.yaml

# 3. O navegar al directorio del spec
cd sdda/01_specs/features/products
sdda generate feature products --spec=./spec.yaml
```

---

### Error: "Invalid YAML syntax"

**Síntoma**:
```
Error parsing specification: YamlException: mapping values are not allowed here
```

**Causas comunes**:

1. **Indentación incorrecta**:
```yaml
# ❌ Incorrecto
entities:
- name: Product  # Falta indentación

# ✅ Correcto
entities:
  - name: Product
```

2. **Strings sin comillas**:
```yaml
# ❌ Puede fallar con caracteres especiales
description: Descripción: con dos puntos

# ✅ Correcto
description: "Descripción: con dos puntos"
```

3. **Tabs en lugar de espacios**:
```bash
# Verificar tabs
cat -A sdda/01_specs/features/products/spec.yaml | grep "^I"

# Convertir tabs a espacios
sed -i 's/\t/  /g' sdda/01_specs/features/products/spec.yaml
```

**Herramienta de validación**:
```bash
# Validar YAML online o con yq
yq eval '.' sdda/01_specs/features/products/spec.yaml

# O con Python
python3 -c "import yaml; yaml.safe_load(open('spec.yaml'))"
```

---

### Error: "Feature directory already exists"

**Síntoma**:
```
Error: Feature directory already exists: lib/features/products
Use --force to overwrite
```

**Soluciones**:

1. **Regenerar con --force** (sobrescribe todo):
```bash
sdda generate feature products --spec=... --force
```

2. **Regenerar solo un componente**:
```bash
# Solo el UseCase
sdda generate usecase get_products --feature=products --force

# Solo el BLoC
sdda generate bloc products --feature=products --force
```

3. **Hacer backup primero**:
```bash
# Backup
cp -r lib/features/products lib/features/products_backup

# Regenerar
sdda generate feature products --spec=... --force

# Comparar cambios
diff -r lib/features/products lib/features/products_backup
```

---

### Error: "Unknown entity type"

**Síntoma**:
```
Error: Unknown entity type 'CustomType' in property 'status'
```

**Solución**:

1. **Definir el tipo en la especificación**:
```yaml
entities:
  # Definir el enum/type primero
  - name: ProductStatus
    type: enum
    values:
      - active
      - inactive
      - discontinued

  # Luego usarlo
  - name: Product
    properties:
      - name: status
        type: ProductStatus  # Ahora es reconocido
```

2. **O usar tipos básicos**:
```yaml
properties:
  - name: status
    type: String  # active | inactive | discontinued
    validation: "enum:active,inactive,discontinued"
```

---

## Problemas de Validación

### Error: "Architecture violation detected"

**Síntoma**:
```
Architecture violation: Domain layer importing from Data layer
  File: lib/features/products/domain/usecases/get_products.dart
  Import: package:app/features/products/data/models/product_model.dart
```

**Causa**: El código generado o editado manualmente viola Clean Architecture.

**Solución**:

1. **Entender las reglas**:
```
Domain → Solo puede importar: Core, otros Domain
Data   → Puede importar: Domain, Core
Presentation → Puede importar: Domain, Core (no Data directamente)
```

2. **Corregir el import**:
```dart
// ❌ Incorrecto en Domain
import 'package:app/features/products/data/models/product_model.dart';

// ✅ Correcto - usar Entity del Domain
import 'package:app/features/products/domain/entities/product.dart';
```

3. **Si necesitas el Model**:
```dart
// En Data layer, el Model extiende la Entity
class ProductModel extends Product {
  // Conversión JSON aquí
}
```

---

### Error: "Naming convention violation"

**Síntoma**:
```
Naming violation: Class 'productBloc' should be 'ProductBloc' (PascalCase)
```

**Solución**:
```dart
// ❌ Incorrecto
class productBloc extends Bloc { }

// ✅ Correcto
class ProductBloc extends Bloc { }
```

**Convenciones SDDA**:
| Tipo | Convención | Ejemplo |
|------|------------|---------|
| Clases | PascalCase | `ProductBloc` |
| Archivos | snake_case | `product_bloc.dart` |
| Variables | camelCase | `productList` |
| Constantes | lowerCamelCase | `defaultPageSize` |
| Privados | _camelCase | `_internalState` |

---

### Error: "Missing required tests"

**Síntoma**:
```
Validation failed: Missing tests for UseCase 'GetProducts'
Expected: test/features/products/domain/usecases/get_products_test.dart
```

**Solución**:
```bash
# 1. Crear el archivo de test
touch test/features/products/domain/usecases/get_products_test.dart

# 2. Generar test con CLI
sdda generate test usecase get_products --feature=products

# 3. O copiar template y adaptar
cp sdda/02_contracts/unit/auth/login_usecase_test.dart \
   test/features/products/domain/usecases/get_products_test.dart
```

---

## Problemas de Tests

### Error: "MockRepository not found"

**Síntoma**:
```
Error: Undefined class 'MockProductRepository'.
```

**Solución**:
```dart
// 1. Crear el mock con mocktail
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

// 2. O con build_runner (mockito)
@GenerateMocks([ProductRepository])
import 'get_products_test.mocks.dart';

// Ejecutar build_runner
// flutter pub run build_runner build
```

---

### Error: "Type 'Null' is not a subtype of type 'Future<Either<Failure, List<Product>>>'"

**Síntoma**: El mock no está configurado correctamente.

**Solución**:
```dart
// ❌ Incorrecto - mock no configurado
final result = await useCase(params);  // Retorna null

// ✅ Correcto - configurar mock primero
setUp(() {
  mockRepository = MockProductRepository();
  useCase = GetProducts(mockRepository);
});

test('debe retornar productos', () async {
  // Arrange - CONFIGURAR EL MOCK
  when(() => mockRepository.getProducts())
      .thenAnswer((_) async => Right(tProducts));

  // Act
  final result = await useCase(NoParams());

  // Assert
  expect(result, Right(tProducts));
});
```

---

### Error: "Fallback value not registered"

**Síntoma**:
```
Bad state: No fallback value was registered for type 'GetProductsParams'.
```

**Solución**:
```dart
void main() {
  // Registrar fallback ANTES de los tests
  setUpAll(() {
    registerFallbackValue(GetProductsParams(category: 'test'));
  });

  // Ahora los tests pueden usar any()
  test('ejemplo', () {
    when(() => mockRepository.getProducts(any()))
        .thenAnswer((_) async => Right([]));
  });
}
```

---

### Error: "BLoC test timeout"

**Síntoma**:
```
TimeoutException after 0:00:30.000000: Test timed out
```

**Causas y soluciones**:

1. **El BLoC no emitió todos los estados esperados**:
```dart
blocTest<ProductBloc, ProductState>(
  'emite [Loading, Loaded]',
  build: () {
    // Verificar que el mock está configurado
    when(() => mockGetProducts(any()))
        .thenAnswer((_) async => Right(tProducts));
    return ProductBloc(getProducts: mockGetProducts);
  },
  act: (bloc) => bloc.add(LoadProducts()),
  expect: () => [
    ProductLoading(),
    ProductLoaded(products: tProducts),
  ],
  // Aumentar timeout si es necesario
  wait: const Duration(seconds: 3),
);
```

2. **Stream no se completa**:
```dart
// Si el BLoC usa streams, asegurar que se cierren
tearDown(() {
  bloc.close();
});
```

---

### Error: "Coverage below threshold"

**Síntoma**:
```
Coverage 72.5% is below minimum threshold of 80%
```

**Diagnóstico**:
```bash
# Ver qué archivos tienen baja cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**Soluciones**:

1. **Agregar tests faltantes**:
```bash
# Ver líneas no cubiertas
lcov --list coverage/lcov.info | grep -v "100.0%"
```

2. **Excluir archivos generados** (si aplica):
```yaml
# En analysis_options.yaml o lcov config
# Excluir archivos .g.dart, .freezed.dart, etc.
```

3. **Agregar tests para edge cases**:
```dart
group('edge cases', () {
  test('maneja lista vacía', () { ... });
  test('maneja null values', () { ... });
  test('maneja errores de red', () { ... });
});
```

---

## Problemas de IA

### Problema: "La IA genera código que no compila"

**Síntomas**:
- Referencias a clases inexistentes
- Métodos con firma incorrecta
- Imports de paquetes no instalados

**Soluciones**:

1. **Mejorar el contexto**:
```bash
# Asegurar que el contexto está actualizado
cat sdda/03_context/architecture/ARCHITECTURE.md
cat sdda/03_context/patterns/examples/*.dart
```

2. **Incluir dependencias en el prompt**:
```markdown
## Dependencias disponibles
- dartz: ^0.10.1 (Either, Left, Right)
- bloc: ^8.1.0 (Bloc, Cubit)
- equatable: ^2.0.5 (Equatable)
```

3. **Proporcionar ejemplos exactos**:
```markdown
## Ejemplo de UseCase existente
[Copiar código completo de un UseCase que funciona]
```

---

### Problema: "La IA inventa APIs que no existen"

**Síntomas**:
```dart
// La IA genera esto pero el método no existe
repository.fetchProductsWithCache(params);
```

**Soluciones**:

1. **Documentar la interfaz exacta**:
```markdown
## Repository Interface (usar EXACTAMENTE estos métodos)
```dart
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(String id);
  // NO hay otros métodos
}
```

2. **Usar validación post-generación**:
```bash
# Validar inmediatamente
flutter analyze lib/features/[nuevo]/
```

---

### Problema: "La IA no sigue los patrones del proyecto"

**Causa**: Contexto insuficiente o mal estructurado.

**Solución**:

1. **Mejorar los ejemplos**:
```bash
# Agregar más ejemplos variados
sdda/03_context/patterns/examples/
├── simple_usecase.dart      # UseCase sin params
├── params_usecase.dart      # UseCase con params
├── validation_usecase.dart  # UseCase con validaciones
└── stream_usecase.dart      # UseCase con streams
```

2. **Ser explícito en el prompt**:
```markdown
## IMPORTANTE: Seguir EXACTAMENTE este patrón

1. El UseCase DEBE extender UseCase<Params, ReturnType>
2. El método call() DEBE ser async
3. DEBE usar Either<Failure, Success>
4. NO usar try/catch directo, el Repository maneja errores
```

---

## Problemas de CI/CD

### Error: "GitHub Actions workflow failing"

**Síntoma**: El workflow falla en el paso de Flutter setup.

**Solución**:
```yaml
# .github/workflows/sdda.yml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.24.0'  # Especificar versión exacta
    channel: 'stable'
    cache: true
```

---

### Error: "Coverage report not generated"

**Síntoma**:
```
Error: lcov: cannot open coverage/lcov.info
```

**Solución**:
```yaml
- name: Run Tests with Coverage
  run: |
    flutter test --coverage
    # Verificar que se generó
    ls -la coverage/

- name: Install lcov
  run: |
    sudo apt-get update
    sudo apt-get install -y lcov

- name: Generate Report
  run: |
    lcov --summary coverage/lcov.info
```

---

### Error: "Pre-commit hook not running"

**Síntoma**: Los hooks no se ejecutan al hacer commit.

**Solución**:
```bash
# 1. Verificar que el hook tiene permisos
chmod +x .git/hooks/pre-commit

# 2. Verificar contenido
cat .git/hooks/pre-commit

# 3. Verificar que git los usa
git config core.hooksPath  # Debe estar vacío o ser .git/hooks

# 4. Si usa husky, reinstalar
npm install
npx husky install
```

---

## Comandos de Diagnóstico

### Verificar instalación completa

```bash
#!/bin/bash
echo "=== Diagnóstico SDDA ==="

echo -e "\n[1] Flutter version:"
flutter --version

echo -e "\n[2] Dart version:"
dart --version

echo -e "\n[3] SDDA structure:"
ls -la sdda/

echo -e "\n[4] Dependencies:"
cd sdda/05_generators && dart pub get && cd ../..

echo -e "\n[5] CLI test:"
dart run sdda/05_generators/bin/sdda.dart --version

echo -e "\n[6] Validate:"
dart run sdda/05_generators/bin/sdda.dart validate --all

echo -e "\n=== Diagnóstico completo ==="
```

### Limpiar y reinstalar

```bash
#!/bin/bash
echo "=== Limpieza SDDA ==="

# 1. Limpiar cache de pub
flutter clean
dart pub cache clean

# 2. Reinstalar dependencias
flutter pub get
cd sdda/05_generators && dart pub get && cd ../..

# 3. Verificar
dart run sdda/05_generators/bin/sdda.dart --version

echo "=== Limpieza completa ==="
```

---

## Obtener Ayuda

Si el problema persiste:

1. **Verificar documentación**: Revisar las guías en `sdda/docs/`
2. **Revisar ejemplos**: Ver `sdda/06_examples/`
3. **Ejecutar diagnóstico**: Usar scripts de esta guía
4. **Revisar logs**: `flutter test --verbose`

---

## Siguiente Paso

Ver las [Preguntas Frecuentes (FAQ)](./FAQ.md) para más información.
