// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthState _$AuthStateFromJson(Map json) => AuthState(
  accessToken: json['access_token'] as String,
  user: User.fromJson(json['user'] as Map),
);

Map<String, dynamic> _$AuthStateToJson(AuthState instance) => <String, dynamic>{
  'access_token': instance.accessToken,
  'user': instance.user.toJson(),
};
