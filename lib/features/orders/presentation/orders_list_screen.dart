import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../application/orders_providers.dart';

class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersListProvider);
    return Scaffold(
      appBar: AppBar(title: Text('my_orders'.tr())),
      body: orders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) => items.isEmpty
            ? Center(child: Text('no_orders_yet'.tr(), style: const TextStyle(color: AppColors.muted)))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final o = items[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => context.push('/order/${o.id}'),
                    title: Text('${'order_number'.tr()}${o.id.substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${o.itemCount} ${'items_count'.tr()} · ${'stage_${o.status}'.tr()}'),
                    trailing: Text('${o.total} ${o.currency}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.red)),
                  );
                },
              ),
      ),
    );
  }
}
