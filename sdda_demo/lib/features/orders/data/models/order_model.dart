import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import 'order_item_model.dart';

/// Model para Order con serialización JSON.
class OrderModel extends Order {

  const OrderModel({
    required super.id,
    required super.items,
    required super.total,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, Object?> json) {
    final rawItems = (json['items'] as List<Object?>?) ?? [];
    return OrderModel(
      id: json['id'] as String,
      items: rawItems
          .whereType<Map<String, Object?>>()
          .map(OrderItemModel.fromJson)
          .toList(),
      total: json['total'] as double,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'items': items
          .map(
            (item) => OrderItemModel(
              id: item.id,
              name: item.name,
              quantity: item.quantity,
              price: item.price,
            ).toJson(),
          )
          .toList(),
      'total': total,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Order toEntity() {
    return Order(
      id: id,
      items: items,
      total: total,
      createdAt: createdAt,
    );
  }
}
