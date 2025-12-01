import 'package:flutter_test/flutter_test.dart';

import 'package:sdda_demo/features/orders/data/models/order_item_model.dart';
import 'package:sdda_demo/features/orders/data/models/order_model.dart';
import 'package:sdda_demo/features/orders/domain/entities/order.dart';
import 'package:sdda_demo/features/orders/domain/entities/order_item.dart';

void main() {
  group('OrderItemModel', () {
    test('fromJson/toJson/toEntity conserva datos', () {
      final json = <String, Object?>{
        'id': 'item1',
        'name': 'Item',
        'quantity': 2,
        'price': 10.5,
      };

      final model = OrderItemModel.fromJson(json);
      expect(model.id, 'item1');
      expect(model.quantity, 2);

      final backToJson = model.toJson();
      expect(backToJson, json);

      final entity = model.toEntity();
      expect(entity, isA<OrderItem>());
      expect(entity.id, 'item1');
    });
  });

  group('OrderModel', () {
    test('fromJson/toJson/toEntity conserva datos con items', () {
      final itemJson = <String, Object?>{
        'id': 'item1',
        'name': 'Item',
        'quantity': 2,
        'price': 10.5,
      };
      final json = <String, Object?>{
        'id': 'order1',
        'items': [itemJson],
        'total': 21.0,
        'createdAt': DateTime(2024, 1, 1).toIso8601String(),
      };

      final model = OrderModel.fromJson(json);
      expect(model.id, 'order1');
      expect(model.items.length, 1);
      expect(model.total, 21.0);

      final backToJson = model.toJson();
      expect(backToJson['id'], 'order1');
      expect(backToJson['total'], 21.0);

      final entity = model.toEntity();
      expect(entity, isA<Order>());
      expect(entity.items.first.id, 'item1');
    });
  });
}
