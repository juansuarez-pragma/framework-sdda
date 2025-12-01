/// Interfaz para verificar la conectividad de red.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementación de NetworkInfo.
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // En una implementación real, usaríamos connectivity_plus
    return true;
  }
}
