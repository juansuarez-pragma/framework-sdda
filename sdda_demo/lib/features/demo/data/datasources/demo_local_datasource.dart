/// DataSource local para demo.
abstract class DemoLocalDataSource {
  // Definir métodos de caché de acuerdo al storage (ej. Hive, SharedPreferences).
}

/// Implementación del DataSource local.
// @LazySingleton(as: DemoLocalDataSource)
class DemoLocalDataSourceImpl implements DemoLocalDataSource {
  // final LocalStorage _localStorage;

  // DemoLocalDataSourceImpl(this._localStorage);
}
