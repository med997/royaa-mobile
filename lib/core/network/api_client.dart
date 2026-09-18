import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_storage.dart';

const _envBaseUrl = String.fromEnvironment('API_BASE_URL');

String get _resolvedBaseUrl {
  // if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
  if (!kIsWeb && Platform.isAndroid) return 'http://192.168.8.114:3000';
  return 'http://192.168.8.114:3000';
}

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: _resolvedBaseUrl, connectTimeout: const Duration(seconds: 10)));
  final tokenStorage = ref.watch(tokenStorageProvider);

  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    final token = await tokenStorage.read();
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }));

  return dio;
});
