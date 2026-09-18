import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/notifications_api.dart';
import '../domain/app_notification.dart';

final notificationsListProvider = FutureProvider<List<AppNotification>>((ref) => ref.watch(notificationsApiProvider).list());
final unreadCountProvider = FutureProvider<int>((ref) => ref.watch(notificationsApiProvider).unreadCount());
