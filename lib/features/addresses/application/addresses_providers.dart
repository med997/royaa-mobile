import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/addresses_api.dart';
import '../domain/address.dart';

final addressesProvider = FutureProvider<List<Address>>((ref) => ref.watch(addressesApiProvider).list());
