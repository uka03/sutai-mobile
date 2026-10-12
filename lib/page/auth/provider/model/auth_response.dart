import 'package:json_annotation/json_annotation.dart';
import 'package:sutai/core/model/base_response.dart';
part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse extends BaseResponse {
  final String? token;
  @JsonKey(name: "token_type")
  final String? tokenType;
  final UserResponse? user;

  AuthResponse({this.token, this.tokenType, this.user, required super.message});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class UserResponse {
  final int? id;
  final String? name;
  final String? email;
  @JsonKey(name: "is_admin")
  final bool? isAdmin;

  UserResponse({this.email, this.id, this.isAdmin, this.name});

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
