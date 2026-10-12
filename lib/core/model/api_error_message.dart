import 'package:dio/dio.dart';
import 'package:sutai/core/model/base_response.dart';

String apiErrorMessage(Object? error, String fallback) {
  if (error is! DioException) return fallback;

  final data = error.response?.data;
  if (data is! Map) return fallback;

  final message = BaseResponse.fromJson(
    Map<String, dynamic>.from(data),
  ).message;
  return message?.isNotEmpty == true ? message! : fallback;
}
