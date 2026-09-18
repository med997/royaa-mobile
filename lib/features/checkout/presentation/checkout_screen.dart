import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../addresses/application/addresses_providers.dart';
import '../../addresses/data/addresses_api.dart';
import '../../cart/application/cart_controller.dart';
import '../../orders/data/orders_api.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String? _addressId;
  String _deliveryMethod = 'standard';
  String _paymentMethod = 'cod';
  bool _placing = false;

  Future<void> _addAddress() async {
    final label = TextEditingController();
    final line1 = TextEditingController();
    final city = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('new_address'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: label, decoration: InputDecoration(labelText: 'label_hint'.tr())),
            TextField(controller: line1, decoration: InputDecoration(labelText: 'address'.tr())),
            TextField(controller: city, decoration: InputDecoration(labelText: 'city'.tr())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('cancel'.tr())),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text('save'.tr())),
        ],
      ),
    );
    if (saved == true && label.text.isNotEmpty && line1.text.isNotEmpty && city.text.isNotEmpty) {
      await ref.read(addressesApiProvider).create(label: label.text, line1: line1.text, city: city.text);
      ref.invalidate(addressesProvider);
    }
  }

  Future<void> _placeOrder() async {
    if (_addressId == null) return;
    setState(() => _placing = true);
    try {
      final order = await ref.read(ordersApiProvider).checkout(
            addressId: _addressId!,
            deliveryMethod: _deliveryMethod,
            paymentMethod: _paymentMethod,
          );
      ref.read(cartControllerProvider.notifier).refresh();
      if (mounted) context.pushReplacement('/order/${order.id}?justPlaced=true');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final addresses = ref.watch(addressesProvider);
    return Scaffold(
      appBar: AppBar(title: Text('checkout'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(
            title: 'delivery_address'.tr(),
            trailing: TextButton(onPressed: _addAddress, child: Text('add_short'.tr())),
          ),
          addresses.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (items) {
              if (items.isEmpty) return Text('no_addresses_yet'.tr(), style: const TextStyle(color: AppColors.muted));
              _addressId ??= items.firstWhere((a) => a.isDefault, orElse: () => items.first).id;
              return RadioGroup<String>(
                groupValue: _addressId,
                onChanged: (v) => setState(() => _addressId = v),
                child: _Card(
                  child: Column(
                    children: [
                      for (final a in items)
                        RadioListTile<String>(value: a.id, title: Text(a.label), subtitle: Text('${a.line1}, ${a.city}')),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _SectionHeader(title: 'delivery_method'.tr()),
          RadioGroup<String>(
            groupValue: _deliveryMethod,
            onChanged: (v) => setState(() => _deliveryMethod = v!),
            child: _Card(
              child: Column(
                children: [
                  RadioListTile(value: 'standard', title: Text('standard_free'.tr())),
                  RadioListTile(value: 'express', title: Text('express_tomorrow'.tr())),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _SectionHeader(title: 'payment_method'.tr()),
          RadioGroup<String>(
            groupValue: _paymentMethod,
            onChanged: (v) => setState(() => _paymentMethod = v!),
            child: _Card(
              child: Column(
                children: [
                  RadioListTile(value: 'card', title: Text('bank_card'.tr())),
                  RadioListTile(value: 'wallet', title: Text('e_wallet'.tr())),
                  RadioListTile(value: 'cod', title: Text('cash_on_delivery'.tr())),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: _addressId == null || _placing ? null : _placeOrder,
            child: _placing
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text('place_order'.tr()),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
