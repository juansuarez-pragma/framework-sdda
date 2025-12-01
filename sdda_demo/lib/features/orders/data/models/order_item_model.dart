import '../../domain/entities/order_item.dart';

/// Model para OrderItem con serialización JSON.
class OrderItemModel extends OrderItem {

  const OrderItemModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.price,
  });

  factory OrderItemModel.fromJson(Map<String, Object?> json) {
    return OrderItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: json['price'] as double,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  OrderItem toEntity() {
    return OrderItem(
      id: id,
      name: name,
      quantity: quantity,
      price: price,
    );
  }
}
