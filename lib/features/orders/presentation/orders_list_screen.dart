import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../cart/application/cart_controller.dart';
import '../application/orders_providers.dart';
import '../data/orders_api.dart';

class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({super.key});

  Future<void> _reorder(BuildContext context, WidgetRef ref, String orderId) async {
    final order = await ref.read(ordersApiProvider).get(orderId);
    for (final item in order.items) {
      if (item.productId == null) continue;
      await ref.read(cartControllerProvider.notifier).addItem(
            productId: item.productId!,
            variantId: item.variantId,
            quantity: item.quantity,
          );
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('added_to_cart'.tr())));
      context.push('/cart');
    }
  }

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
                  final delivered = o.status == 'delivered';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () => context.push('/order/${o.id}'),
                          title: Text('${'order_number'.tr()}${o.id.substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text('${o.itemCount} ${'items_count'.tr()} · ${'stage_${o.status}'.tr()}'),
                          trailing: Text('${o.total} ${o.currency}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.red)),
                        ),
                        if (delivered)
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: OutlinedButton.icon(
                              onPressed: () => _reorder(context, ref, o.id),
                              icon: const Icon(Icons.replay, size: 16),
                              label: Text('reorder'.tr()),
                              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 34), padding: const EdgeInsets.symmetric(horizontal: 14)),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
