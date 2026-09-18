import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/orders_api.dart';
import '../domain/order.dart';

final ordersListProvider = FutureProvider<List<OrderSummary>>((ref) => ref.watch(ordersApiProvider).list());
final orderDetailProvider = FutureProvider.family<OrderDetail, String>((ref, id) => ref.watch(ordersApiProvider).get(id));
