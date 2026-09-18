import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/utils/localized_text.dart';
import '../application/orders_providers.dart';
import '../domain/order.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;
  final bool justPlaced;
  const OrderDetailScreen({super.key, required this.orderId, this.justPlaced = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderDetailProvider(orderId));
    return Scaffold(
      appBar: AppBar(title: Text('order'.tr())),
      body: order.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (o) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (justPlaced) ...[
              const CircleAvatar(radius: 32, backgroundColor: Color(0xFFE5EFE9), child: Icon(Icons.check, color: AppColors.green, size: 32)),
              const SizedBox(height: 14),
              Text('order_received'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
            ],
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Row(label: 'total_label'.tr(), value: '${o.total} ${o.currency}', bold: true),
                  const SizedBox(height: 6),
                  _Row(label: 'delivering_to'.tr(), value: o.addressLabel),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('tracking'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            _Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(children: [for (final stage in o.timeline) _TimelineRow(stage: stage)]),
              ),
            ),
            const SizedBox(height: 24),
            Text('items'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            _Card(
              child: Column(
                children: [
                  for (final item in o.items)
                    ListTile(
                      title: Text(localized(context, ar: item.nameAr, en: item.nameEn)),
                      subtitle: item.colorNameEn != null
                          ? Text(localized(context, ar: item.colorNameAr ?? item.colorNameEn!, en: item.colorNameEn!))
                          : null,
                      trailing: Text('x${item.quantity}  ${item.lineTotal} ${o.currency}'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (justPlaced) FilledButton(onPressed: () => context.go('/'), child: Text('back_to_home'.tr())),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _Row({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.muted)),
        Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: bold ? 18 : 14)),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
      child: child,
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final OrderTimelineStage stage;
  const _TimelineRow({required this.stage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            stage.done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: stage.done ? AppColors.green : AppColors.line,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'stage_${stage.stage}'.tr(),
              style: TextStyle(color: stage.done ? AppColors.text : AppColors.muted, fontWeight: stage.done ? FontWeight.w700 : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
