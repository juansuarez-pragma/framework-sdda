# Quality Engineering as Code (QEaC) para Flutter

## Documento de Investigación Completo

**Versión:** 1.0
**Fecha:** Noviembre 2025
**Autor:** Investigación QEaC
**Alcance:** Infraestructura de Pruebas para Aplicaciones Flutter

---

## Índice General

1. [Resumen Ejecutivo](#1-resumen-ejecutivo)
2. [Fundamentos de Testing en Flutter](#2-fundamentos-de-testing-en-flutter)
3. [Pirámide de Pruebas para Flutter](#3-pirámide-de-pruebas-para-flutter)
4. [Pruebas Unitarias](#4-pruebas-unitarias)
5. [Pruebas de Widgets](#5-pruebas-de-widgets)
6. [Pruebas de Integración y E2E](#6-pruebas-de-integración-y-e2e)
7. [Mutation Testing](#7-mutation-testing)
8. [Verificación Visual y Comparación con Figma](#8-verificación-visual-y-comparación-con-figma)
9. [CI/CD y Granjas de Pruebas](#9-cicd-y-granjas-de-pruebas)
10. [Detección de Errores y Flujo de Análisis](#10-detección-de-errores-y-flujo-de-análisis)
11. [Inteligencia Artificial en Testing](#11-inteligencia-artificial-en-testing)
12. [Testing as Code (TaC) - Plantillas Parametrizables](#12-testing-as-code-tac---plantillas-parametrizables)
13. [Arquitectura Testeable - Buenas Prácticas](#13-arquitectura-testeable---buenas-prácticas)
14. [Implementación de Referencia](#14-implementación-de-referencia)
15. [Conclusiones y Recomendaciones](#15-conclusiones-y-recomendaciones)

---

## 1. Resumen Ejecutivo

### 1.1 Objetivo del Documento

Este documento presenta una investigación exhaustiva sobre la creación de infraestructuras de pruebas de código para aplicaciones Flutter, siguiendo el paradigma de **Quality Engineering as Code (QEaC)**. El objetivo es proporcionar una guía completa para implementar, parametrizar y escalar infraestructuras de testing que puedan ser replicadas en múltiples repositorios.

### 1.2 ¿Qué es Quality Engineering as Code (QEaC)?

QEaC es un paradigma que aplica los principios de **Infrastructure as Code (IaC)** al dominio del aseguramiento de calidad. Esto significa:

- **Versionamiento**: Toda la configuración de pruebas está en control de versiones
- **Reproducibilidad**: Los entornos de prueba son idénticos en cualquier máquina
- **Automatización**: Despliegue automático de infraestructura de testing
- **Parametrización**: Configuraciones adaptables mediante variables
- **Reutilización**: Plantillas que pueden aplicarse a múltiples proyectos

### 1.3 Alcance de la Investigación

| Área | Cobertura |
|------|-----------|
| Pruebas Unitarias | Completa |
| Pruebas de Widgets | Completa |
| Pruebas de Integración | Completa |
| Pruebas E2E | Completa |
| Mutation Testing | Completa |
| Verificación Visual | Completa |
| CI/CD | Completa |
| IA para Testing | Completa |
| Testing as Code | Completa |

### 1.4 Fuentes de Investigación

Esta investigación se basa en:
- Documentación oficial de Flutter
- Mejores prácticas de la industria (2024-2025)
- Herramientas y frameworks actualizados
- Estándares de calidad de software (ISO 25010)

---

## 2. Fundamentos de Testing en Flutter

### 2.1 Filosofía de Testing en Flutter

Flutter proporciona un ecosistema robusto para pruebas que incluye el paquete `flutter_test` como base fundamental. La filosofía de testing en Flutter se basa en:

1. **Pruebas Rápidas y Aisladas**: Las pruebas unitarias y de widgets se ejecutan sin necesidad de un dispositivo
2. **Renderizado Completo**: Las pruebas de widgets renderizan el árbol de widgets real
3. **Integración Nativa**: El framework está diseñado pensando en la testabilidad

### 2.2 Tipos de Pruebas Soportados

```
┌─────────────────────────────────────────────────────────────────┐
│                    TIPOS DE PRUEBAS FLUTTER                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│   │   UNITARIAS │  │   WIDGETS   │  │     INTEGRACIÓN/E2E     │ │
│   ├─────────────┤  ├─────────────┤  ├─────────────────────────┤ │
│   │ • Funciones │  │ • UI aislada│  │ • App completa          │ │
│   │ • Clases    │  │ • Interacc. │  │ • Flujos de usuario     │ │
│   │ • Métodos   │  │ • Estados   │  │ • Servicios externos    │ │
│   │ • Lógica    │  │ • Layouts   │  │ • Dispositivos reales   │ │
│   └─────────────┘  └─────────────┘  └─────────────────────────┘ │
│                                                                  │
│   Velocidad: Alta ◄──────────────────────────────────► Baja     │
│   Cobertura: Baja ◄──────────────────────────────────► Alta     │
│   Costo:     Bajo ◄──────────────────────────────────► Alto     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 2.3 Paquetes Fundamentales

| Paquete | Propósito | Instalación |
|---------|-----------|-------------|
| `flutter_test` | Framework base de testing | Incluido en SDK |
| `mockito` | Generación de mocks | `dev_dependencies` |
| `mocktail` | Mocks sin generación de código | `dev_dependencies` |
| `fake_async` | Control de tiempo asíncrono | `dev_dependencies` |
| `bloc_test` | Testing de BLoCs | `dev_dependencies` |
| `patrol` | Testing E2E avanzado | `dev_dependencies` |

### 2.4 Estructura de Carpetas Recomendada

```
proyecto_flutter/
├── lib/
│   ├── core/
│   ├── features/
│   │   └── feature_a/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   └── main.dart
├── test/                          # Pruebas unitarias y de widgets
│   ├── core/
│   ├── features/
│   │   └── feature_a/
│   │       ├── data/
│   │       │   └── repositories/
│   │       ├── domain/
│   │       │   └── usecases/
│   │       └── presentation/
│   │           ├── bloc/
│   │           └── widgets/
│   ├── fixtures/                  # Datos de prueba (JSON, mocks)
│   ├── helpers/                   # Utilidades compartidas
│   │   ├── pump_app.dart
│   │   ├── mock_helpers.dart
│   │   └── test_injection.dart
│   └── golden/                    # Archivos golden (imágenes)
├── integration_test/              # Pruebas de integración
│   ├── app_test.dart
│   ├── features/
│   └── robots/                    # Pattern Robot para E2E
└── test_driver/                   # Driver para pruebas
    └── integration_test.dart
```

### 2.5 Configuración Base del Proyecto

**pubspec.yaml:**
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter

  # Mocking
  mockito: ^5.4.4
  build_runner: ^2.4.8
  mocktail: ^1.0.3

  # Testing de estado
  bloc_test: ^9.1.7

  # Testing E2E
  integration_test:
    sdk: flutter
  patrol: ^3.6.1

  # Golden tests
  golden_toolkit: ^0.15.0

  # Cobertura
  coverage: ^1.7.2
```

---

## 3. Pirámide de Pruebas para Flutter

### 3.1 Concepto de la Pirámide

La pirámide de pruebas es un modelo que indica la proporción ideal de cada tipo de prueba:

```
                    ▲
                   /█\              E2E (5-10%)
                  /███\             • Flujos críticos de negocio
                 /█████\            • Pruebas en dispositivos reales
                ─────────
               /█████████\          INTEGRACIÓN (15-25%)
              /███████████\         • Interacción entre módulos
             /█████████████\        • APIs y servicios
            ─────────────────
           /█████████████████\      WIDGETS (25-35%)
          /███████████████████\     • Componentes UI
         /█████████████████████\    • Interacciones de usuario
        ─────────────────────────
       /█████████████████████████\  UNITARIAS (40-50%)
      /███████████████████████████\ • Lógica de negocio
     /█████████████████████████████\• Funciones puras
    ─────────────────────────────────
```

### 3.2 Distribución Recomendada para Flutter

| Tipo de Prueba | Porcentaje | Tiempo de Ejecución | Frecuencia |
|----------------|------------|---------------------|------------|
| Unitarias | 40-50% | Milisegundos | Cada commit |
| Widgets | 25-35% | Segundos | Cada commit |
| Integración | 15-25% | Minutos | Cada PR |
| E2E | 5-10% | 10-30 min | Pre-release |

### 3.3 Métricas de Calidad Objetivo

```yaml
quality_gates:
  coverage:
    minimum_total: 80%
    minimum_new_code: 90%

  tests:
    unit_tests_passing: 100%
    widget_tests_passing: 100%
    integration_tests_passing: 100%

  mutation_score:
    minimum: 70%

  visual_regression:
    max_diff_percentage: 0.1%
```

---

## 4. Pruebas Unitarias

### 4.1 Principios de Pruebas Unitarias

Las pruebas unitarias en Flutter siguen el patrón **AAA (Arrange-Act-Assert)**:

```dart
// test/features/auth/domain/usecases/login_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AuthRepository])
import 'login_usecase_test.mocks.dart';

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    // ARRANGE - Configuración inicial
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  group('LoginUseCase', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    final tUser = User(id: '1', email: tEmail);

    test('debe retornar User cuando el login es exitoso', () async {
      // ARRANGE - Configurar comportamiento del mock
      when(mockRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => Right(tUser));

      // ACT - Ejecutar la acción
      final result = await useCase(
        LoginParams(email: tEmail, password: tPassword),
      );

      // ASSERT - Verificar resultados
      expect(result, Right(tUser));
      verify(mockRepository.login(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('debe retornar AuthFailure cuando las credenciales son inválidas', () async {
      // ARRANGE
      when(mockRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => Left(InvalidCredentialsFailure()));

      // ACT
      final result = await useCase(
        LoginParams(email: tEmail, password: tPassword),
      );

      // ASSERT
      expect(result, Left(InvalidCredentialsFailure()));
    });
  });
}
```

### 4.2 Testing con Mocktail (Sin Generación de Código)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Definición de mocks
class MockUserRepository extends Mock implements UserRepository {}
class FakeUser extends Fake implements User {}

void main() {
  late GetUserUseCase useCase;
  late MockUserRepository mockRepository;

  setUpAll(() {
    // Registrar fakes para cualquier() matchers
    registerFallbackValue(FakeUser());
  });

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetUserUseCase(mockRepository);
  });

  test('debe obtener usuario por ID', () async {
    // Arrange
    final user = User(id: '123', name: 'Test User');
    when(() => mockRepository.getUserById('123'))
        .thenAnswer((_) async => user);

    // Act
    final result = await useCase('123');

    // Assert
    expect(result, equals(user));
    verify(() => mockRepository.getUserById('123')).called(1);
  });
}
```

### 4.3 Testing de Streams y Async

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_async/fake_async.dart';

void main() {
  group('StreamController Tests', () {
    test('debe emitir valores en orden correcto', () async {
      final controller = StreamController<int>();
      final values = <int>[];

      controller.stream.listen(values.add);

      controller.add(1);
      controller.add(2);
      controller.add(3);

      await Future.microtask(() {});

      expect(values, [1, 2, 3]);
      await controller.close();
    });

    test('debe manejar timeouts correctamente', () {
      fakeAsync((async) {
        var completed = false;

        Future.delayed(Duration(seconds: 5)).then((_) {
          completed = true;
        });

        expect(completed, false);

        async.elapse(Duration(seconds: 5));

        expect(completed, true);
      });
    });
  });
}
```

### 4.4 Testing de BLoC/Cubit

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

void main() {
  late ProductBloc bloc;
  late MockGetProductsUseCase mockGetProducts;

  setUp(() {
    mockGetProducts = MockGetProductsUseCase();
    bloc = ProductBloc(getProducts: mockGetProducts);
  });

  tearDown(() {
    bloc.close();
  });

  group('ProductBloc', () {
    final tProducts = [
      Product(id: '1', name: 'Product 1'),
      Product(id: '2', name: 'Product 2'),
    ];

    blocTest<ProductBloc, ProductState>(
      'debe emitir [Loading, Loaded] cuando GetProducts es exitoso',
      build: () {
        when(() => mockGetProducts())
            .thenAnswer((_) async => Right(tProducts));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadProducts()),
      expect: () => [
        ProductLoading(),
        ProductLoaded(products: tProducts),
      ],
      verify: (_) {
        verify(() => mockGetProducts()).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'debe emitir [Loading, Error] cuando GetProducts falla',
      build: () {
        when(() => mockGetProducts())
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadProducts()),
      expect: () => [
        ProductLoading(),
        ProductError(message: 'Error del servidor'),
      ],
    );
  });
}
```

### 4.5 Fixtures y Factories

```dart
// test/fixtures/fixture_reader.dart
import 'dart:io';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

// test/fixtures/user_fixture.json
{
  "id": "123",
  "email": "test@example.com",
  "name": "Test User",
  "created_at": "2024-01-15T10:30:00Z"
}

// test/helpers/factories/user_factory.dart
class UserFactory {
  static User create({
    String? id,
    String? email,
    String? name,
  }) {
    return User(
      id: id ?? 'default-id',
      email: email ?? 'default@test.com',
      name: name ?? 'Default User',
    );
  }

  static List<User> createList(int count) {
    return List.generate(
      count,
      (index) => create(
        id: 'id-$index',
        email: 'user$index@test.com',
        name: 'User $index',
      ),
    );
  }

  static User fromFixture() {
    final json = jsonDecode(fixture('user_fixture.json'));
    return User.fromJson(json);
  }
}
```

---

## 5. Pruebas de Widgets

### 5.1 Conceptos Fundamentales

Las pruebas de widgets verifican que los componentes de UI funcionen correctamente de forma aislada. A diferencia de las pruebas unitarias, estas renderizan el widget completo.

```dart
// test/helpers/pump_app.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    ThemeData? theme,
    Locale? locale,
    List<Override>? providerOverrides,
  }) async {
    await pumpWidget(
      MaterialApp(
        theme: theme ?? ThemeData.light(),
        locale: locale ?? const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: widget),
      ),
    );
    await pump();
  }

  Future<void> pumpAppWithProviders(
    Widget widget, {
    required List<SingleChildWidget> providers,
  }) async {
    await pumpWidget(
      MultiProvider(
        providers: providers,
        child: MaterialApp(
          home: Scaffold(body: widget),
        ),
      ),
    );
    await pump();
  }
}
```

### 5.2 Testing de Widgets Básicos

```dart
// test/features/products/presentation/widgets/product_card_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/factories/product_factory.dart';

void main() {
  group('ProductCard Widget', () {
    testWidgets('debe mostrar nombre y precio del producto', (tester) async {
      // Arrange
      final product = ProductFactory.create(
        name: 'Laptop Pro',
        price: 999.99,
      );

      // Act
      await tester.pumpApp(
        ProductCard(product: product),
      );

      // Assert
      expect(find.text('Laptop Pro'), findsOneWidget);
      expect(find.text('\$999.99'), findsOneWidget);
    });

    testWidgets('debe mostrar imagen placeholder cuando no hay imagen', (tester) async {
      final product = ProductFactory.create(imageUrl: null);

      await tester.pumpApp(ProductCard(product: product));

      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });

    testWidgets('debe llamar onTap cuando se presiona la tarjeta', (tester) async {
      var wasTapped = false;
      final product = ProductFactory.create();

      await tester.pumpApp(
        ProductCard(
          product: product,
          onTap: () => wasTapped = true,
        ),
      );

      await tester.tap(find.byType(ProductCard));
      await tester.pump();

      expect(wasTapped, isTrue);
    });

    testWidgets('debe mostrar badge de descuento cuando aplica', (tester) async {
      final product = ProductFactory.create(
        originalPrice: 100.0,
        price: 75.0,
        hasDiscount: true,
      );

      await tester.pumpApp(ProductCard(product: product));

      expect(find.text('-25%'), findsOneWidget);
      expect(find.byType(DiscountBadge), findsOneWidget);
    });
  });
}
```

### 5.3 Testing de Interacciones Complejas

```dart
// test/features/auth/presentation/pages/login_page_test.dart

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  group('LoginPage', () {
    testWidgets('debe mostrar error cuando email es inválido', (tester) async {
      await tester.pumpApp(
        BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginPage(),
        ),
      );

      // Ingresar email inválido
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'invalid-email',
      );

      // Presionar botón de login
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Verificar mensaje de error
      expect(find.text('Email inválido'), findsOneWidget);
    });

    testWidgets('debe mostrar loading cuando se envía el formulario', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthLoading());

      await tester.pumpApp(
        BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginPage(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsNothing);
    });

    testWidgets('debe navegar a home después de login exitoso', (tester) async {
      final authBlocController = StreamController<AuthState>();

      whenListen(
        mockAuthBloc,
        authBlocController.stream,
        initialState: AuthInitial(),
      );

      await tester.pumpApp(
        BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginPage(),
        ),
      );

      // Simular login exitoso
      authBlocController.add(AuthAuthenticated(user: UserFactory.create()));
      await tester.pumpAndSettle();

      // Verificar navegación
      expect(find.byType(HomePage), findsOneWidget);

      await authBlocController.close();
    });
  });
}
```

### 5.4 Testing de Scroll y Listas

```dart
void main() {
  group('ProductListPage', () {
    testWidgets('debe cargar más productos al hacer scroll', (tester) async {
      final products = ProductFactory.createList(20);
      final mockBloc = MockProductListBloc();

      when(() => mockBloc.state).thenReturn(
        ProductListLoaded(products: products, hasMore: true),
      );

      await tester.pumpApp(
        BlocProvider<ProductListBloc>.value(
          value: mockBloc,
          child: const ProductListPage(),
        ),
      );

      // Verificar productos iniciales
      expect(find.byType(ProductCard), findsWidgets);

      // Scroll hasta el final
      await tester.dragUntilVisible(
        find.byKey(const Key('load_more_indicator')),
        find.byType(ListView),
        const Offset(0, -500),
      );

      await tester.pump();

      // Verificar que se solicitaron más productos
      verify(() => mockBloc.add(LoadMoreProducts())).called(1);
    });

    testWidgets('debe mostrar empty state cuando no hay productos', (tester) async {
      final mockBloc = MockProductListBloc();
      when(() => mockBloc.state).thenReturn(
        ProductListLoaded(products: [], hasMore: false),
      );

      await tester.pumpApp(
        BlocProvider<ProductListBloc>.value(
          value: mockBloc,
          child: const ProductListPage(),
        ),
      );

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text('No hay productos disponibles'), findsOneWidget);
    });
  });
}
```

### 5.5 Testing de Formularios

```dart
// test/features/checkout/presentation/widgets/payment_form_test.dart

void main() {
  group('PaymentForm', () {
    testWidgets('debe validar número de tarjeta', (tester) async {
      await tester.pumpApp(const PaymentForm());

      final cardField = find.byKey(const Key('card_number_field'));

      // Número muy corto
      await tester.enterText(cardField, '1234');
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Número de tarjeta inválido'), findsOneWidget);

      // Número válido (Luhn algorithm)
      await tester.enterText(cardField, '4532015112830366');
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pump();

      expect(find.text('Número de tarjeta inválido'), findsNothing);
    });

    testWidgets('debe formatear número de tarjeta automáticamente', (tester) async {
      await tester.pumpApp(const PaymentForm());

      await tester.enterText(
        find.byKey(const Key('card_number_field')),
        '4532015112830366',
      );
      await tester.pump();

      // Verificar formato con espacios
      final textField = tester.widget<TextField>(
        find.byKey(const Key('card_number_field')),
      );
      expect(
        textField.controller?.text,
        '4532 0151 1283 0366',
      );
    });

    testWidgets('debe deshabilitar submit mientras procesa', (tester) async {
      final mockBloc = MockPaymentBloc();
      when(() => mockBloc.state).thenReturn(PaymentProcessing());

      await tester.pumpApp(
        BlocProvider<PaymentBloc>.value(
          value: mockBloc,
          child: const PaymentForm(),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byKey(const Key('submit_button')),
      );

      expect(button.onPressed, isNull);
    });
  });
}
```

### 5.6 Finders Personalizados

```dart
// test/helpers/custom_finders.dart

extension CustomFinders on CommonFinders {
  /// Encuentra widgets por su semanticLabel
  Finder bySemanticsLabel(String label) {
    return find.bySemanticsLabel(label);
  }

  /// Encuentra el primer widget de un tipo específico
  Finder firstByType<T extends Widget>() {
    return find.byType(T).first;
  }

  /// Encuentra widgets que contengan texto parcial
  Finder textContaining(String substring) {
    return find.byWidgetPredicate(
      (widget) => widget is Text && widget.data?.contains(substring) == true,
    );
  }

  /// Encuentra widgets por su tooltip
  Finder byTooltip(String tooltip) {
    return find.byWidgetPredicate(
      (widget) => widget is Tooltip && widget.message == tooltip,
    );
  }

  /// Encuentra IconButton con icono específico
  Finder iconButton(IconData icon) {
    return find.byWidgetPredicate(
      (widget) => widget is IconButton && widget.icon is Icon &&
          (widget.icon as Icon).icon == icon,
    );
  }
}

// Uso en tests:
void main() {
  testWidgets('ejemplo de finders personalizados', (tester) async {
    await tester.pumpApp(const MyWidget());

    // Usando finders personalizados
    expect(find.textContaining('Bienvenido'), findsOneWidget);
    expect(find.iconButton(Icons.menu), findsOneWidget);
    expect(find.bySemanticsLabel('Botón de búsqueda'), findsOneWidget);
  });
}
```

---

## 6. Pruebas de Integración y E2E

### 6.1 Configuración de Integration Tests

```yaml
# pubspec.yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  patrol: ^3.6.1
  patrol_cli: ^2.7.0
```

```dart
// integration_test/app_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('flujo completo de login a compra', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Verificar que llegamos al home
      expect(find.byType(HomePage), findsOneWidget);

      // Navegar a productos
      await tester.tap(find.byIcon(Icons.shopping_bag));
      await tester.pumpAndSettle();

      // Seleccionar primer producto
      await tester.tap(find.byType(ProductCard).first);
      await tester.pumpAndSettle();

      // Agregar al carrito
      await tester.tap(find.byKey(const Key('add_to_cart_button')));
      await tester.pumpAndSettle();

      // Verificar snackbar de confirmación
      expect(find.text('Producto agregado al carrito'), findsOneWidget);
    });
  });
}
```

### 6.2 Patrol - Testing E2E Avanzado

Patrol es el framework recomendado para pruebas E2E que requieren interacción con elementos nativos.

```dart
// integration_test/patrol_tests/login_flow_test.dart

import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'Login completo con permisos nativos',
    ($) async {
      await $.pumpWidgetAndSettle(const MyApp());

      // Login
      await $(#email_field).enterText('test@example.com');
      await $(#password_field).enterText('password123');
      await $(#login_button).tap();

      // Manejar permiso de notificaciones (nativo)
      if (await $.native.isPermissionDialogVisible()) {
        await $.native.grantPermissionWhenInUse();
      }

      // Verificar home
      expect($(HomePage), findsOneWidget);

      // Verificar notificación nativa
      await $.native.openNotifications();
      expect(
        await $.native.isNotificationVisible('Bienvenido'),
        isTrue,
      );
    },
  );

  patrolTest(
    'Debe manejar pérdida de conexión',
    ($) async {
      await $.pumpWidgetAndSettle(const MyApp());

      // Simular pérdida de conexión
      await $.native.disableWifi();
      await $.native.disableCellular();

      // Intentar cargar datos
      await $(#refresh_button).tap();
      await $.pumpAndSettle();

      // Verificar mensaje de error
      expect($(#offline_message), findsOneWidget);

      // Restaurar conexión
      await $.native.enableWifi();
    },
  );
}
```

### 6.3 Robot Pattern para E2E

```dart
// integration_test/robots/login_robot.dart

class LoginRobot {
  final PatrolTester $;

  LoginRobot(this.$);

  Future<void> enterEmail(String email) async {
    await $(#email_field).enterText(email);
  }

  Future<void> enterPassword(String password) async {
    await $(#password_field).enterText(password);
  }

  Future<void> tapLoginButton() async {
    await $(#login_button).tap();
    await $.pumpAndSettle();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await enterEmail(email);
    await enterPassword(password);
    await tapLoginButton();
  }

  Future<void> verifyErrorMessage(String message) async {
    expect($(message), findsOneWidget);
  }

  Future<void> verifyLoginSuccess() async {
    expect($(HomePage), findsOneWidget);
  }
}

// integration_test/robots/cart_robot.dart

class CartRobot {
  final PatrolTester $;

  CartRobot(this.$);

  Future<void> addProductToCart(int index) async {
    await $(ProductCard).at(index).tap();
    await $.pumpAndSettle();
    await $(#add_to_cart_button).tap();
    await $.pumpAndSettle();
  }

  Future<void> goToCart() async {
    await $(#cart_icon).tap();
    await $.pumpAndSettle();
  }

  Future<void> verifyCartItemCount(int count) async {
    expect($(CartItem), findsNWidgets(count));
  }

  Future<void> proceedToCheckout() async {
    await $(#checkout_button).tap();
    await $.pumpAndSettle();
  }
}

// Uso de robots en tests
void main() {
  patrolTest('Flujo completo de compra', ($) async {
    await $.pumpWidgetAndSettle(const MyApp());

    final loginRobot = LoginRobot($);
    final cartRobot = CartRobot($);
    final checkoutRobot = CheckoutRobot($);

    // Login
    await loginRobot.login(
      email: 'test@example.com',
      password: 'password123',
    );
    await loginRobot.verifyLoginSuccess();

    // Agregar productos
    await cartRobot.addProductToCart(0);
    await cartRobot.addProductToCart(1);
    await cartRobot.goToCart();
    await cartRobot.verifyCartItemCount(2);

    // Checkout
    await cartRobot.proceedToCheckout();
    await checkoutRobot.fillShippingInfo(
      address: '123 Main St',
      city: 'Ciudad',
    );
    await checkoutRobot.confirmOrder();
    await checkoutRobot.verifyOrderSuccess();
  });
}
```

### 6.4 Configuración para Firebase Test Lab

```yaml
# codemagic.yaml
workflows:
  flutter-integration-tests:
    name: Flutter Integration Tests
    instance_type: mac_mini_m1
    environment:
      flutter: stable
      groups:
        - firebase_credentials
    scripts:
      - name: Build APKs for Firebase Test Lab
        script: |
          cd android
          ./gradlew app:assembleAndroidTest
          ./gradlew app:assembleDebug -Ptarget=integration_test/app_test.dart

      - name: Run tests on Firebase Test Lab
        script: |
          gcloud firebase test android run \
            --type instrumentation \
            --app build/app/outputs/apk/debug/app-debug.apk \
            --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
            --device model=Pixel2,version=30,locale=es,orientation=portrait \
            --device model=Pixel6,version=33,locale=es,orientation=portrait \
            --timeout 5m \
            --results-bucket=gs://my-bucket/test-results
```

---

## 7. Mutation Testing

### 7.1 Conceptos de Mutation Testing

El **Mutation Testing** es una técnica avanzada que evalúa la calidad de las pruebas introduciendo cambios deliberados (mutantes) en el código fuente y verificando si las pruebas existentes los detectan.

```
┌─────────────────────────────────────────────────────────────────┐
│                    PROCESO DE MUTATION TESTING                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   CÓDIGO ORIGINAL         MUTANTE                RESULTADO       │
│   ────────────────        ───────                ─────────       │
│                                                                  │
│   if (a > b)        →     if (a >= b)        →   ¿Test falla?   │
│   return a + b      →     return a - b       →   ¿Test falla?   │
│   while (x < 10)    →     while (x <= 10)    →   ¿Test falla?   │
│   isValid = true    →     isValid = false    →   ¿Test falla?   │
│                                                                  │
│   ┌──────────────────────────────────────────────────────────┐  │
│   │  Mutante KILLED = Test detectó el cambio (BUENO)         │  │
│   │  Mutante SURVIVED = Test NO detectó el cambio (MALO)     │  │
│   └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│   MUTATION SCORE = (Mutantes Killed / Total Mutantes) × 100%    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 7.2 Estado Actual en Dart/Flutter

**Importante**: Actualmente **NO existe** una herramienta automatizada de mutation testing para Dart/Flutter comparable a Stryker (JavaScript) o PITest (Java). Sin embargo, existen alternativas:

#### 7.2.1 Mutation Testing Manual

```dart
// lib/core/utils/calculator.dart - CÓDIGO ORIGINAL
class Calculator {
  int add(int a, int b) => a + b;
  int subtract(int a, int b) => a - b;
  bool isPositive(int n) => n > 0;
  int multiply(int a, int b) => a * b;
}

// MUTACIONES MANUALES PARA EVALUAR TESTS:

// Mutación 1: Cambiar operador aritmético
// int add(int a, int b) => a - b;  // + → -

// Mutación 2: Cambiar operador de comparación
// bool isPositive(int n) => n >= 0;  // > → >=

// Mutación 3: Cambiar constante
// bool isPositive(int n) => n > 1;  // 0 → 1

// Mutación 4: Negar condición
// bool isPositive(int n) => !(n > 0);  // negación
```

#### 7.2.2 Framework de Mutation Testing Personalizado

```dart
// tools/mutation_testing/mutation_runner.dart

import 'dart:io';

/// Tipos de mutaciones soportadas
enum MutationType {
  arithmeticOperator,    // +, -, *, /
  relationalOperator,    // >, <, >=, <=, ==, !=
  logicalOperator,       // &&, ||, !
  conditionalBoundary,   // > → >=, < → <=
  incrementDecrement,    // ++, --
  negation,              // !condition
  returnValue,           // return true → return false
  voidMethodCall,        // eliminar llamada a método void
}

class Mutation {
  final String filePath;
  final int lineNumber;
  final String original;
  final String mutated;
  final MutationType type;

  Mutation({
    required this.filePath,
    required this.lineNumber,
    required this.original,
    required this.mutated,
    required this.type,
  });
}

class MutationResult {
  final Mutation mutation;
  final bool killed;
  final String? failingTest;
  final Duration executionTime;

  MutationResult({
    required this.mutation,
    required this.killed,
    this.failingTest,
    required this.executionTime,
  });
}

class MutationTestRunner {
  final String projectPath;
  final List<String> targetFiles;
  final List<Mutation> _mutations = [];
  final List<MutationResult> _results = [];

  MutationTestRunner({
    required this.projectPath,
    required this.targetFiles,
  });

  /// Genera mutaciones para los archivos objetivo
  Future<void> generateMutations() async {
    for (final file in targetFiles) {
      final content = await File(file).readAsString();
      final lines = content.split('\n');

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        _generateArithmeticMutations(file, i + 1, line);
        _generateRelationalMutations(file, i + 1, line);
        _generateLogicalMutations(file, i + 1, line);
      }
    }

    print('Generated ${_mutations.length} mutations');
  }

  void _generateArithmeticMutations(String file, int lineNum, String line) {
    final operators = {'+': '-', '-': '+', '*': '/', '/': '*'};

    for (final entry in operators.entries) {
      if (line.contains(' ${entry.key} ')) {
        _mutations.add(Mutation(
          filePath: file,
          lineNumber: lineNum,
          original: line,
          mutated: line.replaceFirst(' ${entry.key} ', ' ${entry.value} '),
          type: MutationType.arithmeticOperator,
        ));
      }
    }
  }

  void _generateRelationalMutations(String file, int lineNum, String line) {
    final operators = {
      ' > ': ' >= ',
      ' < ': ' <= ',
      ' >= ': ' > ',
      ' <= ': ' < ',
      ' == ': ' != ',
      ' != ': ' == ',
    };

    for (final entry in operators.entries) {
      if (line.contains(entry.key)) {
        _mutations.add(Mutation(
          filePath: file,
          lineNumber: lineNum,
          original: line,
          mutated: line.replaceFirst(entry.key, entry.value),
          type: MutationType.relationalOperator,
        ));
      }
    }
  }

  void _generateLogicalMutations(String file, int lineNum, String line) {
    final operators = {' && ': ' || ', ' || ': ' && '};

    for (final entry in operators.entries) {
      if (line.contains(entry.key)) {
        _mutations.add(Mutation(
          filePath: file,
          lineNumber: lineNum,
          original: line,
          mutated: line.replaceFirst(entry.key, entry.value),
          type: MutationType.logicalOperator,
        ));
      }
    }
  }

  /// Ejecuta las pruebas con cada mutación
  Future<void> runMutationTests() async {
    for (final mutation in _mutations) {
      final result = await _testMutation(mutation);
      _results.add(result);

      final status = result.killed ? '✓ KILLED' : '✗ SURVIVED';
      print('[$status] ${mutation.filePath}:${mutation.lineNumber}');
    }
  }

  Future<MutationResult> _testMutation(Mutation mutation) async {
    final stopwatch = Stopwatch()..start();

    // Backup del archivo original
    final file = File(mutation.filePath);
    final originalContent = await file.readAsString();

    try {
      // Aplicar mutación
      final lines = originalContent.split('\n');
      lines[mutation.lineNumber - 1] = mutation.mutated;
      await file.writeAsString(lines.join('\n'));

      // Ejecutar tests
      final result = await Process.run(
        'flutter',
        ['test', '--no-pub'],
        workingDirectory: projectPath,
      );

      final killed = result.exitCode != 0;

      return MutationResult(
        mutation: mutation,
        killed: killed,
        failingTest: killed ? _extractFailingTest(result.stdout) : null,
        executionTime: stopwatch.elapsed,
      );
    } finally {
      // Restaurar archivo original
      await file.writeAsString(originalContent);
      stopwatch.stop();
    }
  }

  String? _extractFailingTest(String output) {
    final regex = RegExp(r'FAILED: (.+)');
    final match = regex.firstMatch(output);
    return match?.group(1);
  }

  /// Genera reporte de resultados
  void generateReport() {
    final killed = _results.where((r) => r.killed).length;
    final survived = _results.where((r) => !r.killed).length;
    final total = _results.length;
    final score = total > 0 ? (killed / total * 100).toStringAsFixed(2) : '0';

    print('''
╔══════════════════════════════════════════════════════════════╗
║               MUTATION TESTING REPORT                         ║
╠══════════════════════════════════════════════════════════════╣
║  Total Mutations:     $total
║  Killed:              $killed
║  Survived:            $survived
║  Mutation Score:      $score%
╠══════════════════════════════════════════════════════════════╣
║  SURVIVING MUTATIONS (require better tests):                  ║
╚══════════════════════════════════════════════════════════════╝
''');

    for (final result in _results.where((r) => !r.killed)) {
      print('''
  File: ${result.mutation.filePath}
  Line: ${result.mutation.lineNumber}
  Type: ${result.mutation.type}
  Original: ${result.mutation.original.trim()}
  Mutated:  ${result.mutation.mutated.trim()}
  ---
''');
    }
  }
}

// Uso:
void main() async {
  final runner = MutationTestRunner(
    projectPath: '/path/to/project',
    targetFiles: [
      'lib/core/utils/calculator.dart',
      'lib/features/auth/domain/usecases/login_usecase.dart',
    ],
  );

  await runner.generateMutations();
  await runner.runMutationTests();
  runner.generateReport();
}
```

### 7.3 Integración con CI/CD

```yaml
# .github/workflows/mutation-testing.yml
name: Mutation Testing

on:
  schedule:
    - cron: '0 2 * * 0'  # Domingos a las 2 AM
  workflow_dispatch:

jobs:
  mutation-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Run Mutation Tests
        run: dart run tools/mutation_testing/mutation_runner.dart

      - name: Upload Mutation Report
        uses: actions/upload-artifact@v4
        with:
          name: mutation-report
          path: mutation_report.html

      - name: Check Mutation Score
        run: |
          SCORE=$(cat mutation_score.txt)
          if (( $(echo "$SCORE < 70" | bc -l) )); then
            echo "Mutation score $SCORE% is below threshold of 70%"
            exit 1
          fi
```

### 7.4 Métricas y Umbrales Recomendados

| Métrica | Mínimo Aceptable | Objetivo | Excelente |
|---------|------------------|----------|-----------|
| Mutation Score | 60% | 75% | 85%+ |
| Tiempo de Ejecución | < 30 min | < 15 min | < 5 min |
| Mutantes por Archivo | Todos | Todos | Todos |

---

## 8. Verificación Visual y Comparación con Figma

### 8.1 Golden Tests en Flutter

Los **Golden Tests** (también conocidos como snapshot tests) capturan imágenes de widgets y las comparan contra referencias almacenadas.

```dart
// test/golden/product_card_golden_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('ProductCard Golden Tests', () {
    testGoldens('ProductCard - estado normal', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          Device.phone,
          Device.iphone11,
          Device.tabletPortrait,
        ])
        ..addScenario(
          name: 'default',
          widget: ProductCard(
            product: ProductFactory.create(
              name: 'Producto de Prueba',
              price: 99.99,
            ),
          ),
        )
        ..addScenario(
          name: 'with_discount',
          widget: ProductCard(
            product: ProductFactory.create(
              name: 'Producto con Descuento',
              price: 79.99,
              originalPrice: 99.99,
              hasDiscount: true,
            ),
          ),
        )
        ..addScenario(
          name: 'out_of_stock',
          widget: ProductCard(
            product: ProductFactory.create(
              name: 'Producto Agotado',
              price: 99.99,
              isAvailable: false,
            ),
          ),
        );

      await tester.pumpDeviceBuilder(builder);

      await screenMatchesGolden(tester, 'product_card_scenarios');
    });

    testGoldens('ProductCard - tema oscuro', (tester) async {
      await tester.pumpWidgetBuilder(
        ProductCard(product: ProductFactory.create()),
        wrapper: materialAppWrapper(
          theme: ThemeData.dark(),
        ),
      );

      await screenMatchesGolden(tester, 'product_card_dark_theme');
    });
  });
}
```

### 8.2 Configuración de Golden Toolkit

```dart
// test/flutter_test_config.dart

import 'dart:async';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      // Habilitar comparación en CI
      skipGoldenAssertion: () => !Platform.environment.containsKey('CI'),

      // Tolerancia de diferencia (0.5%)
      fileNameFactory: (name) => 'goldens/$name.png',

      deviceFileNameFactory: (name, device) =>
          'goldens/${name}_${device.name}.png',
    ),
  );
}
```

### 8.3 Widgetbook para Catálogo de Componentes

```dart
// widgetbook/widgetbook.dart

import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'widgetbook.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        // Addon para cambiar temas
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: AppTheme.light),
            WidgetbookTheme(name: 'Dark', data: AppTheme.dark),
          ],
        ),

        // Addon para diferentes dispositivos
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhone13,
            Devices.ios.iPadPro11Inches,
            Devices.android.samsungGalaxyS20,
          ],
        ),

        // Addon para texto escalado
        TextScaleAddon(
          scales: [1.0, 1.5, 2.0],
        ),

        // Addon para localización
        LocalizationAddon(
          locales: [
            const Locale('es'),
            const Locale('en'),
          ],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        ),

        // Addon para accesibilidad
        AccessibilityAddon(),
      ],
    );
  }
}

// widgetbook/components/button_use_case.dart

@widgetbook.UseCase(name: 'Primary', type: AppButton)
Widget primaryButtonUseCase(BuildContext context) {
  return AppButton(
    label: context.knobs.string(
      label: 'Label',
      initialValue: 'Click Me',
    ),
    onPressed: context.knobs.boolean(
      label: 'Enabled',
      initialValue: true,
    )
        ? () {}
        : null,
    isLoading: context.knobs.boolean(
      label: 'Loading',
      initialValue: false,
    ),
    variant: context.knobs.list(
      label: 'Variant',
      options: ButtonVariant.values,
      initialOption: ButtonVariant.primary,
    ),
  );
}
```

### 8.4 Comparación con Diseños de Figma

```dart
// tools/figma_comparison/figma_comparator.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class FigmaComparator {
  final String figmaToken;
  final String fileKey;

  FigmaComparator({
    required this.figmaToken,
    required this.fileKey,
  });

  /// Obtiene imagen de un frame de Figma
  Future<Uint8List> getFigmaImage(String nodeId) async {
    final response = await http.get(
      Uri.parse(
        'https://api.figma.com/v1/images/$fileKey'
        '?ids=$nodeId&format=png&scale=2',
      ),
      headers: {'X-Figma-Token': figmaToken},
    );

    final data = jsonDecode(response.body);
    final imageUrl = data['images'][nodeId];

    final imageResponse = await http.get(Uri.parse(imageUrl));
    return imageResponse.bodyBytes;
  }

  /// Compara imagen de golden test con diseño de Figma
  Future<ComparisonResult> compare({
    required String goldenPath,
    required String figmaNodeId,
    double threshold = 0.01, // 1% de diferencia permitida
  }) async {
    // Obtener imagen de Figma
    final figmaBytes = await getFigmaImage(figmaNodeId);
    final figmaImage = img.decodeImage(figmaBytes)!;

    // Leer golden local
    final goldenBytes = await File(goldenPath).readAsBytes();
    final goldenImage = img.decodeImage(goldenBytes)!;

    // Redimensionar si es necesario
    final resizedFigma = img.copyResize(
      figmaImage,
      width: goldenImage.width,
      height: goldenImage.height,
    );

    // Calcular diferencia pixel por pixel
    int differentPixels = 0;
    final totalPixels = goldenImage.width * goldenImage.height;

    final diffImage = img.Image(
      width: goldenImage.width,
      height: goldenImage.height,
    );

    for (var y = 0; y < goldenImage.height; y++) {
      for (var x = 0; x < goldenImage.width; x++) {
        final goldenPixel = goldenImage.getPixel(x, y);
        final figmaPixel = resizedFigma.getPixel(x, y);

        if (!_pixelsMatch(goldenPixel, figmaPixel)) {
          differentPixels++;
          // Marcar diferencia en rojo
          diffImage.setPixel(x, y, img.ColorRgba8(255, 0, 0, 128));
        } else {
          diffImage.setPixel(x, y, goldenPixel);
        }
      }
    }

    final diffPercentage = differentPixels / totalPixels;
    final passed = diffPercentage <= threshold;

    // Guardar imagen de diferencias
    final diffPath = goldenPath.replaceAll('.png', '_diff.png');
    await File(diffPath).writeAsBytes(img.encodePng(diffImage));

    return ComparisonResult(
      passed: passed,
      differencePercentage: diffPercentage * 100,
      diffImagePath: diffPath,
      goldenPath: goldenPath,
      figmaNodeId: figmaNodeId,
    );
  }

  bool _pixelsMatch(img.Pixel a, img.Pixel b, {int tolerance = 5}) {
    return (a.r - b.r).abs() <= tolerance &&
        (a.g - b.g).abs() <= tolerance &&
        (a.b - b.b).abs() <= tolerance;
  }
}

class ComparisonResult {
  final bool passed;
  final double differencePercentage;
  final String diffImagePath;
  final String goldenPath;
  final String figmaNodeId;

  ComparisonResult({
    required this.passed,
    required this.differencePercentage,
    required this.diffImagePath,
    required this.goldenPath,
    required this.figmaNodeId,
  });
}

// Configuración de componentes a comparar
// figma_comparison_config.yaml
/*
comparisons:
  - name: "ProductCard"
    golden_path: "test/golden/product_card.png"
    figma_node_id: "1234:5678"
    threshold: 0.02

  - name: "LoginPage"
    golden_path: "test/golden/login_page.png"
    figma_node_id: "1234:9012"
    threshold: 0.01

  - name: "NavigationBar"
    golden_path: "test/golden/navigation_bar.png"
    figma_node_id: "1234:3456"
    threshold: 0.005
*/
```

### 8.5 Widgetbook Cloud para Revisiones de Diseño

```yaml
# .github/workflows/widgetbook-cloud.yml
name: Widgetbook Cloud

on:
  pull_request:
    paths:
      - 'lib/presentation/widgets/**'
      - 'widgetbook/**'

jobs:
  widgetbook-cloud:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'

      - name: Install dependencies
        run: |
          flutter pub get
          cd widgetbook && flutter pub get

      - name: Build Widgetbook
        run: |
          cd widgetbook
          flutter build web --release

      - name: Upload to Widgetbook Cloud
        uses: widgetbook/widgetbook-hosting@v1
        with:
          api-key: ${{ secrets.WIDGETBOOK_API_KEY }}
          path: widgetbook/build/web

      - name: Run Visual Reviews
        run: |
          widgetbook-cli review \
            --api-key ${{ secrets.WIDGETBOOK_API_KEY }} \
            --branch ${{ github.head_ref }}
```

---

## 9. CI/CD y Granjas de Pruebas

### 9.1 Arquitectura de CI/CD para Flutter

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    PIPELINE DE CI/CD PARA FLUTTER                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌───────────┐  │
│  │  COMMIT │ → │ ANÁLISIS │ → │  TESTS   │ → │  BUILD   │ → │  DEPLOY   │  │
│  └─────────┘   │ ESTÁTICO │   │          │   │          │   └───────────┘  │
│                └──────────┘   └──────────┘   └──────────┘                   │
│                     │              │              │                          │
│                     ▼              ▼              ▼                          │
│              ┌───────────┐  ┌───────────┐  ┌───────────┐                    │
│              │ • Lint    │  │ • Unit    │  │ • APK     │                    │
│              │ • Analyze │  │ • Widget  │  │ • IPA     │                    │
│              │ • Format  │  │ • Golden  │  │ • Web     │                    │
│              │ • Secrets │  │ • E2E     │  │ • Desktop │                    │
│              └───────────┘  └───────────┘  └───────────┘                    │
│                                  │                                           │
│                                  ▼                                           │
│                        ┌─────────────────┐                                  │
│                        │  DEVICE FARMS   │                                  │
│                        │ • Firebase TL   │                                  │
│                        │ • emulator.wtf  │                                  │
│                        │ • AWS Device F  │                                  │
│                        └─────────────────┘                                  │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 9.2 Configuración Completa de GitHub Actions

```yaml
# .github/workflows/ci.yml
name: Flutter CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
  schedule:
    - cron: '0 6 * * *'  # Nightly builds

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

env:
  FLUTTER_VERSION: '3.24.0'
  JAVA_VERSION: '17'

jobs:
  # ============================================
  # ANÁLISIS ESTÁTICO
  # ============================================
  analyze:
    name: Static Analysis
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Check formatting
        run: dart format --set-exit-if-changed .

      - name: Analyze code
        run: flutter analyze --fatal-infos

      - name: Check for unused dependencies
        run: |
          dart pub global activate dependency_validator
          dart pub global run dependency_validator

      - name: Security audit
        run: |
          dart pub global activate pana
          dart pub global run pana --no-warning

  # ============================================
  # PRUEBAS UNITARIAS Y DE WIDGETS
  # ============================================
  unit-tests:
    name: Unit & Widget Tests
    runs-on: ubuntu-latest
    needs: analyze
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Generate mocks
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Run tests with coverage
        run: |
          flutter test \
            --coverage \
            --test-randomize-ordering-seed random \
            --reporter expanded

      - name: Check coverage threshold
        run: |
          dart pub global activate coverage
          dart pub global run coverage:format_coverage \
            --lcov \
            --in=coverage \
            --out=coverage/lcov.info \
            --report-on=lib

          # Verificar umbral de cobertura
          COVERAGE=$(lcov --summary coverage/lcov.info | grep "lines" | cut -d ' ' -f 4 | cut -d '%' -f 1)
          echo "Coverage: $COVERAGE%"
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "Coverage $COVERAGE% is below 80% threshold"
            exit 1
          fi

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v4
        with:
          files: coverage/lcov.info
          fail_ci_if_error: true
          token: ${{ secrets.CODECOV_TOKEN }}

      - name: Upload coverage artifact
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/

  # ============================================
  # GOLDEN TESTS
  # ============================================
  golden-tests:
    name: Golden Tests
    runs-on: macos-latest  # Necesario para consistencia de renderizado
    needs: analyze
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Run golden tests
        run: flutter test --tags=golden --update-goldens=false

      - name: Upload golden failures
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: golden-failures
          path: |
            **/failures/**

  # ============================================
  # BUILD ANDROID
  # ============================================
  build-android:
    name: Build Android
    runs-on: ubuntu-latest
    needs: [unit-tests]
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: ${{ env.JAVA_VERSION }}

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Build APK (Debug)
        run: flutter build apk --debug

      - name: Build APK (Release)
        run: flutter build apk --release

      - name: Build App Bundle
        run: flutter build appbundle --release

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: android-apk
          path: |
            build/app/outputs/apk/debug/app-debug.apk
            build/app/outputs/apk/release/app-release.apk

      - name: Upload App Bundle
        uses: actions/upload-artifact@v4
        with:
          name: android-bundle
          path: build/app/outputs/bundle/release/app-release.aab

  # ============================================
  # BUILD iOS
  # ============================================
  build-ios:
    name: Build iOS
    runs-on: macos-latest
    needs: [unit-tests]
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Build iOS (No codesign)
        run: flutter build ios --release --no-codesign

      - name: Upload iOS build
        uses: actions/upload-artifact@v4
        with:
          name: ios-build
          path: build/ios/iphoneos/

  # ============================================
  # INTEGRATION TESTS - ANDROID
  # ============================================
  integration-tests-android:
    name: Integration Tests (Android)
    runs-on: ubuntu-latest
    needs: build-android
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: ${{ env.JAVA_VERSION }}

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true

      - name: Download APK
        uses: actions/download-artifact@v4
        with:
          name: android-apk
          path: build/app/outputs/apk/

      - name: Build integration test APK
        run: |
          cd android
          ./gradlew app:assembleAndroidTest
          ./gradlew app:assembleDebug -Ptarget=integration_test/app_test.dart

      - name: Authenticate to Google Cloud
        uses: google-github-actions/auth@v2
        with:
          credentials_json: ${{ secrets.GCP_SA_KEY }}

      - name: Setup Google Cloud SDK
        uses: google-github-actions/setup-gcloud@v2

      - name: Run tests on Firebase Test Lab
        run: |
          gcloud firebase test android run \
            --type instrumentation \
            --app build/app/outputs/apk/debug/app-debug.apk \
            --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
            --device model=Pixel6,version=33,locale=es,orientation=portrait \
            --device model=Pixel4,version=30,locale=es,orientation=portrait \
            --timeout 10m \
            --results-dir=firebase-results \
            --results-bucket=${{ secrets.GCS_BUCKET }}

      - name: Download test results
        if: always()
        run: |
          gsutil -m cp -r gs://${{ secrets.GCS_BUCKET }}/firebase-results ./

      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: firebase-test-results
          path: firebase-results/

  # ============================================
  # SONARQUBE ANALYSIS
  # ============================================
  sonarqube:
    name: SonarQube Analysis
    runs-on: ubuntu-latest
    needs: unit-tests
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true

      - name: Download coverage
        uses: actions/download-artifact@v4
        with:
          name: coverage-report
          path: coverage/

      - name: SonarQube Scan
        uses: SonarSource/sonarqube-scan-action@master
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
        with:
          args: >
            -Dsonar.projectKey=my-flutter-app
            -Dsonar.sources=lib
            -Dsonar.tests=test
            -Dsonar.dart.lcov.reportPaths=coverage/lcov.info

      - name: SonarQube Quality Gate
        uses: SonarSource/sonarqube-quality-gate-action@master
        timeout-minutes: 5
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}

  # ============================================
  # DEPLOY TO STORES
  # ============================================
  deploy-android:
    name: Deploy to Play Store
    runs-on: ubuntu-latest
    needs: [integration-tests-android, sonarqube]
    if: github.ref == 'refs/heads/main'
    environment: production
    steps:
      - uses: actions/checkout@v4

      - name: Download App Bundle
        uses: actions/download-artifact@v4
        with:
          name: android-bundle
          path: build/

      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.PLAY_STORE_SERVICE_ACCOUNT }}
          packageName: com.example.myapp
          releaseFiles: build/app-release.aab
          track: internal
          status: completed
```

### 9.3 Configuración de Codemagic

```yaml
# codemagic.yaml
workflows:
  flutter-workflow:
    name: Flutter CI/CD
    instance_type: mac_mini_m1
    max_build_duration: 60

    environment:
      flutter: 3.24.0
      xcode: latest
      cocoapods: default
      groups:
        - app_store_credentials
        - firebase_credentials
        - signing_credentials
      vars:
        BUNDLE_ID: "com.example.myapp"

    triggering:
      events:
        - push
        - pull_request
      branch_patterns:
        - pattern: 'main'
          include: true
        - pattern: 'develop'
          include: true
        - pattern: 'feature/*'
          include: true

    scripts:
      # Preparación
      - name: Get Flutter dependencies
        script: flutter pub get

      - name: Generate code
        script: dart run build_runner build --delete-conflicting-outputs

      # Análisis
      - name: Static analysis
        script: |
          flutter analyze
          dart format --set-exit-if-changed .

      # Tests
      - name: Run unit tests
        script: |
          flutter test --coverage

      - name: Run golden tests
        script: flutter test --tags=golden

      # Build iOS
      - name: Build iOS
        script: |
          flutter build ios --release --no-codesign
          cd ios
          pod install
          xcodebuild -workspace Runner.xcworkspace \
            -scheme Runner \
            -sdk iphoneos \
            -configuration Release \
            -archivePath $CM_BUILD_DIR/build/ios/Runner.xcarchive \
            archive

      - name: Export IPA
        script: |
          xcodebuild -exportArchive \
            -archivePath $CM_BUILD_DIR/build/ios/Runner.xcarchive \
            -exportOptionsPlist ios/ExportOptions.plist \
            -exportPath $CM_BUILD_DIR/build/ios/ipa

      # Build Android
      - name: Build Android APK
        script: flutter build apk --release

      - name: Build Android App Bundle
        script: flutter build appbundle --release

      # Integration Tests en Firebase Test Lab
      - name: Build integration test APK
        script: |
          cd android
          ./gradlew app:assembleAndroidTest
          ./gradlew app:assembleDebug -Ptarget=integration_test/app_test.dart

      - name: Run Firebase Test Lab
        script: |
          gcloud auth activate-service-account --key-file=$GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
          gcloud config set project $FIREBASE_PROJECT_ID

          gcloud firebase test android run \
            --type instrumentation \
            --app build/app/outputs/apk/debug/app-debug.apk \
            --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
            --device model=Pixel6,version=33 \
            --device model=Pixel4a,version=30 \
            --timeout 15m \
            --results-dir=firebase-test-results

    artifacts:
      - build/**/outputs/**/*.apk
      - build/**/outputs/**/*.aab
      - build/ios/ipa/*.ipa
      - coverage/lcov.info
      - firebase-test-results/**

    publishing:
      email:
        recipients:
          - team@example.com
        notify:
          success: true
          failure: true

      google_play:
        credentials: $GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
        track: internal
        submit_as_draft: true

      app_store_connect:
        api_key: $APP_STORE_CONNECT_API_KEY
        key_id: $APP_STORE_KEY_ID
        issuer_id: $APP_STORE_ISSUER_ID
        submit_to_testflight: true
```

### 9.4 Granjas de Dispositivos

#### 9.4.1 Firebase Test Lab

```dart
// tools/firebase_test_lab/test_matrix.dart

class FirebaseTestMatrix {
  static const List<DeviceConfig> androidDevices = [
    DeviceConfig(
      model: 'Pixel6',
      version: '33',
      locale: 'es',
      orientation: 'portrait',
    ),
    DeviceConfig(
      model: 'Pixel4',
      version: '30',
      locale: 'es',
      orientation: 'portrait',
    ),
    DeviceConfig(
      model: 'samsungs21',
      version: '31',
      locale: 'es',
      orientation: 'portrait',
    ),
    DeviceConfig(
      model: 'redfin', // Pixel 5
      version: '30',
      locale: 'en',
      orientation: 'landscape',
    ),
  ];

  static const List<DeviceConfig> iosDevices = [
    DeviceConfig(
      model: 'iphone13pro',
      version: '15.7',
      locale: 'es',
      orientation: 'portrait',
    ),
    DeviceConfig(
      model: 'iphone14',
      version: '16.6',
      locale: 'es',
      orientation: 'portrait',
    ),
    DeviceConfig(
      model: 'ipadpro129',
      version: '16.6',
      locale: 'es',
      orientation: 'landscape',
    ),
  ];

  static String generateGcloudCommand({
    required String appPath,
    required String testPath,
    required List<DeviceConfig> devices,
    Duration timeout = const Duration(minutes: 15),
  }) {
    final deviceArgs = devices
        .map((d) => '--device model=${d.model},version=${d.version},'
            'locale=${d.locale},orientation=${d.orientation}')
        .join(' ');

    return '''
gcloud firebase test android run \\
  --type instrumentation \\
  --app $appPath \\
  --test $testPath \\
  $deviceArgs \\
  --timeout ${timeout.inMinutes}m \\
  --results-bucket=gs://my-test-results \\
  --results-dir=\$(date +%Y%m%d_%H%M%S)
''';
  }
}

class DeviceConfig {
  final String model;
  final String version;
  final String locale;
  final String orientation;

  const DeviceConfig({
    required this.model,
    required this.version,
    required this.locale,
    required this.orientation,
  });
}
```

#### 9.4.2 emulator.wtf (Alternativa más Rápida)

```yaml
# .github/workflows/emulator-wtf.yml
name: Integration Tests (emulator.wtf)

on:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'

      - name: Build test APKs
        run: |
          flutter build apk --debug
          cd android
          ./gradlew app:assembleAndroidTest
          ./gradlew app:assembleDebug -Ptarget=integration_test/app_test.dart

      - name: Run tests on emulator.wtf
        uses: nicholasruunu/emulator-wtf-action@v0
        with:
          api-token: ${{ secrets.EMULATOR_WTF_TOKEN }}
          app: build/app/outputs/apk/debug/app-debug.apk
          test: build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk
          devices: |
            model=Pixel6,version=33
            model=Pixel4a,version=30
          outputs-dir: test-results
          timeout: 15m
          num-shards: 4  # Paralelización

      - name: Upload results
        uses: actions/upload-artifact@v4
        with:
          name: emulator-wtf-results
          path: test-results/
```

### 9.5 Quality Gates y Métricas

```yaml
# quality-gates.yaml
quality_gates:
  # Cobertura de código
  coverage:
    lines:
      minimum: 80
      target: 90
    branches:
      minimum: 75
      target: 85
    functions:
      minimum: 85
      target: 95

  # Análisis estático
  static_analysis:
    errors: 0
    warnings: 0
    infos: allowed  # Permitir infos pero revisar

  # Complejidad
  complexity:
    cyclomatic:
      max_per_method: 10
      max_per_class: 50
    cognitive:
      max_per_method: 15

  # Duplicación
  duplication:
    max_percentage: 3
    min_tokens: 100

  # Tests
  tests:
    unit:
      passing_rate: 100
      min_count: 50
    widget:
      passing_rate: 100
      min_count: 30
    integration:
      passing_rate: 100
      min_count: 10
    golden:
      passing_rate: 100
      max_diff: 0.1%

  # Performance
  performance:
    build_time:
      android_max: 10m
      ios_max: 15m
    test_time:
      unit_max: 2m
      widget_max: 5m
      integration_max: 15m

  # Seguridad
  security:
    high_vulnerabilities: 0
    medium_vulnerabilities: 0
    secrets_in_code: 0
```

---

## 10. Detección de Errores y Flujo de Análisis

### 10.1 Arquitectura de Error Tracking

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    FLUJO DE DETECCIÓN Y ANÁLISIS DE ERRORES                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐                   │
│   │   ERROR     │ ──► │  CAPTURA    │ ──► │  ANÁLISIS   │                   │
│   │   ORIGEN    │     │             │     │             │                   │
│   └─────────────┘     └─────────────┘     └─────────────┘                   │
│         │                   │                   │                            │
│         ▼                   ▼                   ▼                            │
│   ┌───────────┐       ┌───────────┐       ┌───────────┐                     │
│   │• Runtime  │       │• Sentry   │       │• Stack    │                     │
│   │• Flutter  │       │• Crashly. │       │• Context  │                     │
│   │• Dart     │       │• DataDog  │       │• Breadcr. │                     │
│   │• Platform │       │           │       │           │                     │
│   └───────────┘       └───────────┘       └───────────┘                     │
│                                                 │                            │
│                                                 ▼                            │
│                            ┌─────────────────────────────────┐              │
│                            │        CLASIFICACIÓN            │              │
│                            │  • Severidad (Critical/High/..) │              │
│                            │  • Frecuencia                   │              │
│                            │  • Impacto en usuarios          │              │
│                            │  • Reproducibilidad             │              │
│                            └─────────────────────────────────┘              │
│                                                 │                            │
│                                                 ▼                            │
│                            ┌─────────────────────────────────┐              │
│                            │         ACCIÓN                  │              │
│                            │  • Notificación automática      │              │
│                            │  • Ticket automático (Jira)     │              │
│                            │  • Análisis de causa raíz       │              │
│                            └─────────────────────────────────┘              │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 10.2 Configuración de Sentry para Flutter

```dart
// lib/core/error_tracking/sentry_service.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryService {
  static Future<void> initialize({
    required String dsn,
    required String environment,
    required String release,
  }) async {
    await SentryFlutter.init(
      (options) {
        options.dsn = dsn;
        options.environment = environment;
        options.release = release;

        // Configuración de performance
        options.tracesSampleRate = 0.3; // 30% de transacciones
        options.profilesSampleRate = 0.1; // 10% de perfiles

        // Configuración de sesiones
        options.enableAutoSessionTracking = true;
        options.sessionTrackingIntervalMillis = 30000;

        // Filtros de eventos
        options.beforeSend = _beforeSend;
        options.beforeBreadcrumb = _beforeBreadcrumb;

        // Habilitar captura de screenshots
        options.attachScreenshot = true;
        options.attachViewHierarchy = true;

        // Debug solo en desarrollo
        options.debug = kDebugMode;
      },
      appRunner: () => runApp(const MyApp()),
    );
  }

  static FutureOr<SentryEvent?> _beforeSend(
    SentryEvent event,
    Hint hint,
  ) {
    // Filtrar errores no importantes
    if (_shouldIgnoreError(event)) {
      return null;
    }

    // Enriquecer con información adicional
    return event.copyWith(
      tags: {
        ...event.tags ?? {},
        'app_state': AppStateManager.currentState,
        'user_type': UserManager.currentUserType,
      },
      extra: {
        ...event.extra ?? {},
        'device_info': DeviceInfoService.getInfo(),
        'last_screens': NavigationService.lastScreens,
      },
    );
  }

  static Breadcrumb? _beforeBreadcrumb(
    Breadcrumb? breadcrumb,
    Hint hint,
  ) {
    // Filtrar breadcrumbs sensibles
    if (breadcrumb?.message?.contains('password') ?? false) {
      return null;
    }
    return breadcrumb;
  }

  static bool _shouldIgnoreError(SentryEvent event) {
    final message = event.throwable?.toString() ?? '';

    // Errores de red comunes que no necesitan tracking
    final ignoredPatterns = [
      'SocketException',
      'Connection refused',
      'Network is unreachable',
      'HandshakeException',
    ];

    return ignoredPatterns.any(message.contains);
  }

  /// Captura excepción con contexto adicional
  static Future<void> captureException(
    dynamic exception, {
    dynamic stackTrace,
    Map<String, dynamic>? extras,
    Map<String, String>? tags,
    SentryLevel level = SentryLevel.error,
  }) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.level = level;
        extras?.forEach((key, value) => scope.setExtra(key, value));
        tags?.forEach((key, value) => scope.setTag(key, value));
      },
    );
  }

  /// Agrega breadcrumb personalizado
  static void addBreadcrumb({
    required String message,
    required String category,
    Map<String, dynamic>? data,
    SentryLevel level = SentryLevel.info,
  }) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        data: data,
        level: level,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Inicia una transacción de performance
  static ISentrySpan startTransaction({
    required String name,
    required String operation,
  }) {
    return Sentry.startTransaction(
      name,
      operation,
      bindToScope: true,
    );
  }
}

// lib/core/error_tracking/error_handler.dart

class GlobalErrorHandler {
  static void initialize() {
    // Errores de Flutter
    FlutterError.onError = (details) {
      FlutterError.presentError(details);

      SentryService.captureException(
        details.exception,
        stackTrace: details.stack,
        extras: {
          'library': details.library,
          'context': details.context?.toString(),
          'informationCollector': details.informationCollector?.call()
              .map((e) => e.toString())
              .toList(),
        },
        level: _getSentryLevel(details),
      );
    };

    // Errores de Dart no capturados
    PlatformDispatcher.instance.onError = (error, stack) {
      SentryService.captureException(
        error,
        stackTrace: stack,
        tags: {'error_type': 'platform_dispatcher'},
      );
      return true;
    };

    // Errores de Zone
    runZonedGuarded(
      () => runApp(const MyApp()),
      (error, stackTrace) {
        SentryService.captureException(
          error,
          stackTrace: stackTrace,
          tags: {'error_type': 'zone_guarded'},
        );
      },
    );
  }

  static SentryLevel _getSentryLevel(FlutterErrorDetails details) {
    if (details.silent) return SentryLevel.info;
    if (details.library == 'rendering library') return SentryLevel.warning;
    return SentryLevel.error;
  }
}
```

### 10.3 Análisis de Stack Traces Asíncronos

```dart
// lib/core/error_tracking/async_error_chain.dart

import 'package:error_trace/error_trace.dart';

/// Wrapper para preservar stack traces en código asíncrono
class AsyncErrorChain {
  /// Ejecuta una operación async preservando el stack trace completo
  static Future<T> run<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      // Crear error encadenado con contexto completo
      throw ChainedError(
        error,
        stackTrace,
        message: 'Error en operación asíncrona',
      );
    }
  }

  /// Ejecuta múltiples operaciones async con tracking individual
  static Future<List<T>> runAll<T>(
    List<Future<T> Function()> operations, {
    bool stopOnError = false,
  }) async {
    final results = <T>[];
    final errors = <ChainedError>[];

    for (var i = 0; i < operations.length; i++) {
      try {
        results.add(await run(operations[i]));
      } catch (error) {
        if (error is ChainedError) {
          errors.add(error.copyWith(
            message: 'Error en operación $i: ${error.message}',
          ));
        }
        if (stopOnError) rethrow;
      }
    }

    if (errors.isNotEmpty) {
      throw AggregateError(errors);
    }

    return results;
  }
}

/// Error encadenado que preserva el contexto original
class ChainedError implements Exception {
  final dynamic originalError;
  final StackTrace originalStackTrace;
  final String message;
  final StackTrace chainedStackTrace;
  final DateTime timestamp;
  final Map<String, dynamic> context;

  ChainedError(
    this.originalError,
    this.originalStackTrace, {
    required this.message,
    Map<String, dynamic>? context,
  })  : chainedStackTrace = StackTrace.current,
        timestamp = DateTime.now(),
        context = context ?? {};

  ChainedError copyWith({String? message, Map<String, dynamic>? context}) {
    return ChainedError(
      originalError,
      originalStackTrace,
      message: message ?? this.message,
      context: {...this.context, ...?context},
    );
  }

  @override
  String toString() {
    return '''
ChainedError: $message
Original Error: $originalError
Timestamp: $timestamp
Context: $context

Original Stack Trace:
$originalStackTrace

Chained at:
$chainedStackTrace
''';
  }
}
```

### 10.4 Sistema de Logging Estructurado

```dart
// lib/core/logging/structured_logger.dart

import 'dart:convert';
import 'package:logger/logger.dart';

enum LogCategory {
  network,
  database,
  ui,
  navigation,
  authentication,
  payment,
  analytics,
  performance,
  error,
}

class StructuredLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
    filter: ProductionFilter(),
  );

  static void log({
    required Level level,
    required LogCategory category,
    required String message,
    Map<String, dynamic>? data,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final logEntry = LogEntry(
      level: level,
      category: category,
      message: message,
      data: data,
      error: error,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      sessionId: SessionManager.currentSessionId,
      userId: UserManager.currentUserId,
    );

    // Log local
    _logLocally(logEntry);

    // Enviar a servicio remoto si es necesario
    if (level.index >= Level.warning.index) {
      _sendToRemote(logEntry);
    }

    // Agregar breadcrumb a Sentry
    SentryService.addBreadcrumb(
      message: message,
      category: category.name,
      data: data,
      level: _toSentryLevel(level),
    );
  }

  static void _logLocally(LogEntry entry) {
    switch (entry.level) {
      case Level.trace:
        _logger.t(entry.toJson());
        break;
      case Level.debug:
        _logger.d(entry.toJson());
        break;
      case Level.info:
        _logger.i(entry.toJson());
        break;
      case Level.warning:
        _logger.w(entry.toJson());
        break;
      case Level.error:
        _logger.e(entry.toJson(), error: entry.error, stackTrace: entry.stackTrace);
        break;
      case Level.fatal:
        _logger.f(entry.toJson(), error: entry.error, stackTrace: entry.stackTrace);
        break;
      default:
        _logger.d(entry.toJson());
    }
  }

  static Future<void> _sendToRemote(LogEntry entry) async {
    // Enviar a servicio de logging remoto (ej: Datadog, CloudWatch)
    try {
      await RemoteLoggingService.send(entry);
    } catch (e) {
      // No fallar si el logging remoto falla
      _logger.w('Failed to send log to remote: $e');
    }
  }

  static SentryLevel _toSentryLevel(Level level) {
    switch (level) {
      case Level.trace:
      case Level.debug:
        return SentryLevel.debug;
      case Level.info:
        return SentryLevel.info;
      case Level.warning:
        return SentryLevel.warning;
      case Level.error:
        return SentryLevel.error;
      case Level.fatal:
        return SentryLevel.fatal;
      default:
        return SentryLevel.info;
    }
  }

  // Métodos de conveniencia
  static void debug(String message, {LogCategory? category, Map<String, dynamic>? data}) {
    log(level: Level.debug, category: category ?? LogCategory.ui, message: message, data: data);
  }

  static void info(String message, {LogCategory? category, Map<String, dynamic>? data}) {
    log(level: Level.info, category: category ?? LogCategory.ui, message: message, data: data);
  }

  static void warning(String message, {LogCategory? category, Map<String, dynamic>? data}) {
    log(level: Level.warning, category: category ?? LogCategory.ui, message: message, data: data);
  }

  static void error(String message, {LogCategory? category, Map<String, dynamic>? data, dynamic error, StackTrace? stackTrace}) {
    log(level: Level.error, category: category ?? LogCategory.error, message: message, data: data, error: error, stackTrace: stackTrace);
  }
}

class LogEntry {
  final Level level;
  final LogCategory category;
  final String message;
  final Map<String, dynamic>? data;
  final dynamic error;
  final StackTrace? stackTrace;
  final DateTime timestamp;
  final String? sessionId;
  final String? userId;

  LogEntry({
    required this.level,
    required this.category,
    required this.message,
    this.data,
    this.error,
    this.stackTrace,
    required this.timestamp,
    this.sessionId,
    this.userId,
  });

  Map<String, dynamic> toJson() => {
    'level': level.name,
    'category': category.name,
    'message': message,
    'data': data,
    'error': error?.toString(),
    'timestamp': timestamp.toIso8601String(),
    'sessionId': sessionId,
    'userId': userId,
  };
}
```

---

## 11. Inteligencia Artificial en Testing

### 11.1 Panorama de Herramientas IA para Testing

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    IA EN TESTING - CAPACIDADES Y HERRAMIENTAS                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                     GENERACIÓN DE TESTS                              │   │
│   │  • GitHub Copilot: Autocompletado de tests                          │   │
│   │  • Tabnine: Sugerencias basadas en contexto                         │   │
│   │  • Codium AI: Generación de tests específicos                       │   │
│   │  • Amazon CodeWhisperer: Tests para AWS integrations                │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                     ANÁLISIS DE CÓDIGO                               │   │
│   │  • SonarQube + AI: Detección de code smells y bugs                  │   │
│   │  • DeepCode (Snyk): Análisis semántico de vulnerabilidades          │   │
│   │  • CodeClimate: Métricas y deuda técnica                            │   │
│   │  • Sourcery: Refactoring automático                                 │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                     TESTING VISUAL                                   │   │
│   │  • Applitools: Visual AI para regresiones                           │   │
│   │  • Percy: Comparación visual inteligente                            │   │
│   │  • Chromatic: Storybook visual testing                              │   │
│   │  • Widgetbook Cloud: Review de UI Flutter                           │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                     SELF-HEALING TESTS                               │   │
│   │  • Testim: Auto-corrección de selectores                            │   │
│   │  • mabl: Adaptación automática a cambios UI                         │   │
│   │  • Functionize: ML para mantenimiento de tests                      │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 11.2 Generación Automática de Tests con IA

```dart
// tools/ai_testing/test_generator.dart

import 'dart:io';
import 'package:http/http.dart' as http;

/// Generador de tests usando OpenAI/Claude API
class AITestGenerator {
  final String apiKey;
  final String model;

  AITestGenerator({
    required this.apiKey,
    this.model = 'gpt-4',
  });

  /// Genera tests unitarios para una clase dada
  Future<String> generateUnitTests({
    required String sourceCode,
    required String className,
    String? additionalContext,
  }) async {
    final prompt = '''
Eres un experto en testing de Flutter/Dart. Genera tests unitarios completos
para la siguiente clase, siguiendo estas reglas:

1. Usa el patrón AAA (Arrange-Act-Assert)
2. Cubre casos positivos, negativos y edge cases
3. Usa mocktail para mocks
4. Nombra los tests descriptivamente en español
5. Agrupa tests relacionados con group()
6. Incluye tests para manejo de errores

Clase a testear:
```dart
$sourceCode
```

${additionalContext != null ? 'Contexto adicional: $additionalContext' : ''}

Genera el archivo de test completo:
''';

    return await _callAI(prompt);
  }

  /// Genera tests de widget
  Future<String> generateWidgetTests({
    required String widgetCode,
    required String widgetName,
  }) async {
    final prompt = '''
Genera tests de widget para Flutter siguiendo estas pautas:

1. Usa testWidgets con descripción clara
2. Verifica renderizado correcto de elementos
3. Prueba interacciones (tap, scroll, input)
4. Verifica estados diferentes del widget
5. Usa find.byKey, find.byType, find.text apropiadamente
6. Incluye tests de accesibilidad (semantics)

Widget a testear:
```dart
$widgetCode
```

Genera tests completos para $widgetName:
''';

    return await _callAI(prompt);
  }

  /// Analiza código y sugiere tests faltantes
  Future<TestCoverageAnalysis> analyzeTestGaps({
    required String sourceCode,
    required String existingTests,
  }) async {
    final prompt = '''
Analiza el siguiente código fuente y los tests existentes.
Identifica:
1. Funciones/métodos sin tests
2. Branches no cubiertas
3. Edge cases no probados
4. Escenarios de error no cubiertos

Código fuente:
```dart
$sourceCode
```

Tests existentes:
```dart
$existingTests
```

Responde en formato JSON:
{
  "uncovered_functions": ["lista de funciones sin test"],
  "missing_edge_cases": ["descripción de edge cases"],
  "missing_error_scenarios": ["escenarios de error"],
  "suggested_tests": ["descripción de tests sugeridos"],
  "coverage_estimate": 75
}
''';

    final response = await _callAI(prompt);
    return TestCoverageAnalysis.fromJson(jsonDecode(response));
  }

  Future<String> _callAI(String prompt) async {
    // Implementación para OpenAI
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'temperature': 0.3,
        'max_tokens': 4000,
      }),
    );

    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'];
  }
}

class TestCoverageAnalysis {
  final List<String> uncoveredFunctions;
  final List<String> missingEdgeCases;
  final List<String> missingErrorScenarios;
  final List<String> suggestedTests;
  final int coverageEstimate;

  TestCoverageAnalysis({
    required this.uncoveredFunctions,
    required this.missingEdgeCases,
    required this.missingErrorScenarios,
    required this.suggestedTests,
    required this.coverageEstimate,
  });

  factory TestCoverageAnalysis.fromJson(Map<String, dynamic> json) {
    return TestCoverageAnalysis(
      uncoveredFunctions: List<String>.from(json['uncovered_functions']),
      missingEdgeCases: List<String>.from(json['missing_edge_cases']),
      missingErrorScenarios: List<String>.from(json['missing_error_scenarios']),
      suggestedTests: List<String>.from(json['suggested_tests']),
      coverageEstimate: json['coverage_estimate'],
    );
  }
}
```

### 11.3 Detección de Bugs con ML

```dart
// tools/ai_testing/bug_detector.dart

/// Detector de patrones de bugs usando análisis estático + ML
class AIBugDetector {
  /// Patrones de bugs comunes en Flutter/Dart
  static const bugPatterns = {
    'null_safety': [
      RegExp(r'!\s*[^!]'),  // Force unwrap
      RegExp(r'\?\.\s*\w+\s*!'),  // Optional chain then force unwrap
    ],
    'memory_leak': [
      RegExp(r'addListener\('),  // Sin removeListener correspondiente
      RegExp(r'StreamSubscription<'),  // Sin cancel
      RegExp(r'Timer\.periodic'),  // Sin cancel
    ],
    'async_issues': [
      RegExp(r'setState\(\s*\(\)\s*async'),  // async en setState
      RegExp(r'build\([^)]*\)\s*async'),  // build method async
    ],
    'performance': [
      RegExp(r'ListView\('),  // Sin builder para listas largas
      RegExp(r'Image\.network\((?!.*cacheWidth)'),  // Sin cache dimensions
    ],
  };

  /// Analiza un archivo en busca de patrones de bugs
  static List<BugReport> analyzeFile(String filePath) {
    final content = File(filePath).readAsStringSync();
    final lines = content.split('\n');
    final bugs = <BugReport>[];

    for (var lineNum = 0; lineNum < lines.length; lineNum++) {
      final line = lines[lineNum];

      for (final entry in bugPatterns.entries) {
        for (final pattern in entry.value) {
          if (pattern.hasMatch(line)) {
            bugs.add(BugReport(
              file: filePath,
              line: lineNum + 1,
              category: entry.key,
              description: _getDescription(entry.key, pattern),
              severity: _getSeverity(entry.key),
              suggestion: _getSuggestion(entry.key, line),
            ));
          }
        }
      }
    }

    return bugs;
  }

  static String _getDescription(String category, RegExp pattern) {
    final descriptions = {
      'null_safety': 'Posible null pointer exception - uso de force unwrap',
      'memory_leak': 'Posible memory leak - recurso sin liberar',
      'async_issues': 'Problema con código asíncrono',
      'performance': 'Problema de rendimiento potencial',
    };
    return descriptions[category] ?? 'Patrón de bug detectado';
  }

  static BugSeverity _getSeverity(String category) {
    final severities = {
      'null_safety': BugSeverity.high,
      'memory_leak': BugSeverity.high,
      'async_issues': BugSeverity.medium,
      'performance': BugSeverity.low,
    };
    return severities[category] ?? BugSeverity.medium;
  }

  static String _getSuggestion(String category, String line) {
    // Sugerencias basadas en el patrón detectado
    final suggestions = {
      'null_safety': 'Considera usar operador ?? o verificar null antes',
      'memory_leak': 'Asegúrate de cancelar/dispose en dispose() o deactivate()',
      'async_issues': 'No uses async en setState o build. Extrae la lógica async',
      'performance': 'Usa ListView.builder para listas grandes o añade cacheWidth/Height',
    };
    return suggestions[category] ?? 'Revisa este código';
  }
}

enum BugSeverity { low, medium, high, critical }

class BugReport {
  final String file;
  final int line;
  final String category;
  final String description;
  final BugSeverity severity;
  final String suggestion;

  BugReport({
    required this.file,
    required this.line,
    required this.category,
    required this.description,
    required this.severity,
    required this.suggestion,
  });

  Map<String, dynamic> toJson() => {
    'file': file,
    'line': line,
    'category': category,
    'description': description,
    'severity': severity.name,
    'suggestion': suggestion,
  };
}
```

### 11.4 Self-Healing Tests

```dart
// tools/ai_testing/self_healing_finder.dart

/// Sistema de auto-reparación de selectores en tests
class SelfHealingFinder {
  final Map<String, List<FinderStrategy>> _strategies = {};
  final Map<String, String> _healedSelectors = {};

  /// Registra estrategias de búsqueda alternativas para un elemento
  void registerStrategies(String elementId, List<FinderStrategy> strategies) {
    _strategies[elementId] = strategies;
  }

  /// Encuentra un elemento con fallback automático
  Finder find(String elementId, {bool allowHealing = true}) {
    final strategies = _strategies[elementId] ?? [];

    // Si ya tenemos un selector "curado", usarlo primero
    if (_healedSelectors.containsKey(elementId)) {
      final healedFinder = _createFinder(_healedSelectors[elementId]!);
      // Verificar si aún funciona
      // Si funciona, devolverlo; si no, continuar con healing
    }

    // Intentar cada estrategia en orden
    for (final strategy in strategies) {
      final finder = _createFinderFromStrategy(strategy);
      // En un test real, verificaríamos si encuentra algo
      // Aquí simulamos el proceso
      if (_wouldFindElement(finder)) {
        if (strategy != strategies.first) {
          // Se usó una estrategia alternativa - registrar para futuro
          _healedSelectors[elementId] = strategy.selector;
          _reportHealing(elementId, strategies.first, strategy);
        }
        return finder;
      }
    }

    throw FinderHealingException(
      'No se pudo encontrar elemento: $elementId',
      attemptedStrategies: strategies,
    );
  }

  Finder _createFinderFromStrategy(FinderStrategy strategy) {
    switch (strategy.type) {
      case FinderType.key:
        return find.byKey(Key(strategy.selector));
      case FinderType.type:
        return find.byType(_getTypeFromString(strategy.selector));
      case FinderType.text:
        return find.text(strategy.selector);
      case FinderType.semantics:
        return find.bySemanticsLabel(strategy.selector);
      case FinderType.testId:
        return find.byKey(Key('test_${strategy.selector}'));
    }
  }

  void _reportHealing(
    String elementId,
    FinderStrategy original,
    FinderStrategy healed,
  ) {
    print('''
╔══════════════════════════════════════════════════════════════╗
║                    SELF-HEALING APPLIED                       ║
╠══════════════════════════════════════════════════════════════╣
║  Element: $elementId
║  Original: ${original.type.name} -> ${original.selector}
║  Healed:   ${healed.type.name} -> ${healed.selector}
║
║  RECOMENDACIÓN: Actualiza el test con el nuevo selector
╚══════════════════════════════════════════════════════════════╝
''');
  }
}

enum FinderType { key, type, text, semantics, testId }

class FinderStrategy {
  final FinderType type;
  final String selector;
  final int priority;

  FinderStrategy({
    required this.type,
    required this.selector,
    this.priority = 0,
  });
}

// Uso en tests:
void main() {
  final healer = SelfHealingFinder();

  // Registrar múltiples estrategias para un botón
  healer.registerStrategies('login_button', [
    FinderStrategy(type: FinderType.key, selector: 'login_btn', priority: 0),
    FinderStrategy(type: FinderType.testId, selector: 'login', priority: 1),
    FinderStrategy(type: FinderType.text, selector: 'Iniciar sesión', priority: 2),
    FinderStrategy(type: FinderType.semantics, selector: 'Login button', priority: 3),
  ]);

  testWidgets('login flow with self-healing', (tester) async {
    await tester.pumpWidget(const LoginPage());

    // Si el key original cambió, intentará alternativas automáticamente
    await tester.tap(healer.find('login_button'));
  });
}
```

---

## 12. Testing as Code (TaC) - Plantillas Parametrizables

### 12.1 Concepto de Testing as Code

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    TESTING AS CODE (TaC) PARA FLUTTER                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   Principios clave:                                                          │
│   • Infraestructura de tests versionada                                     │
│   • Configuración declarativa (YAML/JSON)                                   │
│   • Plantillas reutilizables                                                │
│   • Parametrización por entorno                                             │
│   • Reproducibilidad total                                                  │
│                                                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                     ESTRUCTURA DE TAC                                │   │
│   │                                                                      │   │
│   │   qeac/                                                              │   │
│   │   ├── templates/           # Plantillas base                        │   │
│   │   │   ├── unit_test.dart.tpl                                        │   │
│   │   │   ├── widget_test.dart.tpl                                      │   │
│   │   │   ├── integration_test.dart.tpl                                 │   │
│   │   │   └── golden_test.dart.tpl                                      │   │
│   │   ├── configs/             # Configuraciones                        │   │
│   │   │   ├── base.yaml                                                 │   │
│   │   │   ├── dev.yaml                                                  │   │
│   │   │   ├── staging.yaml                                              │   │
│   │   │   └── production.yaml                                           │   │
│   │   ├── generators/          # Generadores de código                  │   │
│   │   │   ├── test_generator.dart                                       │   │
│   │   │   └── mock_generator.dart                                       │   │
│   │   └── qeac.yaml            # Configuración principal                │   │
│   │                                                                      │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 12.2 Configuración Principal de QEaC

```yaml
# qeac/qeac.yaml
version: "1.0"
name: "Flutter QEaC Configuration"

# Configuración del proyecto
project:
  name: "my_flutter_app"
  flutter_version: "3.24.0"
  dart_version: "3.5.0"

# Configuración de tests
testing:
  # Pruebas unitarias
  unit:
    enabled: true
    coverage_threshold: 80
    parallel: true
    timeout: "5m"
    patterns:
      - "test/**/*_test.dart"
    exclude:
      - "test/golden/**"
      - "test/integration/**"

  # Pruebas de widgets
  widget:
    enabled: true
    coverage_threshold: 75
    timeout: "10m"
    patterns:
      - "test/**/widgets/**_test.dart"
      - "test/**/pages/**_test.dart"

  # Golden tests
  golden:
    enabled: true
    update_on_failure: false
    tolerance: 0.001
    devices:
      - name: "phone"
        width: 375
        height: 812
        pixel_ratio: 3.0
      - name: "tablet"
        width: 768
        height: 1024
        pixel_ratio: 2.0
    themes:
      - light
      - dark

  # Pruebas de integración
  integration:
    enabled: true
    timeout: "30m"
    retry_count: 2
    parallel_devices: 2
    device_farm:
      provider: "firebase_test_lab"
      devices:
        android:
          - model: "Pixel6"
            version: "33"
          - model: "Pixel4"
            version: "30"
        ios:
          - model: "iphone14"
            version: "16.6"

  # Mutation testing
  mutation:
    enabled: true
    schedule: "weekly"
    threshold: 70
    target_files:
      - "lib/core/**/*.dart"
      - "lib/features/**/domain/**/*.dart"

# Quality gates
quality_gates:
  coverage:
    lines: 80
    branches: 75
    functions: 85

  complexity:
    cyclomatic_max: 10
    cognitive_max: 15

  duplication:
    max_percentage: 3

  static_analysis:
    errors: 0
    warnings: 0

# CI/CD Integration
ci:
  provider: "github_actions"
  on:
    push:
      branches: ["main", "develop"]
    pull_request:
      branches: ["main", "develop"]

  jobs:
    - name: "analyze"
      runs_on: "ubuntu-latest"
      steps:
        - "lint"
        - "format"
        - "analyze"

    - name: "test"
      runs_on: "ubuntu-latest"
      needs: ["analyze"]
      steps:
        - "unit_tests"
        - "widget_tests"
        - "coverage_report"

    - name: "golden"
      runs_on: "macos-latest"
      needs: ["analyze"]
      steps:
        - "golden_tests"

    - name: "integration"
      runs_on: "ubuntu-latest"
      needs: ["test"]
      steps:
        - "build_apk"
        - "firebase_test_lab"

# Herramientas adicionales
tools:
  sonarqube:
    enabled: true
    host: "${SONAR_HOST}"
    token: "${SONAR_TOKEN}"

  codecov:
    enabled: true
    token: "${CODECOV_TOKEN}"

  sentry:
    enabled: true
    dsn: "${SENTRY_DSN}"

# Notificaciones
notifications:
  slack:
    webhook: "${SLACK_WEBHOOK}"
    on_failure: true
    on_success: false

  email:
    recipients:
      - "team@example.com"
    on_failure: true
```

### 12.3 Plantillas de Tests Parametrizables

```dart
// qeac/templates/unit_test.dart.tpl
// Template para generación de tests unitarios

/*
 * Variables disponibles:
 * - {{class_name}}: Nombre de la clase a testear
 * - {{file_path}}: Ruta del archivo fuente
 * - {{dependencies}}: Lista de dependencias a mockear
 * - {{methods}}: Lista de métodos a testear
 * - {{package_name}}: Nombre del paquete
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{package_name}}/{{file_path}}';

{{#dependencies}}
class Mock{{name}} extends Mock implements {{type}} {}
{{/dependencies}}

{{#fakes}}
class Fake{{name}} extends Fake implements {{type}} {}
{{/fakes}}

void main() {
  late {{class_name}} sut; // System Under Test
  {{#dependencies}}
  late Mock{{name}} mock{{name}};
  {{/dependencies}}

  setUpAll(() {
    {{#fakes}}
    registerFallbackValue(Fake{{name}}());
    {{/fakes}}
  });

  setUp(() {
    {{#dependencies}}
    mock{{name}} = Mock{{name}}();
    {{/dependencies}}

    sut = {{class_name}}(
      {{#dependencies}}
      {{param_name}}: mock{{name}},
      {{/dependencies}}
    );
  });

  group('{{class_name}}', () {
    {{#methods}}
    group('{{method_name}}', () {
      test('debe {{expected_behavior_success}}', () async {
        // Arrange
        {{#arrange_success}}
        {{.}}
        {{/arrange_success}}

        // Act
        final result = await sut.{{method_name}}({{params}});

        // Assert
        expect(result, {{expected_result}});
        {{#verify}}
        verify(() => {{.}}).called(1);
        {{/verify}}
      });

      test('debe {{expected_behavior_failure}}', () async {
        // Arrange
        {{#arrange_failure}}
        {{.}}
        {{/arrange_failure}}

        // Act & Assert
        expect(
          () => sut.{{method_name}}({{params}}),
          throwsA(isA<{{exception_type}}>()),
        );
      });

      {{#edge_cases}}
      test('{{description}}', () async {
        // Arrange
        {{arrange}}

        // Act
        final result = await sut.{{method_name}}({{params}});

        // Assert
        expect(result, {{expected}});
      });
      {{/edge_cases}}
    });

    {{/methods}}
  });
}
```

### 12.4 Generador de Tests desde Plantillas

```dart
// qeac/generators/test_generator.dart

import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:mustache_template/mustache_template.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

class QEaCTestGenerator {
  final String configPath;
  late final Map<String, dynamic> config;

  QEaCTestGenerator({required this.configPath}) {
    final configFile = File(configPath);
    config = loadYaml(configFile.readAsStringSync());
  }

  /// Genera tests para un archivo fuente
  Future<void> generateTestsForFile(String sourcePath) async {
    final sourceFile = File(sourcePath);
    final sourceContent = await sourceFile.readAsString();

    // Analizar el código fuente
    final parseResult = parseString(content: sourceContent);
    final unit = parseResult.unit;

    // Encontrar clases y métodos
    final classes = _extractClasses(unit);

    for (final classInfo in classes) {
      await _generateTestFile(classInfo, sourcePath);
    }
  }

  List<ClassInfo> _extractClasses(CompilationUnit unit) {
    final classes = <ClassInfo>[];

    for (final declaration in unit.declarations) {
      if (declaration is ClassDeclaration) {
        final classInfo = ClassInfo(
          name: declaration.name.toString(),
          methods: _extractMethods(declaration),
          dependencies: _extractDependencies(declaration),
        );
        classes.add(classInfo);
      }
    }

    return classes;
  }

  List<MethodInfo> _extractMethods(ClassDeclaration classDecl) {
    final methods = <MethodInfo>[];

    for (final member in classDecl.members) {
      if (member is MethodDeclaration && !member.name.toString().startsWith('_')) {
        methods.add(MethodInfo(
          name: member.name.toString(),
          returnType: member.returnType?.toString() ?? 'void',
          parameters: _extractParameters(member),
          isAsync: member.body.isAsynchronous,
        ));
      }
    }

    return methods;
  }

  Future<void> _generateTestFile(ClassInfo classInfo, String sourcePath) async {
    // Cargar template
    final templateFile = File('qeac/templates/unit_test.dart.tpl');
    final templateContent = await templateFile.readAsString();

    // Preparar datos para el template
    final templateData = {
      'class_name': classInfo.name,
      'file_path': _getRelativePath(sourcePath),
      'package_name': config['project']['name'],
      'dependencies': classInfo.dependencies.map((d) => {
        'name': d.name,
        'type': d.type,
        'param_name': _toParamName(d.name),
      }).toList(),
      'fakes': classInfo.dependencies.map((d) => {
        'name': d.name,
        'type': d.type,
      }).toList(),
      'methods': classInfo.methods.map((m) => _prepareMethodData(m)).toList(),
    };

    // Renderizar template
    final template = Template(templateContent);
    final output = template.renderString(templateData);

    // Escribir archivo de test
    final testPath = _getTestPath(sourcePath);
    final testFile = File(testPath);
    await testFile.parent.create(recursive: true);
    await testFile.writeAsString(output);

    print('Generated: $testPath');
  }

  Map<String, dynamic> _prepareMethodData(MethodInfo method) {
    return {
      'method_name': method.name,
      'params': method.parameters.map((p) => p.name).join(', '),
      'expected_behavior_success': 'ejecutar correctamente ${method.name}',
      'expected_behavior_failure': 'lanzar excepción cuando falla',
      'expected_result': _getExpectedResult(method.returnType),
      'exception_type': 'Exception',
      'arrange_success': _generateArrangeSuccess(method),
      'arrange_failure': _generateArrangeFailure(method),
      'verify': _generateVerifications(method),
      'edge_cases': _generateEdgeCases(method),
    };
  }

  String _getTestPath(String sourcePath) {
    return sourcePath
        .replaceFirst('lib/', 'test/')
        .replaceFirst('.dart', '_test.dart');
  }
}

class ClassInfo {
  final String name;
  final List<MethodInfo> methods;
  final List<DependencyInfo> dependencies;

  ClassInfo({
    required this.name,
    required this.methods,
    required this.dependencies,
  });
}

class MethodInfo {
  final String name;
  final String returnType;
  final List<ParameterInfo> parameters;
  final bool isAsync;

  MethodInfo({
    required this.name,
    required this.returnType,
    required this.parameters,
    required this.isAsync,
  });
}

class DependencyInfo {
  final String name;
  final String type;

  DependencyInfo({required this.name, required this.type});
}

class ParameterInfo {
  final String name;
  final String type;
  final bool isRequired;

  ParameterInfo({
    required this.name,
    required this.type,
    required this.isRequired,
  });
}
```

### 12.5 CLI de QEaC

```dart
// qeac/bin/qeac.dart

import 'dart:io';
import 'package:args/command_runner.dart';

void main(List<String> args) {
  final runner = CommandRunner<void>(
    'qeac',
    'Quality Engineering as Code CLI for Flutter',
  )
    ..addCommand(InitCommand())
    ..addCommand(GenerateCommand())
    ..addCommand(RunCommand())
    ..addCommand(ReportCommand())
    ..addCommand(ValidateCommand());

  runner.run(args).catchError((error) {
    print('Error: $error');
    exit(1);
  });
}

class InitCommand extends Command<void> {
  @override
  String get name => 'init';

  @override
  String get description => 'Initialize QEaC in a Flutter project';

  @override
  Future<void> run() async {
    print('Initializing QEaC...');

    // Crear estructura de carpetas
    await Directory('qeac/templates').create(recursive: true);
    await Directory('qeac/configs').create(recursive: true);
    await Directory('qeac/generators').create(recursive: true);

    // Copiar templates base
    await _copyTemplates();

    // Crear configuración inicial
    await _createConfig();

    print('QEaC initialized successfully!');
    print('Edit qeac/qeac.yaml to customize your testing infrastructure.');
  }

  Future<void> _copyTemplates() async {
    // Copiar templates desde el paquete
    final templates = [
      'unit_test.dart.tpl',
      'widget_test.dart.tpl',
      'integration_test.dart.tpl',
      'golden_test.dart.tpl',
    ];

    for (final template in templates) {
      final file = File('qeac/templates/$template');
      await file.writeAsString(_getDefaultTemplate(template));
    }
  }

  Future<void> _createConfig() async {
    final configFile = File('qeac/qeac.yaml');
    await configFile.writeAsString(_getDefaultConfig());
  }
}

class GenerateCommand extends Command<void> {
  @override
  String get name => 'generate';

  @override
  String get description => 'Generate tests from templates';

  GenerateCommand() {
    argParser
      ..addOption('source', abbr: 's', help: 'Source file or directory')
      ..addOption('type', abbr: 't', help: 'Test type (unit, widget, integration)')
      ..addFlag('force', abbr: 'f', help: 'Overwrite existing tests');
  }

  @override
  Future<void> run() async {
    final source = argResults?['source'] as String?;
    final type = argResults?['type'] as String? ?? 'unit';
    final force = argResults?['force'] as bool? ?? false;

    if (source == null) {
      print('Error: Source file or directory required');
      print('Usage: qeac generate -s lib/features/auth -t unit');
      exit(1);
    }

    print('Generating $type tests for $source...');

    final generator = QEaCTestGenerator(configPath: 'qeac/qeac.yaml');

    if (FileSystemEntity.isDirectorySync(source)) {
      await _generateForDirectory(generator, source, type, force);
    } else {
      await generator.generateTestsForFile(source);
    }

    print('Generation complete!');
  }

  Future<void> _generateForDirectory(
    QEaCTestGenerator generator,
    String dirPath,
    String type,
    bool force,
  ) async {
    final dir = Directory(dirPath);
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        await generator.generateTestsForFile(entity.path);
      }
    }
  }
}

class RunCommand extends Command<void> {
  @override
  String get name => 'run';

  @override
  String get description => 'Run tests according to QEaC configuration';

  RunCommand() {
    argParser
      ..addOption('type', abbr: 't', help: 'Test type to run')
      ..addFlag('coverage', abbr: 'c', help: 'Generate coverage report')
      ..addFlag('parallel', abbr: 'p', help: 'Run tests in parallel');
  }

  @override
  Future<void> run() async {
    final type = argResults?['type'] as String?;
    final coverage = argResults?['coverage'] as bool? ?? false;
    final parallel = argResults?['parallel'] as bool? ?? true;

    print('Running tests...');

    final args = ['test'];

    if (coverage) args.add('--coverage');
    if (parallel) args.addAll(['--concurrency', Platform.numberOfProcessors.toString()]);

    if (type != null) {
      switch (type) {
        case 'unit':
          args.addAll(['--exclude-tags', 'golden,integration']);
          break;
        case 'widget':
          args.addAll(['--tags', 'widget']);
          break;
        case 'golden':
          args.addAll(['--tags', 'golden']);
          break;
        case 'integration':
          // Usar integration_test
          break;
      }
    }

    final result = await Process.run('flutter', args);
    stdout.write(result.stdout);
    stderr.write(result.stderr);

    exit(result.exitCode);
  }
}

class ReportCommand extends Command<void> {
  @override
  String get name => 'report';

  @override
  String get description => 'Generate test reports';

  @override
  Future<void> run() async {
    print('Generating reports...');

    // Generar reporte HTML de cobertura
    await Process.run('genhtml', [
      'coverage/lcov.info',
      '-o', 'coverage/html',
    ]);

    // Generar reporte de calidad
    await _generateQualityReport();

    print('Reports generated in coverage/html');
  }

  Future<void> _generateQualityReport() async {
    // Implementar generación de reporte de calidad
  }
}

class ValidateCommand extends Command<void> {
  @override
  String get name => 'validate';

  @override
  String get description => 'Validate QEaC configuration and quality gates';

  @override
  Future<void> run() async {
    print('Validating configuration...');

    final configFile = File('qeac/qeac.yaml');
    if (!configFile.existsSync()) {
      print('Error: qeac/qeac.yaml not found');
      print('Run: qeac init');
      exit(1);
    }

    // Validar configuración
    // Verificar quality gates
    // Reportar estado

    print('Configuration is valid!');
  }
}
```

---

## 13. Arquitectura Testeable - Buenas Prácticas

### 13.1 Principios SOLID para Código Testeable

```dart
// ============================================
// SINGLE RESPONSIBILITY PRINCIPLE (SRP)
// ============================================

// ❌ MAL: Clase con múltiples responsabilidades
class UserManager {
  Future<User> login(String email, String password) async {
    // Validación
    if (!email.contains('@')) throw InvalidEmailException();

    // Llamada API
    final response = await http.post('/login', body: {...});

    // Parsing
    final user = User.fromJson(response.data);

    // Almacenamiento local
    await SharedPreferences.getInstance()
      ..setString('user', jsonEncode(user.toJson()));

    // Analytics
    Analytics.track('login', {'email': email});

    return user;
  }
}

// ✅ BIEN: Responsabilidades separadas
class LoginUseCase {
  final AuthRepository _authRepository;
  final UserStorage _userStorage;
  final AnalyticsService _analytics;

  LoginUseCase(this._authRepository, this._userStorage, this._analytics);

  Future<Either<Failure, User>> call(LoginParams params) async {
    final result = await _authRepository.login(
      params.email,
      params.password,
    );

    return result.fold(
      (failure) => Left(failure),
      (user) async {
        await _userStorage.saveUser(user);
        _analytics.trackLogin(user.id);
        return Right(user);
      },
    );
  }
}

// ============================================
// DEPENDENCY INVERSION PRINCIPLE (DIP)
// ============================================

// ❌ MAL: Dependencia concreta
class ProductRepository {
  final http.Client _client = http.Client();
  final SharedPreferences _prefs = SharedPreferences.getInstance();

  Future<List<Product>> getProducts() async {
    // Imposible de mockear
    final response = await _client.get('/products');
    return (response.data as List).map((e) => Product.fromJson(e)).toList();
  }
}

// ✅ BIEN: Dependencias inyectadas mediante interfaces
abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  ProductRepositoryImpl({
    required ApiClient apiClient,
    required LocalStorage localStorage,
  })  : _apiClient = apiClient,
        _localStorage = localStorage;

  @override
  Future<List<Product>> getProducts() async {
    try {
      final response = await _apiClient.get('/products');
      final products = (response.data as List)
          .map((e) => Product.fromJson(e))
          .toList();
      await _localStorage.cacheProducts(products);
      return products;
    } catch (e) {
      // Fallback a cache
      return await _localStorage.getCachedProducts();
    }
  }
}
```

### 13.2 Clean Architecture para Flutter

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        CLEAN ARCHITECTURE FLUTTER                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   lib/                                                                       │
│   ├── core/                         # Código compartido                     │
│   │   ├── error/                    # Manejo de errores                     │
│   │   │   ├── exceptions.dart                                               │
│   │   │   └── failures.dart                                                 │
│   │   ├── network/                  # Cliente HTTP                          │
│   │   ├── utils/                    # Utilidades                            │
│   │   └── di/                       # Dependency Injection                  │
│   │       └── injection.dart                                                │
│   │                                                                         │
│   └── features/                     # Features/Módulos                      │
│       └── auth/                                                             │
│           ├── data/                 # CAPA DE DATOS                         │
│           │   ├── datasources/      # Fuentes de datos                      │
│           │   │   ├── auth_remote_datasource.dart                           │
│           │   │   └── auth_local_datasource.dart                            │
│           │   ├── models/           # Modelos (DTOs)                        │
│           │   │   └── user_model.dart                                       │
│           │   └── repositories/     # Implementaciones                      │
│           │       └── auth_repository_impl.dart                             │
│           │                                                                 │
│           ├── domain/               # CAPA DE DOMINIO                       │
│           │   ├── entities/         # Entidades de negocio                  │
│           │   │   └── user.dart                                             │
│           │   ├── repositories/     # Contratos (interfaces)                │
│           │   │   └── auth_repository.dart                                  │
│           │   └── usecases/         # Casos de uso                          │
│           │       ├── login_usecase.dart                                    │
│           │       └── logout_usecase.dart                                   │
│           │                                                                 │
│           └── presentation/         # CAPA DE PRESENTACIÓN                  │
│               ├── bloc/             # State management                      │
│               │   ├── auth_bloc.dart                                        │
│               │   ├── auth_event.dart                                       │
│               │   └── auth_state.dart                                       │
│               ├── pages/            # Páginas/Screens                       │
│               │   └── login_page.dart                                       │
│               └── widgets/          # Widgets específicos                   │
│                   └── login_form.dart                                       │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 13.3 Dependency Injection con GetIt

```dart
// lib/core/di/injection.dart

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

// lib/core/di/injection.config.dart (generado)
// Ejecutar: dart run build_runner build

// lib/features/auth/data/datasources/auth_remote_datasource.dart
@lazySingleton
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _client.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response.data);
  }
}

// lib/features/auth/data/repositories/auth_repository_impl.dart
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await _networkInfo.isConnected) {
      try {
        final userModel = await _remoteDataSource.login(email, password);
        await _localDataSource.cacheUser(userModel);
        return Right(userModel.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}

// lib/features/auth/domain/usecases/login_usecase.dart
@lazySingleton
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, User>> call(LoginParams params) {
    return _repository.login(params.email, params.password);
  }
}

// lib/features/auth/presentation/bloc/auth_bloc.dart
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc(this._loginUseCase, this._logoutUseCase) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
```

### 13.4 Configuración de Tests con DI

```dart
// test/helpers/test_injection.dart

import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

final testGetIt = GetIt.instance;

// Mocks globales
class MockAuthRepository extends Mock implements AuthRepository {}
class MockApiClient extends Mock implements ApiClient {}
class MockLocalStorage extends Mock implements LocalStorage {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void setupTestDependencies() {
  testGetIt.reset();

  // Registrar mocks
  testGetIt.registerLazySingleton<AuthRepository>(() => MockAuthRepository());
  testGetIt.registerLazySingleton<ApiClient>(() => MockApiClient());
  testGetIt.registerLazySingleton<LocalStorage>(() => MockLocalStorage());
  testGetIt.registerLazySingleton<NetworkInfo>(() => MockNetworkInfo());

  // Registrar implementaciones reales que usan mocks
  testGetIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(testGetIt<AuthRepository>()),
  );

  testGetIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      testGetIt<LoginUseCase>(),
      testGetIt<LogoutUseCase>(),
    ),
  );
}

// Uso en tests
void main() {
  late AuthBloc bloc;
  late MockAuthRepository mockRepository;

  setUp(() {
    setupTestDependencies();
    mockRepository = testGetIt<AuthRepository>() as MockAuthRepository;
    bloc = testGetIt<AuthBloc>();
  });

  tearDown(() {
    bloc.close();
    testGetIt.reset();
  });

  // Tests...
}
```

### 13.5 Patrones para Código Testeable

```dart
// ============================================
// PATRÓN: REPOSITORY CON EITHER
// ============================================

abstract class Either<L, R> {
  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight);
}

class Left<L, R> extends Either<L, R> {
  final L value;
  Left(this.value);

  @override
  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight) => ifLeft(value);
}

class Right<L, R> extends Either<L, R> {
  final R value;
  Right(this.value);

  @override
  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight) => ifRight(value);
}

// ============================================
// PATRÓN: FACTORY METHODS PARA TESTS
// ============================================

// lib/features/products/domain/entities/product.dart
class Product {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final bool isAvailable;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.isAvailable = true,
  });

  // Factory para tests - NO incluir en producción
  @visibleForTesting
  factory Product.forTest({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    bool? isAvailable,
  }) {
    return Product(
      id: id ?? 'test-id-${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Test Product',
      price: price ?? 99.99,
      imageUrl: imageUrl,
      isAvailable: isAvailable ?? true,
    );
  }
}

// ============================================
// PATRÓN: WIDGETS TESTEABLES
// ============================================

// ❌ MAL: Widget con lógica interna difícil de testear
class ProductCard extends StatelessWidget {
  final String productId;

  const ProductCard({required this.productId});

  @override
  Widget build(BuildContext context) {
    // Obtiene datos internamente - difícil de testear
    final product = context.read<ProductBloc>().getProduct(productId);
    return Card(child: Text(product.name));
  }
}

// ✅ BIEN: Widget que recibe datos como parámetros
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    required this.product,
    this.onTap,
    this.onAddToCart,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('product_card_${product.id}'),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            if (product.imageUrl != null)
              Image.network(
                product.imageUrl!,
                key: const Key('product_image'),
              )
            else
              const Icon(
                Icons.image_not_supported,
                key: Key('product_placeholder'),
              ),
            Text(
              product.name,
              key: const Key('product_name'),
            ),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              key: const Key('product_price'),
            ),
            if (onAddToCart != null)
              ElevatedButton(
                key: const Key('add_to_cart_button'),
                onPressed: product.isAvailable ? onAddToCart : null,
                child: const Text('Agregar al carrito'),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// PATRÓN: SEPARACIÓN DE LÓGICA Y UI
// ============================================

// Controller/ViewModel separado
class LoginController extends ChangeNotifier {
  final LoginUseCase _loginUseCase;

  LoginController(this._loginUseCase);

  LoginState _state = LoginState.initial();
  LoginState get state => _state;

  String _email = '';
  String _password = '';

  void setEmail(String email) {
    _email = email;
    _validateForm();
  }

  void setPassword(String password) {
    _password = password;
    _validateForm();
  }

  void _validateForm() {
    final emailValid = _email.contains('@') && _email.contains('.');
    final passwordValid = _password.length >= 8;

    _state = _state.copyWith(
      emailError: emailValid ? null : 'Email inválido',
      passwordError: passwordValid ? null : 'Mínimo 8 caracteres',
      canSubmit: emailValid && passwordValid,
    );
    notifyListeners();
  }

  Future<void> login() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _loginUseCase(
      LoginParams(email: _email, password: _password),
    );

    result.fold(
      (failure) {
        _state = _state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (user) {
        _state = _state.copyWith(
          isLoading: false,
          user: user,
        );
      },
    );
    notifyListeners();
  }
}

// El widget solo renderiza según el estado
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<LoginController>(),
      child: Consumer<LoginController>(
        builder: (context, controller, _) {
          final state = controller.state;

          if (state.user != null) {
            return const HomePage();
          }

          return Scaffold(
            body: LoginForm(
              emailError: state.emailError,
              passwordError: state.passwordError,
              canSubmit: state.canSubmit,
              isLoading: state.isLoading,
              error: state.error,
              onEmailChanged: controller.setEmail,
              onPasswordChanged: controller.setPassword,
              onSubmit: controller.login,
            ),
          );
        },
      ),
    );
  }
}
```

---

## 14. Implementación de Referencia

### 14.1 Plantilla de Repositorio QEaC

```
flutter_qeac_template/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── cd.yml
│       └── mutation-testing.yml
├── qeac/
│   ├── templates/
│   │   ├── unit_test.dart.tpl
│   │   ├── widget_test.dart.tpl
│   │   ├── integration_test.dart.tpl
│   │   └── golden_test.dart.tpl
│   ├── configs/
│   │   ├── base.yaml
│   │   └── environments/
│   │       ├── dev.yaml
│   │       ├── staging.yaml
│   │       └── production.yaml
│   ├── generators/
│   │   └── test_generator.dart
│   └── qeac.yaml
├── lib/
│   ├── core/
│   ├── features/
│   └── main.dart
├── test/
│   ├── fixtures/
│   ├── helpers/
│   └── features/
├── integration_test/
│   ├── robots/
│   └── app_test.dart
├── widgetbook/
├── analysis_options.yaml
├── pubspec.yaml
└── README.md
```

### 14.2 Script de Inicialización

```bash
#!/bin/bash
# scripts/init_qeac.sh

echo "🚀 Inicializando QEaC para Flutter..."

# Crear estructura de carpetas
mkdir -p qeac/{templates,configs/environments,generators}
mkdir -p test/{fixtures,helpers/factories,golden}
mkdir -p integration_test/robots

# Instalar dependencias de desarrollo
flutter pub add --dev \
  flutter_test \
  mockito \
  mocktail \
  bloc_test \
  golden_toolkit \
  patrol \
  build_runner \
  injectable_generator \
  coverage

# Crear archivo de configuración base
cat > qeac/qeac.yaml << 'EOF'
version: "1.0"
name: "Flutter QEaC Configuration"

project:
  name: "${PWD##*/}"
  flutter_version: "3.24.0"

testing:
  unit:
    enabled: true
    coverage_threshold: 80
  widget:
    enabled: true
    coverage_threshold: 75
  golden:
    enabled: true
  integration:
    enabled: true

quality_gates:
  coverage:
    lines: 80
    branches: 75
EOF

# Crear helper de tests
cat > test/helpers/pump_app.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) async {
    await pumpWidget(
      MaterialApp(home: Scaffold(body: widget)),
    );
    await pump();
  }
}
EOF

# Crear GitHub Actions workflow
mkdir -p .github/workflows
cat > .github/workflows/ci.yml << 'EOF'
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
EOF

echo "✅ QEaC inicializado correctamente"
echo "📝 Edita qeac/qeac.yaml para personalizar"
echo "🧪 Ejecuta 'flutter test' para verificar"
```

### 14.3 Checklist de Implementación

```markdown
# Checklist de Implementación QEaC

## Fase 1: Configuración Inicial
- [ ] Crear estructura de carpetas QEaC
- [ ] Configurar pubspec.yaml con dependencias de testing
- [ ] Crear analysis_options.yaml estricto
- [ ] Configurar qeac.yaml principal
- [ ] Crear helpers de testing básicos

## Fase 2: Arquitectura
- [ ] Implementar Clean Architecture
- [ ] Configurar Dependency Injection (GetIt + Injectable)
- [ ] Crear capa de dominio (entities, repositories, usecases)
- [ ] Crear capa de datos (datasources, models, implementations)
- [ ] Crear capa de presentación (BLoC/Cubit)

## Fase 3: Tests Unitarios
- [ ] Crear factories de datos de prueba
- [ ] Crear mocks base
- [ ] Escribir tests para UseCases
- [ ] Escribir tests para Repositories
- [ ] Escribir tests para BLoCs/Cubits
- [ ] Alcanzar 80% de cobertura

## Fase 4: Tests de Widgets
- [ ] Crear extension PumpApp
- [ ] Escribir tests para widgets atómicos
- [ ] Escribir tests para páginas
- [ ] Probar interacciones de usuario
- [ ] Probar diferentes estados

## Fase 5: Golden Tests
- [ ] Configurar golden_toolkit
- [ ] Crear goldens para tema claro
- [ ] Crear goldens para tema oscuro
- [ ] Crear goldens para diferentes dispositivos
- [ ] Configurar CI para golden tests

## Fase 6: Tests de Integración
- [ ] Configurar Patrol
- [ ] Crear Robot Pattern
- [ ] Escribir tests E2E para flujos críticos
- [ ] Configurar Firebase Test Lab
- [ ] Probar en múltiples dispositivos

## Fase 7: CI/CD
- [ ] Configurar GitHub Actions / Codemagic
- [ ] Configurar quality gates
- [ ] Integrar SonarQube
- [ ] Integrar Codecov
- [ ] Configurar deploy automático

## Fase 8: Monitoreo
- [ ] Integrar Sentry
- [ ] Configurar error tracking
- [ ] Configurar performance monitoring
- [ ] Crear dashboards de métricas

## Fase 9: Documentación
- [ ] Documentar arquitectura
- [ ] Documentar patrones de testing
- [ ] Crear guía de contribución
- [ ] Crear templates de PR
```

---

## 15. Conclusiones y Recomendaciones

### 15.1 Resumen de la Investigación

Esta investigación ha cubierto exhaustivamente la creación de infraestructuras de pruebas para aplicaciones Flutter bajo el paradigma **Quality Engineering as Code (QEaC)**. Los principales hallazgos son:

| Área | Estado del Ecosistema | Recomendación |
|------|----------------------|---------------|
| Pruebas Unitarias | Maduro | flutter_test + mocktail |
| Pruebas de Widgets | Maduro | flutter_test + custom helpers |
| Pruebas E2E | En evolución | Patrol |
| Golden Tests | Maduro | golden_toolkit |
| Mutation Testing | Inmaduro | Implementación manual |
| CI/CD | Maduro | GitHub Actions + Codemagic |
| Device Farms | Maduro | Firebase Test Lab / emulator.wtf |
| Visual Testing | En evolución | Widgetbook Cloud |
| Error Tracking | Maduro | Sentry |
| IA en Testing | Emergente | GitHub Copilot + herramientas custom |

### 15.2 Roadmap de Implementación Sugerido

```
FASE 1 (Semanas 1-2): FUNDAMENTOS
├── Configurar estructura Clean Architecture
├── Implementar Dependency Injection
├── Crear helpers de testing básicos
└── Escribir primeros tests unitarios

FASE 2 (Semanas 3-4): TESTS CORE
├── Completar tests unitarios (80% coverage)
├── Implementar tests de widgets
├── Configurar golden tests
└── Integrar con CI básico

FASE 3 (Semanas 5-6): E2E Y AUTOMATIZACIÓN
├── Implementar tests de integración con Patrol
├── Configurar Firebase Test Lab
├── Implementar quality gates
└── Configurar SonarQube

FASE 4 (Semanas 7-8): AVANZADO
├── Implementar mutation testing manual
├── Configurar Widgetbook
├── Integrar verificación visual
└── Implementar self-healing tests

FASE 5 (Continuo): OPTIMIZACIÓN
├── Integrar herramientas de IA
├── Optimizar tiempos de ejecución
├── Expandir cobertura de device farm
└── Mejorar reportes y dashboards
```

### 15.3 Métricas de Éxito

```yaml
# Métricas objetivo para un proyecto Flutter maduro

cobertura:
  lineas: ≥ 80%
  branches: ≥ 75%
  codigo_nuevo: ≥ 90%

mutation_score: ≥ 70%

tiempos:
  tests_unitarios: < 2 minutos
  tests_widgets: < 5 minutos
  tests_e2e: < 15 minutos
  pipeline_completo: < 30 minutos

calidad:
  errores_estaticos: 0
  warnings: 0
  code_smells: < 10
  deuda_tecnica: < 1 día

reliability:
  tests_flaky: < 1%
  tasa_exito_ci: > 95%
```

### 15.4 Referencias y Fuentes

#### Documentación Oficial
- [Flutter Testing Documentation](https://docs.flutter.dev/testing/overview)
- [Dart Testing Guide](https://dart.dev/guides/testing)

#### Herramientas Principales
- [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html)
- [mocktail](https://pub.dev/packages/mocktail)
- [bloc_test](https://pub.dev/packages/bloc_test)
- [golden_toolkit](https://pub.dev/packages/golden_toolkit)
- [patrol](https://patrol.leancode.co/)
- [Widgetbook](https://www.widgetbook.io/)

#### CI/CD y Device Farms
- [Codemagic](https://blog.codemagic.io/)
- [Firebase Test Lab](https://firebase.google.com/docs/test-lab)
- [emulator.wtf](https://emulator.wtf/)

#### Error Tracking
- [Sentry Flutter](https://sentry.io/for/flutter/)
- [Firebase Crashlytics](https://firebase.google.com/docs/crashlytics)

#### Análisis de Código
- [SonarQube Dart](https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/test-coverage/dart-test-coverage/)
- [Codecov](https://about.codecov.io/)

#### IA en Testing
- [Code Intelligence](https://www.code-intelligence.com/)
- [Applitools](https://applitools.com/)
- [mabl](https://www.mabl.com/)

---

## Apéndice A: Glosario

| Término | Definición |
|---------|------------|
| **QEaC** | Quality Engineering as Code - Paradigma de gestión de calidad como código |
| **TaC** | Testing as Code - Infraestructura de tests versionada y parametrizable |
| **Golden Test** | Test que compara screenshots contra imágenes de referencia |
| **Mutation Testing** | Técnica que evalúa calidad de tests introduciendo bugs deliberados |
| **Device Farm** | Servicio cloud con dispositivos físicos/virtuales para testing |
| **Self-Healing** | Capacidad de tests de auto-repararse ante cambios de UI |
| **Quality Gate** | Umbral de calidad que debe cumplirse para aprobar CI/CD |
| **LCOV** | Formato estándar para reportes de cobertura de código |

---

**Documento generado como parte de la investigación QEaC para Flutter**
**Versión 1.0 - Noviembre 2025**
