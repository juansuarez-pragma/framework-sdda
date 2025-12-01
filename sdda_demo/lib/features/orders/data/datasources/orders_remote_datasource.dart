/// DataSource remoto para orders.
abstract class OrdersRemoteDataSource {
  // Definir métodos HTTP: createOrder, getOrder, cancelOrder.
}

/// Implementación del DataSource remoto.
// @LazySingleton(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  // final ApiClient _apiClient;

  // OrdersRemoteDataSourceImpl(this._apiClient);
}
