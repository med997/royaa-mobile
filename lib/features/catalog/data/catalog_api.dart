import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/brand.dart';
import '../domain/category.dart';
import '../domain/product.dart';

class CatalogApi {
  final Dio _dio;
  const CatalogApi(this._dio);

  Future<List<Category>> categories() async {
    final res = await _dio.get('/categories');
    return (res.data['data'] as List).map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Brand>> brands() async {
    final res = await _dio.get('/brands');
    return (res.data['data'] as List).map((e) => Brand.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Product>> products({String? categoryId, String? brandId, String? search}) async {
    final res = await _dio.get('/products', queryParameters: {
      if (categoryId != null) 'categoryId': categoryId,
      if (brandId != null) 'brandId': brandId,
      if (search != null && search.isNotEmpty) 'search': search,
    });
    return (res.data['data'] as List).map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Product> product(String id) async {
    final res = await _dio.get('/products/$id');
    return Product.fromJson(res.data['data'] as Map<String, dynamic>);
  }
}

final catalogApiProvider = Provider((ref) => CatalogApi(ref.watch(dioProvider)));
