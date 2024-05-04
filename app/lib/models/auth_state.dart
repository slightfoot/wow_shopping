import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wow_shopping/models/user.dart';

part 'auth_state.g.dart';

@JsonSerializable()
class AuthState extends Equatable {
  const AuthState({
    required this.accessToken,
    required this.user,
  });

  final String accessToken;
  final User user;

  static const none = AuthState(accessToken: '', user: User.none);

  static AuthState fromJson(Map<String, dynamic> json) {
    return _$AuthStateFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AuthStateToJson(this);

  @override
  List<Object?> get props => [accessToken, user];
}
