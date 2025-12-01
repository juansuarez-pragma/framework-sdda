import 'package:equatable/equatable.dart';

/// Entidad DemoItem.
class DemoItem extends Equatable {
  final String id;
  final String title;

  const DemoItem({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}
