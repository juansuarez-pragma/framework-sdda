import '../../domain/entities/demo_item.dart';

/// Model para DemoItem con serialización JSON.
class DemoItemModel extends DemoItem {

  const DemoItemModel({
    required super.id,
    required super.title,
  });

  factory DemoItemModel.fromJson(Map<String, Object?> json) {
    return DemoItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

  DemoItem toEntity() {
    return DemoItem(
      id: id,
      title: title,
    );
  }
}
