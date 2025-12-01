/// DataSource local para auth.
abstract class AuthLocalDataSource {
  // Definir métodos de caché: guardar/eliminar token, persistir usuario.
}

/// Implementación del DataSource local.
// @LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  // final LocalStorage _localStorage;

  // AuthLocalDataSourceImpl(this._localStorage);
}
