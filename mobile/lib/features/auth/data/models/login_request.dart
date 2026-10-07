import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable(createFactory: false)
class LoginRequest {
  final String identifier;
  final String password;

  const LoginRequest({required this.identifier, required this.password});

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
