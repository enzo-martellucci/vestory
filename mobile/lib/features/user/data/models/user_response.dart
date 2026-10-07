import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@JsonSerializable(createToJson: false)
class UserResponse {
  final String id;
  final String username;
  final String email;

  const UserResponse({required this.id, required this.username, required this.email});

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
}
