import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  const UserDto({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  static const none = UserDto(id: '', name: '');

  static UserDto fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  @override
  String toString() => 'UserDto{${toJson()}}';
}
