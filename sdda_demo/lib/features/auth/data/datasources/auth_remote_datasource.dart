/// DataSource remoto para auth.
abstract class AuthRemoteDataSource {
  // Definir métodos HTTP: login, register, getCurrentUser, logout, checkAuthStatus.
}

/// Implementación del DataSource remoto.
// @LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // final ApiClient _apiClient;

  // AuthRemoteDataSourceImpl(this._apiClient);
}
