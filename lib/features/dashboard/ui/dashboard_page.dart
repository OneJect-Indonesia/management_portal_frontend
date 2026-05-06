import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import 'mobile/dashboard_page_mobile.dart';
import 'web/dashboard_page_web.dart';
import '../../../core/theme/app_colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        context.read<DashboardProvider>().fetchData(user.token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();
    final auth = context.watch<AuthProvider>();

    if (auth.currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (dashboard.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (dashboard.error != null || dashboard.dashboardData == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: _buildErrorView(context, dashboard, auth.currentUser!.token),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return const DashboardPageWeb();
        } else {
          return const DashboardPageMobile();
        }
      },
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    DashboardProvider dashboard,
    String token,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 24),
          Text(
            dashboard.error ?? 'Failed to load dashboard',
            style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => dashboard.fetchData(token),
            style: ElevatedButton.styleFrom(minimumSize: const Size(200, 56)),
            child: const Text('Retry Connection'),
          ),
        ],
      ),
    );
  }
}
