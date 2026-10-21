import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

@JsonSerializable(createToJson: false)
class ApiError {
  final int status;
  final String? title;
  final String? detail;
  final Map<String, String>? errors;

  const ApiError({required this.status, this.title, this.detail, this.errors});

  factory ApiError.fromJson(Map<String, dynamic> json) => _$ApiErrorFromJson(json);
}
