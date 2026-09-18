import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/domain/product.dart';
import '../data/favorites_api.dart';

final favoritesListProvider = FutureProvider<List<Product>>((ref) => ref.watch(favoritesApiProvider).list());

class FavoriteIdsController extends StateNotifier<AsyncValue<Set<String>>> {
  final FavoritesApi _api;
  final Ref _ref;

  FavoriteIdsController(this._api, this._ref) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = await AsyncValue.guard(() async => (await _api.list()).map((p) => p.id).toSet());
  }

  Future<void> toggle(String productId) async {
    final current = state.value ?? <String>{};
    final wasFavorite = current.contains(productId);
    final optimistic = {...current};
    wasFavorite ? optimistic.remove(productId) : optimistic.add(productId);
    state = AsyncValue.data(optimistic);

    try {
      wasFavorite ? await _api.remove(productId) : await _api.add(productId);
      _ref.invalidate(favoritesListProvider);
    } catch (_) {
      state = AsyncValue.data(current);
    }
  }
}

final favoriteIdsProvider = StateNotifierProvider<FavoriteIdsController, AsyncValue<Set<String>>>((ref) {
  return FavoriteIdsController(ref.watch(favoritesApiProvider), ref);
});
