import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../catalog/presentation/product_card.dart';
import '../application/favorites_controller.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesListProvider);
    return Scaffold(
      appBar: AppBar(title: Text('favorites'.tr())),
      body: favorites.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) => items.isEmpty
            ? Center(child: Text('no_favorites_yet'.tr(), style: const TextStyle(color: AppColors.muted)))
            : GridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.7,
                children: [for (final p in items) ProductCard(product: p)],
              ),
      ),
    );
  }
}
