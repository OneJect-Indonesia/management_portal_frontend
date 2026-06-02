import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../widgets/honeycomb_menu.dart';
import '../widgets/user_header_sidebar.dart';
import '../../../../core/theme/app_colors.dart';

class DashboardPageWeb extends StatelessWidget {
  const DashboardPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final dashboard = context.watch<DashboardProvider>();

    final allItems = dashboard.dashboardData!.categories.values
        .expand((list) => list)
        .toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.honeycombBg1,
              AppColors.honeycombBg3,
              AppColors.honeycombBg2,
            ],
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Glassmorphic Left Sidebar
              UserHeaderSidebar(auth: auth),

              // Centered Honeycomb Menu
              Expanded(
                child: Center(
                  child: HoneycombMenu(
                    items: allItems,
                    hexSize: 110.0,
                    gap: 12.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
