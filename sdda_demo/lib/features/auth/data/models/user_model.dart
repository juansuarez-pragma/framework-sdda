import '../../domain/entities/user.dart';

/// Model para User con serialización JSON.
class UserModel extends User {

  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.avatarUrl,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, Object?> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
    );
  }
}
