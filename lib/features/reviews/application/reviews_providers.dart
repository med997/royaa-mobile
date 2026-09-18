import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/reviews_api.dart';
import '../domain/review.dart';

final reviewsProvider = FutureProvider.family<List<Review>, String>((ref, productId) => ref.watch(reviewsApiProvider).list(productId));
