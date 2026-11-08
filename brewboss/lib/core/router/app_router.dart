import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/application/auth_rules.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/profile_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/barista/presentation/barista_queue_screen.dart';
import '../../features/customer/presentation/customer_menu_screen.dart';
import '../../features/customer/presentation/customer_order_status_screen.dart';
import '../../features/customer/presentation/table_management_screen.dart';
import '../../features/inventory/presentation/ingredient_screen.dart';
import '../../features/inventory/presentation/stock_history_screen.dart';
import '../../features/loyalty/presentation/loyalty_screen.dart';
import '../../features/menu/presentation/menu_screen.dart';
import '../../features/menu/presentation/product_form_screen.dart';
import '../../features/pos/presentation/order_editor_screen.dart';
import '../../features/pos/presentation/payment_screen.dart';
import '../../features/pos/presentation/table_map_screen.dart';
import '../../features/reports/presentation/dashboard_screen.dart';
import '../../features/reports/presentation/order_history_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/staff/presentation/my_shift_screen.dart';
import '../../features/staff/presentation/shift_history_screen.dart';
import '../../features/staff/presentation/staff_list_screen.dart';
import '../firebase_providers.dart';
import '../utils/date_range.dart';
import 'routes.dart';

/// Refreshes the router when the session or profile changes, so a deactivated
/// or re-roled user is moved immediately (SDS 4.1.4).
class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, _) => notifyListeners());
    _ref.listen(currentUserProvider, (_, next) {
      if (next.valueOrNull?.isActive == false) _ref.read(authProvider).signOut();
      notifyListeners();
    });
  }
  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final location = state.uri.path;
    if (location == '/c' || location.startsWith('/c/')) return null;

    final isAuthScreen = location == Routes.login || location == Routes.forgotPassword;
    final auth = _ref.read(authStateProvider);
    final profile = _ref.read(currentUserProvider);
    final authUser = auth.valueOrNull;
    final staffSignedIn = authUser != null && !authUser.isAnonymous;

    if (auth.isLoading || (staffSignedIn && profile.isLoading)) {
      return isAuthScreen || location == Routes.splash ? null : Routes.splash;
    }
    final user = profile.valueOrNull;
    if (!staffSignedIn || user == null || !user.isActive) {
      return isAuthScreen ? null : Routes.login;
    }
    if (isAuthScreen || location == Routes.splash) return homeRouteFor(user.role);
    return canOpen(user.role, location) ? null : homeRouteFor(user.role);
  }
}

DateRange? _rangeFrom(GoRouterState state) {
  final from = DateTime.tryParse(state.uri.queryParameters['from'] ?? '');
  final to = DateTime.tryParse(state.uri.queryParameters['to'] ?? '');
  return from == null || to == null ? null : DateRange(from, to);
}

GoRoute _page(String path, Widget Function(GoRouterState state) builder) =>
    GoRoute(path: path, builder: (_, state) => builder(state));

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);
  ref.onDispose(notifier.dispose);
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      _page(Routes.splash, (_) => const SplashScreen()),
      _page(Routes.login, (_) => const LoginScreen()),
      _page(Routes.forgotPassword, (_) => const ForgotPasswordScreen()),
      _page(Routes.profile, (_) => const ProfileScreen()),
      _page(Routes.shift, (s) => MyShiftScreen(logoutAfter: s.uri.queryParameters['logout'] == '1')),
      _page(Routes.manager, (_) => const DashboardScreen()),
      _page(Routes.staff, (_) => const StaffListScreen()),
      _page(Routes.shifts, (_) => const ShiftHistoryScreen()),
      _page(Routes.menu, (_) => const MenuScreen()),
      _page('${Routes.menu}/:id', (s) => ProductFormScreen(productId: s.pathParameters['id']!)),
      _page(Routes.inventory, (_) => const IngredientScreen()),
      _page('${Routes.inventory}/:id', (s) => StockHistoryScreen(ingredientId: s.pathParameters['id']!)),
      _page(Routes.tables, (_) => const TableManagementScreen()),
      _page(Routes.reports, (_) => const ReportsScreen()),
      _page(Routes.orders, (s) => OrderHistoryScreen(initialRange: _rangeFrom(s))),
      _page(Routes.loyalty, (_) => const LoyaltyScreen()),
      _page(Routes.pos, (_) => const TableMapScreen()),
      _page('${Routes.pos}/order/:id', (s) => OrderEditorScreen(
            orderId: s.pathParameters['id']!,
            tableId: s.uri.queryParameters['table'],
          )),
      _page('${Routes.pos}/order/:id/pay', (s) => PaymentScreen(orderId: s.pathParameters['id']!)),
      _page(Routes.barista, (_) => const BaristaQueueScreen()),
      _page('/c/:tableId', (s) => CustomerMenuScreen(tableId: s.pathParameters['tableId']!)),
      _page('/c/:tableId/order/:id', (s) => CustomerOrderStatusScreen(
            tableId: s.pathParameters['tableId']!,
            orderId: s.pathParameters['id']!,
          )),
    ],
  );
});
