import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/utils/localized_text.dart';
import '../../favorites/application/favorites_controller.dart';
import '../domain/product.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoriteIdsProvider).value ?? <String>{};
    final isFavorite = favoriteIds.contains(product.id);
    final name = localized(context, ar: product.nameAr, en: product.nameEn);

    return InkWell(
      onTap: () => context.push('/product/${product.id}'),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.4,
                  child: product.images.isNotEmpty
                      ? CachedNetworkImage(imageUrl: product.images.first.url, fit: BoxFit.cover)
                      : Container(color: AppColors.fieldFill),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: InkWell(
                    onTap: () => ref.read(favoriteIdsProvider.notifier).toggle(product.id),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, size: 18, color: AppColors.red),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text('${product.price} ${product.currency}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
