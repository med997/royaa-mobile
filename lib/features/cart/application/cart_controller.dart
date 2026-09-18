import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/cart_api.dart';
import '../domain/cart.dart';

class CartController extends StateNotifier<AsyncValue<Cart>> {
  final CartApi _api;
  CartController(this._api) : super(const AsyncValue.loading()) {
    refresh();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _api.fetch());
  }

  Future<void> addItem({required String productId, String? variantId, int quantity = 1}) async {
    state = await AsyncValue.guard(() => _api.addItem(productId: productId, variantId: variantId, quantity: quantity));
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    state = await AsyncValue.guard(() => _api.updateQuantity(itemId, quantity));
  }

  Future<void> removeItem(String itemId) async {
    state = await AsyncValue.guard(() => _api.removeItem(itemId));
  }
}

final cartControllerProvider = StateNotifierProvider<CartController, AsyncValue<Cart>>((ref) {
  return CartController(ref.watch(cartApiProvider));
});
