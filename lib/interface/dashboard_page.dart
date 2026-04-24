import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import 'widgets/category_card.dart';
import 'widgets/system_item_card.dart';
import '../core/app_colors.dart';

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
    final auth = context.watch<AuthProvider>();
    final dashboard = context.watch<DashboardProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: dashboard.isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboard.error != null || dashboard.dashboardData == null
          ? _buildErrorView(context, dashboard, user.token)
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isDesktop = constraints.maxWidth > 900;
                  return Row(
                    children: [
                      // Left Sidebar / Category List
                      Container(
                        width: isDesktop ? 400 : constraints.maxWidth,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            _buildUserHeader(user.fullName, auth),
                            const SizedBox(height: 40),
                            const Text(
                              'Application Categories',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    dashboard.dashboardData!.categories.length,
                                itemBuilder: (context, index) {
                                  final category = dashboard
                                      .dashboardData!
                                      .categories
                                      .keys
                                      .elementAt(index);
                                  final items = dashboard
                                      .dashboardData!
                                      .categories[category]!;
                                  return CategoryCard(
                                    category: category,
                                    itemCount: items.length,
                                    isSelected:
                                        dashboard.selectedCategory == category,
                                    onTap: () {
                                      dashboard.selectCategory(category);
                                      if (!isDesktop) {
                                        _showMobileItems(
                                          context,
                                          category,
                                          items,
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right Content Area (Desktop only)
                      if (isDesktop)
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: Colors.cyan.shade50),
                            ),
                            child: dashboard.selectedCategory == null
                                ? const Center(
                                    child: Text(
                                      'Select a category to view systems',
                                    ),
                                  )
                                : _buildItemsList(
                                    dashboard.selectedCategory!,
                                    dashboard
                                        .dashboardData!
                                        .categories[dashboard
                                        .selectedCategory]!,
                                  ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
    );
  }

  Widget _buildUserHeader(String name, AuthProvider auth) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Icon(Icons.person_rounded, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back,',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => auth.logout(),
          icon: const Icon(Icons.logout_rounded, color: AppColors.error),
          tooltip: 'Logout',
        ),
      ],
    );
  }

  Widget _buildItemsList(String category, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Row(
            children: [
              Text(
                category.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${items.length} Systems',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return SystemItemCard(item: items[index]);
            },
          ),
        ),
      ],
    );
  }

  void _showMobileItems(
    BuildContext context,
    String category,
    List<dynamic> items,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(child: _buildItemsList(category, items)),
          ],
        ),
      ),
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
