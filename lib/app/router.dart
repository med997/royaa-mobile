import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/ar_tryon/presentation/ar_tryon_screen.dart';
import '../features/auth/application/auth_status.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/otp_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/cart/presentation/cart_screen.dart';
import '../features/catalog/presentation/product_detail_screen.dart';
import '../features/checkout/presentation/checkout_screen.dart';
import '../features/favorites/presentation/favorites_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/orders/presentation/order_detail_screen.dart';
import '../features/orders/presentation/orders_list_screen.dart';
import '../features/splash/presentation/auth_gate.dart';

const _authRoutes = {'/login', '/register', '/otp'};

final appRouterProvider = Provider<GoRouter>((ref) {
  final statusNotifier = ref.watch(authStatusNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: statusNotifier,
    redirect: (context, state) {
      final status = statusNotifier.value;
      final onAuthRoute = _authRoutes.contains(state.matchedLocation);
      if (status == AuthStatus.unauthenticated && !onAuthRoute) return '/login';
      if (status == AuthStatus.authenticated && onAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const AuthGate()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: '/otp',
        builder: (context, state) => OtpScreen(mobileNo: state.uri.queryParameters['mobileNo'] ?? ''),
      ),
      GoRoute(path: '/ar-tryon', builder: (context, state) => const ArTryOnScreen()),
      GoRoute(path: '/favorites', builder: (context, state) => const FavoritesScreen()),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductDetailScreen(productId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
      GoRoute(path: '/checkout', builder: (context, state) => const CheckoutScreen()),
      GoRoute(path: '/orders', builder: (context, state) => const OrdersListScreen()),
      GoRoute(
        path: '/order/:id',
        builder: (context, state) => OrderDetailScreen(
          orderId: state.pathParameters['id']!,
          justPlaced: state.uri.queryParameters['justPlaced'] == 'true',
        ),
      ),
      GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
    ],
  );
});
