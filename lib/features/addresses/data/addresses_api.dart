import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/address.dart';

class AddressesApi {
  final Dio _dio;
  const AddressesApi(this._dio);

  Future<List<Address>> list() async {
    final res = await _dio.get('/addresses');
    return (res.data['data'] as List).map((e) => Address.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> create({required String label, required String line1, required String city, bool isDefault = false}) {
    return _dio.post('/addresses', data: {'label': label, 'line1': line1, 'city': city, 'isDefault': isDefault});
  }

  Future<void> remove(String id) => _dio.delete('/addresses/$id');
}

final addressesApiProvider = Provider((ref) => AddressesApi(ref.watch(dioProvider)));
