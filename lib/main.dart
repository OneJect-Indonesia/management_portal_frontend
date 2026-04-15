import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'interface/login_page.dart';
import 'interface/dashboard_page.dart';
import 'core/dashboard_service.dart';
import 'core/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
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
      try {
        final dashboardService = DashboardService();
        await dashboardService.getDashboardData(user.token);
      } on UnauthorizedException {
        // Hanya force-logout jika token ditolak server
        await authProvider.logout();
      } catch (e) {
        // Jika internet terputus, dsb., biarkan user masuk menggunakan sesi cache
        debugPrint('[AuthWrapper] Safe exception (e.g. no internet): $e');
      }
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
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
