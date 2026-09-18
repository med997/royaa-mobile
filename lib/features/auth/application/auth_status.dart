import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthStatusNotifier extends ValueNotifier<AuthStatus> {
  AuthStatusNotifier() : super(AuthStatus.unknown);
}

final authStatusNotifierProvider = Provider((ref) => AuthStatusNotifier());
