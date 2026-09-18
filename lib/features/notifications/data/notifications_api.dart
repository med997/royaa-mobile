import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/app_notification.dart';

class NotificationsApi {
  final Dio _dio;
  const NotificationsApi(this._dio);

  Future<List<AppNotification>> list() async {
    final res = await _dio.get('/notifications');
    return (res.data['data'] as List).map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<int> unreadCount() async {
    final res = await _dio.get('/notifications/unread-count');
    return res.data['data']['count'] as int;
  }

  Future<void> markRead(String id) => _dio.post('/notifications/$id/read');
}

final notificationsApiProvider = Provider((ref) => NotificationsApi(ref.watch(dioProvider)));
