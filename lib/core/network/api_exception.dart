import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

ApiException mapDioError(DioException e) {
  final data = e.response?.data;
  if (data is Map && (data['errorMessage'] as String?)?.isNotEmpty == true) {
    return ApiException(data['errorMessage'] as String);
  }
  return ApiException(e.message ?? 'Network error');
}
