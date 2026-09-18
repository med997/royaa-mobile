import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/utils/localized_text.dart';
import '../../auth/application/auth_controller.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/presentation/product_card.dart';
import '../../notifications/application/notifications_providers.dart';
import '../../orders/application/orders_providers.dart';

final _selectedCategoryProvider = StateProvider<String?>((ref) => null);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(categoriesProvider);
            ref.invalidate(brandsProvider);
            ref.invalidate(productsProvider);
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              _HomeHeader(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _BannerCarousel(),
                    SizedBox(height: 18),
                    _CategoriesSection(),
                    SizedBox(height: 18),
                    _BrandsSection(),
                    SizedBox(height: 18),
                    _OffersSection(),
                    _ReorderCard(),
                    _ProductsSection(titleKey: 'new_arrivals', sort: _ProductSort.newest),
                    SizedBox(height: 18),
                    _ProductsSection(titleKey: 'best_sellers', sort: _ProductSort.bestSellers),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends ConsumerWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider.select((s) => s.user));
    final unreadCount = ref.watch(unreadCountProvider).value ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('good_morning'.tr(), style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              Text('${user?.userName ?? ''} 👋', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            ],
          ),
          Row(
            children: [
              _HeaderIcon(icon: Icons.search, onTap: () => context.push('/search')),
              const SizedBox(width: 8),
              _HeaderIcon(
                icon: Icons.notifications_outlined,
                badge: unreadCount,
                onTap: () => context.push('/notifications'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final int badge;
  const _HeaderIcon({required this.icon, required this.onTap, this.badge = 0});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Icon(icon, size: 20),
            if (badge > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                  child: Text('$badge', style: const TextStyle(fontSize: 8, color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BannerCarousel extends StatefulWidget {
  const _BannerCarousel();

  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  final _controller = PageController();
  int _page = 0;

  static const _slides = [
    (small: 'september_collection', title: 'a_frame_that_speaks', cta: 'discover_now', colors: [Color(0xFFD9E2DE), Color(0xFFF1E2DC)]),
    (small: 'season_offers', title: 'sunglasses_discount_25', cta: 'shop_now', colors: [Color(0xFFE3E9E6), Color(0xFFEBD8DA)]),
    (small: 'new_arrivals', title: 'autumn_collection', cta: 'explore', colors: [Color(0xFFDCE3E9), Color(0xFFE9DED2)]),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: slide.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(slide.small.tr(), style: const TextStyle(fontSize: 11, color: AppColors.text)),
                    const SizedBox(height: 6),
                    Text(slide.title.tr(), style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800), maxLines: 2),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(10)),
                      child: Text(slide.cta.tr(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < _slides.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _page ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(color: i == _page ? AppColors.red : AppColors.line, borderRadius: BorderRadius.circular(4)),
              ),
          ],
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text('view_all'.tr(), style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}

class _CategoriesSection extends ConsumerWidget {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final selected = ref.watch(_selectedCategoryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'browse_categories'.tr()),
        categories.when(
          loading: () => const SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
          error: (e, _) => Text('$e'),
          data: (items) => SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final c in items)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ChoiceChip(
                      label: Text(localized(context, ar: c.nameAr, en: c.nameEn)),
                      selected: selected == c.id,
                      onSelected: (_) => ref.read(_selectedCategoryProvider.notifier).state = selected == c.id ? null : c.id,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BrandsSection extends ConsumerWidget {
  const _BrandsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brands = ref.watch(brandsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'brands'.tr()),
        brands.when(
          loading: () => const SizedBox(height: 36, child: Center(child: CircularProgressIndicator())),
          error: (e, _) => Text('$e'),
          data: (items) => SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final b in items)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: AppColors.fieldFill, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
                      child: Text(b.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OffersSection extends ConsumerWidget {
  const _OffersSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider(const ProductsFilter()));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'todays_offers'.tr()),
        products.when(
          loading: () => const SizedBox(height: 90, child: Center(child: CircularProgressIndicator())),
          error: (e, _) => const SizedBox.shrink(),
          data: (items) {
            final offerItems = items.take(3).toList();
            if (offerItems.isEmpty) return const SizedBox.shrink();
            return SizedBox(
              height: 92,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final p in offerItems)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 140,
                              height: 92,
                              child: p.images.isNotEmpty
                                  ? CachedNetworkImage(imageUrl: p.images.first.url, fit: BoxFit.cover)
                                  : Container(color: AppColors.fieldFill),
                            ),
                            Positioned(
                              left: 8,
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.55), borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  localized(context, ar: p.nameAr, en: p.nameEn),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _ReorderCard extends ConsumerWidget {
  const _ReorderCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersListProvider);
    return orders.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        final last = items.first;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.fieldFill, borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.replay, color: AppColors.muted),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('reorder_last'.tr(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    Text('${'last_purchase'.tr()} · ${last.createdAt.day}/${last.createdAt.month}', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                  ],
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 36), padding: const EdgeInsets.symmetric(horizontal: 14)),
                onPressed: () => context.push('/order/${last.id}'),
                child: Text('reorder'.tr(), style: const TextStyle(fontSize: 11)),
              ),
            ],
          ),
        );
      },
    );
  }
}

enum _ProductSort { newest, bestSellers }

class _ProductsSection extends ConsumerWidget {
  final String titleKey;
  final _ProductSort sort;
  const _ProductsSection({required this.titleKey, required this.sort});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryId = ref.watch(_selectedCategoryProvider);
    final products = ref.watch(productsProvider(ProductsFilter(categoryId: selectedCategoryId)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: titleKey.tr()),
        products.when(
          loading: () => const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
          error: (e, _) => Text('$e'),
          data: (items) {
            final sorted = [...items];
            if (sort == _ProductSort.bestSellers) sorted.sort((a, b) => b.rating.compareTo(a.rating));
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.7,
              children: [for (final p in sorted) ProductCard(product: p)],
            );
          },
        ),
      ],
    );
  }
}
