import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/presentation/product_card.dart';

final _searchQueryProvider = StateProvider<String>((ref) => '');

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(_searchQueryProvider);
    final results = ref.watch(productsProvider(ProductsFilter(search: query.isEmpty ? null : query)));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'search_hint'.tr(),
            prefixIcon: const Icon(Icons.search, size: 20),
            filled: true,
            fillColor: AppColors.fieldFill,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            isDense: true,
          ),
          onChanged: (v) => ref.read(_searchQueryProvider.notifier).state = v,
        ),
      ),
      body: results.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${items.length} ${'results_found'.tr()}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              const SizedBox(height: 12),
              Expanded(
                child: items.isEmpty
                    ? Center(child: Text('no_results'.tr(), style: const TextStyle(color: AppColors.muted)))
                    : GridView.count(
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
      ),
    );
  }
}
