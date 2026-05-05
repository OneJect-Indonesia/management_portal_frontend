import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/ui/login_page.dart';
import 'features/dashboard/ui/dashboard_page.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/dashboard/providers/dashboard_provider.dart';
import 'features/auth/repositories/auth_repository.dart';
import 'features/dashboard/repositories/dashboard_repository.dart';
import 'features/auth/services/auth_service.dart';
import 'features/dashboard/services/dashboard_service.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<DashboardService>(create: (_) => DashboardService()),
        
        // Repositories
        ProxyProvider<AuthService, AuthRepository>(
          update: (_, service, __) => AuthRepository(service),
        ),
        ProxyProvider<DashboardService, DashboardRepository>(
          update: (_, service, __) => DashboardRepository(service),
        ),
        
        // Providers
        ChangeNotifierProxyProvider<AuthRepository, AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
          update: (_, repo, prev) => prev ?? AuthProvider(repo),
        ),
        ChangeNotifierProxyProvider<DashboardRepository, DashboardProvider>(
          create: (context) => DashboardProvider(context.read<DashboardRepository>()),
          update: (_, repo, prev) => prev ?? DashboardProvider(repo),
        ),
      ],
      child: MaterialApp(
        title: 'Application Portal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.checkSession();

    final user = authProvider.currentUser;

    if (user != null) {
      // Use provider to fetch data instead of direct service call
      await context.read<DashboardProvider>().fetchData(user.token);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isAuthenticated) {
          return const DashboardPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
