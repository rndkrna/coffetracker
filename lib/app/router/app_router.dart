import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/app_routes.dart';
import '../../screens/splash_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/history_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/stats_screen.dart';
import '../../screens/add_transaction_screen.dart';
import '../../screens/scan_receipt_screen.dart';

import '../../features/coffeeshop_finder/presentation/screens/coffeeshop_finder_screen.dart';
import '../../features/coffeeshop_finder/presentation/screens/detail_coffeeshop_screen.dart';
import '../../screens/recommendation_screen.dart';
import '../../features/recommendation/presentation/screens/guided_search_screen.dart';
import '../../features/recommendation/presentation/screens/recommendation_result_screen.dart';
import '../../features/recommendation/presentation/screens/detail_menu_screen.dart';
import '../../features/recommendation/providers/recommendation_provider.dart';
import '../../screens/add_coffee_shop_screen.dart';
import '../../screens/detail_transaction_screen.dart';
import '../../screens/budget_detail_screen.dart';
import '../../screens/edit_budget_screen.dart';
import '../../screens/notification_screen.dart';
import '../../screens/favorites_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/profile/preferences_screen.dart';
import '../../screens/profile/privacy_location_screen.dart';
import 'shell_scaffold.dart';

/// Global navigator keys for shell & root navigation
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

bool _hasActiveSupabaseSession() {
  try {
    return Supabase.instance.client.auth.currentSession != null;
  } catch (_) {
    return false;
  }
}

/// Creates the app [GoRouter] configuration.
///
/// - Splash, login, register are top-level routes (no bottom nav).
/// - Main tabs (home, history, finder, recommendations, settings) are
///   wrapped in a [ShellRoute] with [ShellScaffold] for persistent bottom nav.
/// - Overlay screens (add, scan, detail, add-shop) push above the shell.
GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: kDebugMode,

    // ── Auth redirect ──────────────────────────────────────────────────
    redirect: (context, state) {
      final currentPath = state.matchedLocation;

      // If on splash, don't redirect – let splash handle its own navigation.
      // This also keeps widget tests safe when Supabase is not initialized.
      if (currentPath == AppRoutes.splash) return null;

      final isLoggedIn = _hasActiveSupabaseSession();

      // Routes that don't require auth
      const publicRoutes = [
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.register,
      ];

      final isPublicRoute = publicRoutes.contains(currentPath);

      // Not logged in and trying to access protected route → login
      if (!isLoggedIn && !isPublicRoute) return AppRoutes.login;

      // Logged in and trying to access login/register → home
      if (isLoggedIn &&
          (currentPath == AppRoutes.login ||
              currentPath == AppRoutes.register)) {
        return AppRoutes.home;
      }

      return null; // No redirect needed
    },

    routes: [
      // ── Public top-level routes ────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // ── Shell route (bottom navigation) ────────────────────────────────
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.transactions,
            name: 'transactions',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HistoryScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.finder,
            name: 'finder',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CoffeeshopFinderScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.recommendations,
            name: 'recommendations',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RecommendationScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),

      // ── Overlay routes (push above shell, no bottom nav) ──────────────
      GoRoute(
        path: AppRoutes.statistics,
        name: 'statistics',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const StatsScreen(),
      ),
      GoRoute(
        path: AppRoutes.budget,
        name: 'budget',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const BudgetDetailScreen(),
      ),
      GoRoute(
        path: AppRoutes.editBudget,
        name: 'editBudget',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const EditBudgetScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.favorites,
        name: 'favorites',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: AppRoutes.addTransaction,
        name: 'addTransaction',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          // Support optional editTransaction passed via extra
          final editTx = state.extra as dynamic;
          if (editTx != null) {
            return AddTransactionScreen(editTransaction: editTx);
          }
          return const AddTransactionScreen();
        },
      ),
      GoRoute(
        path: '${AppRoutes.transactionDetail}/:id',
        name: 'transactionDetail',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final txId = state.pathParameters['id']!;
          return DetailTransactionScreen(transactionId: txId);
        },
      ),
      GoRoute(
        path: AppRoutes.ocrScan,
        name: 'ocrScan',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ScanReceiptScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.coffeeshopDetail}/:id',
        name: 'coffeeshopDetail',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final shopId = state.pathParameters['id']!;
          return DetailCoffeeshopScreen(id: shopId);
        },
      ),
      GoRoute(
        path: AppRoutes.addShop,
        name: 'addShop',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AddCoffeeShopScreen(),
      ),
      GoRoute(
        path: AppRoutes.guidedSearch,
        name: 'guidedSearch',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const GuidedSearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.recommendationResults,
        name: 'recommendationResults',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final results = state.extra as List<RecommendationResult>?;
          return RecommendationResultScreen(results: results);
        },
      ),
      GoRoute(
        path: '${AppRoutes.menuDetail}/:id',
        name: 'menuDetail',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final resultData = state.extra as RecommendationResult?;
          return DetailMenuScreen(id: id, resultData: resultData);
        },
      ),

      // ── Legacy aliases for backward compatibility ─────────────────────
      GoRoute(
        path: AppRoutes.legacyAdd,
        name: 'legacyAdd',
        parentNavigatorKey: rootNavigatorKey,
        redirect: (_, __) => AppRoutes.addTransaction,
      ),
      GoRoute(
        path: AppRoutes.legacyScan,
        name: 'legacyScan',
        parentNavigatorKey: rootNavigatorKey,
        redirect: (_, __) => AppRoutes.ocrScan,
      ),
      GoRoute(
        path: AppRoutes.legacyRecommendation,
        name: 'legacyRecommendation',
        redirect: (_, __) => AppRoutes.recommendations,
      ),
      // Legacy '/main' → redirect to home
      GoRoute(
        path: AppRoutes.main,
        name: 'legacyMain',
        redirect: (_, __) => AppRoutes.home,
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'editProfile',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.preferences,
        name: 'preferences',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PreferencesScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacyLocation,
        name: 'privacyLocation',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PrivacyLocationScreen(),
      ),
    ],
  );
}
