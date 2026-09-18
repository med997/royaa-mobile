import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../catalog/domain/product.dart';

class FavoritesApi {
  final Dio _dio;
  const FavoritesApi(this._dio);

  Future<List<Product>> list() async {
    final res = await _dio.get('/favorites');
    return (res.data['data'] as List).map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> add(String productId) => _dio.post('/favorites', data: {'productId': productId});
  Future<void> remove(String productId) => _dio.delete('/favorites/$productId');
}

final favoritesApiProvider = Provider((ref) => FavoritesApi(ref.watch(dioProvider)));
