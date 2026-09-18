import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/utils/localized_text.dart';
import '../application/cart_controller.dart';
import '../domain/cart.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text('cart'.tr())),
      body: cart.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (data) => data.items.isEmpty
            ? Center(child: Text('cart_empty'.tr(), style: const TextStyle(color: AppColors.muted)))
            : _CartBody(cart: data),
      ),
    );
  }
}

class _CartBody extends ConsumerWidget {
  final Cart cart;
  const _CartBody({required this.cart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(cartControllerProvider.notifier);
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cart.items.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = cart.items[index];
              final name = localized(context, ar: item.product.nameAr, en: item.product.nameEn);
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: item.product.image != null
                          ? CachedNetworkImage(imageUrl: item.product.image!, fit: BoxFit.cover)
                          : Container(color: AppColors.fieldFill),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                        if (item.variant != null)
                          Text(
                            localized(context, ar: item.variant!.colorNameAr, en: item.variant!.colorNameEn),
                            style: const TextStyle(color: AppColors.muted, fontSize: 12),
                          ),
                        Row(
                          children: [
                            _QtyButton(
                              icon: Icons.remove,
                              onTap: item.quantity > 1 ? () => controller.updateQuantity(item.id, item.quantity - 1) : () => controller.removeItem(item.id),
                            ),
                            SizedBox(width: 28, child: Text('${item.quantity}', textAlign: TextAlign.center)),
                            _QtyButton(icon: Icons.add, onTap: () => controller.updateQuantity(item.id, item.quantity + 1)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text('${item.lineTotal} ${cart.currency}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.line))),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('subtotal'.tr(), style: const TextStyle(fontSize: 15, color: AppColors.muted)),
                    Text('${cart.subtotal} ${cart.currency}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 14),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.red),
                  onPressed: () => context.push('/checkout'),
                  child: Text('checkout'.tr()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 26,
        height: 26,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(color: AppColors.fieldFill, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.line)),
        child: Icon(icon, size: 14),
      ),
    );
  }
}
