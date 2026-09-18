import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/utils/localized_text.dart';
import '../../cart/application/cart_controller.dart';
import '../../favorites/application/favorites_controller.dart';
import '../../reviews/presentation/reviews_section.dart';
import '../application/catalog_providers.dart';
import '../domain/product.dart';
import 'product_3d_screen.dart';
import 'product_gallery_screen.dart';

final _selectedVariantProvider = StateProvider.autoDispose.family<String?, String>((ref, productId) => null);

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productProvider(productId));
    final favoriteIds = ref.watch(favoriteIdsProvider).value ?? <String>{};

    return Scaffold(
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (product) {
          final isFavorite = favoriteIds.contains(product.id);
          final name = localized(context, ar: product.nameAr, en: product.nameEn);
          final selectedVariantId = ref.watch(_selectedVariantProvider(productId)) ??
              (product.variants.isNotEmpty ? product.variants.first.id : null);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppColors.bg,
                foregroundColor: AppColors.text,
                actions: [
                  IconButton(
                    icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: AppColors.red),
                    onPressed: () => ref.read(favoriteIdsProvider.notifier).toggle(product.id),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: GestureDetector(
                    onTap: product.images.isEmpty
                        ? null
                        : () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductGalleryScreen(product: product))),
                    child: product.images.isNotEmpty
                        ? CachedNetworkImage(imageUrl: product.images.first.url, fit: BoxFit.cover)
                        : Container(color: AppColors.fieldFill),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.brandName != null)
                        Text(product.brandName!.toUpperCase(), style: const TextStyle(color: AppColors.muted, fontSize: 12, letterSpacing: 1)),
                      Text(name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('${product.price} ${product.currency}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.red)),
                          const SizedBox(width: 14),
                          Icon(Icons.star, size: 16, color: AppColors.gold),
                          const SizedBox(width: 2),
                          Text('${product.rating} (${product.ratingCount})', style: const TextStyle(color: AppColors.muted)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      if (product.variants.isNotEmpty)
                        Row(
                          children: [
                            for (final v in product.variants)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(end: 10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () => ref.read(_selectedVariantProvider(productId).notifier).state = v.id,
                                  child: CircleAvatar(
                                    radius: 17,
                                    backgroundColor: v.id == selectedVariantId ? AppColors.red : Colors.transparent,
                                    child: CircleAvatar(
                                      radius: 13,
                                      backgroundColor: Color(int.parse(v.colorHex.replaceFirst('#', '0xFF'))),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      if (product.images.isNotEmpty)
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton.icon(
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Product3dScreen(product: product))),
                            icon: const Icon(Icons.threed_rotation, size: 16),
                            label: Text('preview_3d'.tr()),
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (product.widthMm != null)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.line)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _Measure(label: 'width'.tr(), value: '${product.widthMm} mm'),
                              _Measure(label: 'bridge'.tr(), value: '${product.bridgeMm} mm'),
                              _Measure(label: 'arm'.tr(), value: '${product.armMm} mm'),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(onPressed: () => context.push('/ar-tryon'), child: Text('try_ar'.tr())),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: () async {
                                await ref.read(cartControllerProvider.notifier).addItem(
                                      productId: product.id,
                                      variantId: selectedVariantId,
                                    );
                                if (context.mounted) _showAddedToCartSheet(context, product, name);
                              },
                              child: Text('add_to_cart'.tr()),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const Divider(),
                      const SizedBox(height: 8),
                      ReviewsSection(productId: product.id),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

void _showAddedToCartSheet(BuildContext context, Product product, String name) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 22, backgroundColor: Color(0xFFE5EFE9), child: Icon(Icons.check, color: AppColors.green)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('added_to_cart'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(name, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                  ],
                ),
              ),
              if (product.images.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(imageUrl: product.images.first.url, width: 48, height: 48, fit: BoxFit.cover),
                ),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () {
              Navigator.pop(context);
              context.push('/cart');
            },
            child: Text('view_cart'.tr()),
          ),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () => Navigator.pop(context), child: Text('continue_shopping'.tr())),
        ],
      ),
    ),
  );
}

class _Measure extends StatelessWidget {
  final String label;
  final String value;
  const _Measure({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
      ],
    );
  }
}
