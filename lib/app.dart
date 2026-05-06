import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/providers.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'features/auth/providers/auth_provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Need a temporary context or wait for providers to be ready
    // Actually, it's better to let AuthProvider handle its own initial state
    // or call it after MultiProvider is built.
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MultiProvider(
      providers: AppProviders.providers,
      builder: (context, child) {
        final authProvider = context.watch<AuthProvider>();
        
        // Ensure session is checked only once at startup
        // This is a simple way to handle it, though a splash screen is better
        return MaterialApp.router(
          title: 'Application Portal',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.router(authProvider),
        );
      },
    );
  }
}
