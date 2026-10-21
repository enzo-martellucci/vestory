import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable(createToJson: false)
class AuthResponse {
  final String accessToken;
  final String refreshToken;

  const AuthResponse({required this.accessToken, required this.refreshToken});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
}
