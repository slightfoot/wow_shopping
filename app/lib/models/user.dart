import 'package:common/common.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  const User({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  static const none = User(id: '', name: '');

  static User fromDto(UserDto dto) {
    return User(
      id: dto.id,
      name: dto.name,
    );
  }

  static User fromJson(Map json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() => '${describeIdentity(this)}{${toJson()}}';
}
