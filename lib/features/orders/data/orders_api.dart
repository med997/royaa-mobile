import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/order.dart';

class OrdersApi {
  final Dio _dio;
  const OrdersApi(this._dio);

  Future<List<OrderSummary>> list() async {
    final res = await _dio.get('/orders');
    return (res.data['data'] as List).map((e) => OrderSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<OrderDetail> get(String id) async {
    final res = await _dio.get('/orders/$id');
    return OrderDetail.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<OrderDetail> checkout({
    required String addressId,
    required String deliveryMethod,
    required String paymentMethod,
  }) async {
    final res = await _dio.post('/orders', data: {
      'addressId': addressId,
      'deliveryMethod': deliveryMethod,
      'paymentMethod': paymentMethod,
    });
    return OrderDetail.fromJson(res.data['data'] as Map<String, dynamic>);
  }
}

final ordersApiProvider = Provider((ref) => OrdersApi(ref.watch(dioProvider)));
