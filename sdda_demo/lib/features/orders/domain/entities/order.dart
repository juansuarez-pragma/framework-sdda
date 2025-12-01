import 'package:equatable/equatable.dart';

import 'order_item.dart';

/// Entidad Order.
class Order extends Equatable {
  final String id;
  final List<OrderItem> items;
  final double total;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.items,
    required this.total,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, items, total, createdAt];
}
