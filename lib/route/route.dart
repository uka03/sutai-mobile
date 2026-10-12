import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sutai/core/components/main_scaffold.dart';
import 'package:sutai/page/auth/login.dart';
import 'package:sutai/page/auth/register.dart';
import 'package:sutai/page/auth/provider/auth_provider.dart';
import 'package:sutai/page/not_found.dart';
import 'package:sutai/page/splash.dart';
import 'package:sutai/page/product/product_page.dart';
import 'package:sutai/page/home/product_search_page.dart';
import 'package:sutai/page/cart/cart_page.dart';
import 'package:sutai/page/order/order_detail_page.dart';
import 'package:sutai/page/order/create_order_page.dart';
import 'package:sutai/page/wishlist/wishlist_page.dart';
import 'package:sutai/page/profile/change_password_page.dart';

final _publicRoutes = ['/login', '/register'];

final routeProvider = Provider<GoRouter>((ref) {
  final authNotifier = _AuthChangeNotifier(ref);
  return GoRouter(
    initialLocation: SplashPage.path,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isSplashRoute = state.matchedLocation == SplashPage.path;

      if (authState is AuthStateInitial) {
        return isSplashRoute ? null : SplashPage.path;
      }

      final isPublicRoute = _publicRoutes.contains(state.matchedLocation);
      if (authState is AuthStateAuthenticated) {
        if (isPublicRoute || isSplashRoute) {
          return MainScaffold.path;
        }
        return null;
      }

      if (isPublicRoute) return null;

      if (authState is AuthStateLoading || authState is AuthStateError) {
        return LoginPage.path;
      }

      return LoginPage.path;
    },
    routes: [
      GoRoute(
        path: SplashPage.path,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: LoginPage.path,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RegisterPage.path,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: MainScaffold.path,
        builder: (context, state) => const MainScaffold(),
      ),
      GoRoute(
        path: ProductPage.path,
        builder: (context, state) => ProductPage(
          productId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: ProductSearchPage.path,
        builder: (context, state) => ProductSearchPage(
          initialTagId: int.tryParse(state.uri.queryParameters['tag_id'] ?? ''),
          initialCategoryId: int.tryParse(
            state.uri.queryParameters['category_id'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: CartPage.path,
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: WishlistPage.path,
        builder: (context, state) => const WishlistPage(),
      ),
      GoRoute(
        path: ChangePasswordPage.path,
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: CreateOrderPage.path,
        builder: (context, state) => const CreateOrderPage(),
      ),
      GoRoute(
        path: OrderDetailPage.path,
        builder: (context, state) => OrderDetailPage(
          orderId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
});

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(Ref ref) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      notifyListeners();
    });
  }
}
