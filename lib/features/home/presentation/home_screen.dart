import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/utils/localized_text.dart';
import '../../auth/application/auth_controller.dart';
import '../../cart/application/cart_controller.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/presentation/product_card.dart';
import '../../notifications/application/notifications_providers.dart';

final _selectedCategoryProvider = StateProvider<String?>((ref) => null);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider.select((s) => s.user));
    final categories = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(_selectedCategoryProvider);
    final products = ref.watch(productsProvider(ProductsFilter(categoryId: selectedCategoryId)));
    final cartCount = ref.watch(cartControllerProvider).value?.items.length ?? 0;
    final unreadCount = ref.watch(unreadCountProvider).value ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () => context.push('/favorites')),
          IconButton(icon: const Icon(Icons.receipt_long_outlined), onPressed: () => context.push('/orders')),
          _BadgedIcon(
            icon: Icons.notifications_outlined,
            count: unreadCount,
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () => context.push('/ar-tryon')),
          _BadgedIcon(
            icon: Icons.shopping_bag_outlined,
            count: cartCount,
            onPressed: () => context.push('/cart'),
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: () => ref.read(authControllerProvider.notifier).logout()),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(categoriesProvider);
          ref.invalidate(productsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (user != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text('${'welcome'.tr()}, ${user.userName} 👋', style: Theme.of(context).textTheme.titleMedium),
              ),
            SizedBox(
              height: 42,
              child: categories.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('$e'),
                data: (items) => ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CategoryChip(label: 'all'.tr(), selected: selectedCategoryId == null, onTap: () => ref.read(_selectedCategoryProvider.notifier).state = null),
                    for (final c in items)
                      _CategoryChip(
                        label: localized(context, ar: c.nameAr, en: c.nameEn),
                        selected: selectedCategoryId == c.id,
                        onTap: () => ref.read(_selectedCategoryProvider.notifier).state = c.id,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            products.when(
              loading: () => const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator())),
              error: (e, _) => Padding(padding: const EdgeInsets.all(32), child: Text('$e')),
              data: (items) => GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.7,
                children: [for (final p in items) ProductCard(product: p)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgedIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onPressed;
  const _BadgedIcon({required this.icon, required this.count, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(icon: Icon(icon), onPressed: onPressed),
        if (count > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(20)),
              child: Text('$count', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap()),
    );
  }
}
