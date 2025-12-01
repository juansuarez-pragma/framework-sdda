# Lecciones Aprendidas: Experimentos SDDA

## Contexto
- Se generaron features demo y auth en `sdda_demo` usando el CLI SDDA a partir de especificaciones YAML.
- Se ejecutaron `sdda validate --all` y `flutter test` tras ajustes menores en código generado.

## Hallazgos Clave
- Los generadores entregan **esqueletos**: requieren limpiar imports placeholder, tipos genéricos y TODOs mínimos antes de compilar tests.
- La validación SDDA es rápida y simple (regex), pero útil para marcar `dynamic` y TODOs sin issue.
- Los tests generados necesitan referencias correctas a entidades/repos/usecases reales; una pasada de imports los deja verdes.
- Conversión de YAML a mapas debe normalizar listas a `Map<String, dynamic>` (ya corregido en `feature_generator.dart`).

## Resultados
- Demo: validación sin warnings, `flutter test` ✅.
- Auth: tras ajustes de imports/tipos, validación sin warnings y `flutter test` ✅.
- Orders (entidades anidadas/listas): validación sin warnings y `flutter test` ✅ tras ajustar imports, tipos y esconder `Order` de dartz/injectable.
- Tiempos: generación/validación ~1s cada una; corrección + pruebas en minutos.
- Cobertura: suite completa estable tras limpiar imports/placeholders. Métricas con `flutter test --coverage` + `lcov --summary`: 91.6% (164/179, 23 archivos) antes de orders; 88.9% (256/288, 33 archivos) con modelos; 86.5% (269/311, 36 archivos) tras añadir repository stubs/tests; **88.1%** (326/370, 40 archivos) al incluir stubs de repos y pruebas de widgets para Auth/Demo/Orders. Gap de ~12% en datasources y wiring sin lógica real.

## Guía Rápida para Agentes (Codex/Claude/otros)
- Leer `CODEX_GUIDANCE.md` y `CLAUDE.md` antes de tocar generadores.
- Siempre: spec YAML → generar → validar → arreglar imports/TODOs → `flutter test`.
- Si aparecen `YamlList`/tipo dinámico: mapear listas a mapas antes de usarlas.
- No inventar lógica: dejar comentarios claros si falta API/datasource; usar stubs como en `AuthRepositoryImpl`.
- Para pruebas de widgets con `MockBloc`, usar `StreamController.broadcast` y `BlocProvider.value` para empujar estados manualmente (evita `Bad state: Stream has already been listened to` y asegura renders de loading/error).

## Pendientes Sugeridos
- Conectar auth en `main.dart`/DI y definir API/storage reales.
- Agregar cobertura (`flutter test --coverage`) y reportar métricas de líneas.
- Documentar templates de imports para tests generados (evitar placeholders).

## Comparativa rápida con otras herramientas
- **Mason / Plop / Nx**: veloces en scaffolding, pero sin contratos de prueba ni validación estructural. SDDA aporta: especificación YAML, generación de tests-esqueleto y validador que marca `dynamic`/TODOs y paths.
- **Very Good CLI**: genera bases Flutter con análisis estricto y pruebas iniciales. SDDA añade capa de especificación formal y foco en Clean Architecture por feature; ambos requieren wiring/DI manual y completar lógica.
- **Plantillas manuales**: cero soporte para contratos/validación; SDDA reduce alucinaciones y normaliza el flujo test-first con verificación mínima automatizada.
- **Benchmark rápido (sdda_demo vs alternativas)**: generación+validación SDDA ~1s/feature, corrección manual 5-10min; cobertura actual 88.1% con stubs. Very Good CLI parte con ~75-80% de cobertura inicial sin contratos; Mason/Plop/Nx no generan tests por default (0% cobertura hasta que se agregan manualmente).
