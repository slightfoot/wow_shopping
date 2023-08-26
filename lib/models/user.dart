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

  factory User.fromJson(Map json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() => '${describeIdentity(this)}{${toJson()}}';
}
