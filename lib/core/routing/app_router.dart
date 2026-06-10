import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/ui/login_page.dart';
import '../../features/auth/ui/splash_page.dart';
import '../../features/dashboard/ui/dashboard_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter? _instance;

  static GoRouter router(AuthProvider authProvider) {
    _instance ??= GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/splash',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isInitialized = authProvider.isInitialized;
        final isAuthenticated = authProvider.isAuthenticated;
        final isLoggingIn = state.matchedLocation == '/login';
        final isSplashing = state.matchedLocation == '/splash';

        // 1. Wait for initialization
        if (!isInitialized) {
          return '/splash';
        }

        // 2. If initialized and on splash, decide where to go
        if (isSplashing) {
          return isAuthenticated ? '/dashboard' : '/login';
        }

        // 3. Normal Route Guarding
        if (!isAuthenticated) {
          return isLoggingIn ? null : '/login';
        }

        if (isLoggingIn) {
          return '/dashboard';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      ],
    );
    return _instance!;
  }
}
