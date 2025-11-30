/// Extensiones para manipulación de strings.
extension StringCaseExtension on String {
  /// Convierte a snake_case.
  String toSnakeCase() {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  /// Convierte a PascalCase.
  String toPascalCase() {
    return split('_')
        .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join('');
  }

  /// Convierte a camelCase.
  String toCamelCase() {
    final pascal = toPascalCase();
    if (pascal.isEmpty) return pascal;
    return pascal[0].toLowerCase() + pascal.substring(1);
  }

  /// Convierte a palabras separadas por espacio.
  String toSpacedWords() {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => ' ${match.group(0)!}',
    ).trim();
  }
}
