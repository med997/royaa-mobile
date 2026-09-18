import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/catalog_api.dart';
import '../domain/brand.dart';
import '../domain/category.dart';
import '../domain/product.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) => ref.watch(catalogApiProvider).categories());
final brandsProvider = FutureProvider<List<Brand>>((ref) => ref.watch(catalogApiProvider).brands());

class ProductsFilter {
  final String? categoryId;
  final String? search;
  const ProductsFilter({this.categoryId, this.search});

  @override
  bool operator ==(Object other) =>
      other is ProductsFilter && other.categoryId == categoryId && other.search == search;

  @override
  int get hashCode => Object.hash(categoryId, search);
}

final productsProvider = FutureProvider.family<List<Product>, ProductsFilter>((ref, filter) {
  return ref.watch(catalogApiProvider).products(categoryId: filter.categoryId, search: filter.search);
});

final productProvider = FutureProvider.family<Product, String>((ref, id) => ref.watch(catalogApiProvider).product(id));
