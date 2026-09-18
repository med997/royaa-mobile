import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/review.dart';

class ReviewsApi {
  final Dio _dio;
  const ReviewsApi(this._dio);

  Future<List<Review>> list(String productId) async {
    final res = await _dio.get('/products/$productId/reviews');
    return (res.data['data'] as List).map((e) => Review.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Review>> create(String productId, {required int rating, String? comment}) async {
    final res = await _dio.post('/products/$productId/reviews', data: {'rating': rating, if (comment != null) 'comment': comment});
    return (res.data['data'] as List).map((e) => Review.fromJson(e as Map<String, dynamic>)).toList();
  }
}

final reviewsApiProvider = Provider((ref) => ReviewsApi(ref.watch(dioProvider)));
