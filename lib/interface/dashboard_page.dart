import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import 'widgets/flip_category_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Gunakan postFrameCallback agar context dapat digunakan dengan baik di initState
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

    // Fallback jika user object hilang di memori
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                user.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
            },
          ),
        ],
      ),
      body: dashboard.isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboard.error != null || dashboard.dashboardData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                      const SizedBox(height: 16),
                      Text(dashboard.error ?? 'Failed to load dashboard data'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<DashboardProvider>().fetchData(user.token);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 1200
                          ? 4
                          : constraints.maxWidth > 800
                              ? 3
                              : constraints.maxWidth > 600
                                  ? 2
                                  : 1;

                      final data = dashboard.dashboardData!;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: data.categories.length,
                        itemBuilder: (context, index) {
                          final category = data.categories.keys.elementAt(index);
                          final items = data.categories[category]!;

                          return FlipCategoryCard(
                            category: category,
                            items: items,
                            cardKey: dashboard.getCardKey(category)!,
                            onCardTapped: () => context.read<DashboardProvider>().onCardTap(category),
                            onHeaderTapped: () => context.read<DashboardProvider>().onHeaderTap(category),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
