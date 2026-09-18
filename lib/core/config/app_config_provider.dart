import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../network/api_response.dart';
import 'app_config.dart';

final appConfigProvider = FutureProvider<AppConfig>((ref) async {
  final dio = ref.watch(dioProvider);
  final res = await dio.get('/config');
  final wrapped = ApiResponse<AppConfig>.fromJson(
    res.data as Map<String, dynamic>,
    (data) => AppConfig.fromJson(data as Map<String, dynamic>),
  );
  return wrapped.data;
});
