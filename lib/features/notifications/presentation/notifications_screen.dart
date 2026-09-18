import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../application/notifications_providers.dart';
import '../data/notifications_api.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsListProvider);
    return Scaffold(
      appBar: AppBar(title: Text('notifications'.tr())),
      body: notifications.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) => items.isEmpty
            ? Center(child: Text('no_notifications_yet'.tr(), style: const TextStyle(color: AppColors.muted)))
            : ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final n = items[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: n.isRead ? AppColors.fieldFill : AppColors.redSoft,
                      child: Icon(Icons.notifications, color: n.isRead ? AppColors.muted : AppColors.red, size: 18),
                    ),
                    title: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold)),
                    subtitle: Text(n.body),
                    onTap: () async {
                      if (!n.isRead) {
                        await ref.read(notificationsApiProvider).markRead(n.id);
                        ref.invalidate(notificationsListProvider);
                        ref.invalidate(unreadCountProvider);
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}
