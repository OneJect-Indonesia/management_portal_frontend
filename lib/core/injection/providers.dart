import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/dashboard/providers/dashboard_provider.dart';
import '../../../features/auth/repositories/auth_repository.dart';
import '../../../features/dashboard/repositories/dashboard_repository.dart';
import '../../../features/auth/services/auth_service.dart';
import '../../../features/dashboard/services/dashboard_service.dart';
import '../../../data/local/session_service.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    // Services
    Provider<ISessionService>(create: (_) => SessionService()),
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
    ChangeNotifierProxyProvider2<AuthRepository, ISessionService, AuthProvider>(
      create: (context) => AuthProvider(
        context.read<AuthRepository>(),
        context.read<ISessionService>(),
      ),
      update: (_, repo, session, prev) => prev ?? AuthProvider(repo, session),
    ),
    ChangeNotifierProxyProvider<DashboardRepository, DashboardProvider>(
      create: (context) =>
          DashboardProvider(context.read<DashboardRepository>()),
      update: (_, repo, prev) => prev ?? DashboardProvider(repo),
    ),
  ];
}
