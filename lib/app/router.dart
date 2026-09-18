import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/about/presentation/about_screen.dart';
import '../features/account/presentation/account_screen.dart';
import '../features/addresses/presentation/addresses_screen.dart';
import '../features/ar_tryon/presentation/ar_tryon_screen.dart';
import '../features/auth/application/auth_status.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/otp_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/cart/presentation/cart_screen.dart';
import '../features/catalog/presentation/product_detail_screen.dart';
import '../features/checkout/presentation/checkout_screen.dart';
import '../features/favorites/presentation/favorites_screen.dart';
import '../features/measurements/presentation/measurements_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/orders/presentation/order_detail_screen.dart';
import '../features/orders/presentation/orders_list_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/splash/presentation/auth_gate.dart';
import '../features/support/presentation/support_chat_screen.dart';
import 'main_shell.dart';

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
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: '/otp',
        builder: (context, state) => OtpScreen(mobileNo: state.uri.queryParameters['mobileNo'] ?? ''),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/', builder: (context, state) => const AuthGate())]),
          StatefulShellBranch(routes: [GoRoute(path: '/cart', builder: (context, state) => const CartScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/favorites', builder: (context, state) => const FavoritesScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/account', builder: (context, state) => const AccountScreen())]),
        ],
      ),
      GoRoute(path: '/ar-tryon', builder: (context, state) => const ArTryOnScreen()),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductDetailScreen(productId: state.pathParameters['id']!),
      ),
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
      GoRoute(path: '/addresses', builder: (context, state) => const AddressesScreen()),
      GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
      GoRoute(path: '/measurements', builder: (context, state) => const MeasurementsScreen()),
      GoRoute(path: '/support', builder: (context, state) => const SupportChatScreen()),
      GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
    ],
  );
});
