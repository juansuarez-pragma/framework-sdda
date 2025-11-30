/// Utilidades para output en consola con colores.
class Console {
  static const _reset = '\x1B[0m';
  static const _red = '\x1B[31m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _blue = '\x1B[34m';
  static const _cyan = '\x1B[36m';

  /// Imprime mensaje de información.
  static void info(String message) {
    print('$_cyan$message$_reset');
  }

  /// Imprime mensaje de éxito.
  static void success(String message) {
    print('$_green$message$_reset');
  }

  /// Imprime mensaje de error.
  static void error(String message) {
    print('$_red$message$_reset');
  }

  /// Imprime mensaje de advertencia.
  static void warning(String message) {
    print('$_yellow$message$_reset');
  }

  /// Imprime texto normal.
  static void text(String message) {
    print(message);
  }

  /// Imprime header con formato.
  static void header(String title) {
    final line = '═' * 60;
    print('\n$_blue$line$_reset');
    print('$_blue$title$_reset');
    print('$_blue$line$_reset\n');
  }

  /// Imprime lista con bullet points.
  static void list(List<String> items, {String prefix = '•'}) {
    for (final item in items) {
      print('  $prefix $item');
    }
  }
}
