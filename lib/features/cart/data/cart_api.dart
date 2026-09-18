import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/cart.dart';

class CartApi {
  final Dio _dio;
  const CartApi(this._dio);

  Future<Cart> fetch() async {
    final res = await _dio.get('/cart');
    return Cart.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<Cart> addItem({required String productId, String? variantId, int quantity = 1}) async {
    final res = await _dio.post('/cart/items', data: {
      'productId': productId,
      if (variantId != null) 'variantId': variantId,
      'quantity': quantity,
    });
    return Cart.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<Cart> updateQuantity(String itemId, int quantity) async {
    final res = await _dio.patch('/cart/items/$itemId', data: {'quantity': quantity});
    return Cart.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<Cart> removeItem(String itemId) async {
    final res = await _dio.delete('/cart/items/$itemId');
    return Cart.fromJson(res.data['data'] as Map<String, dynamic>);
  }
}

final cartApiProvider = Provider((ref) => CartApi(ref.watch(dioProvider)));
