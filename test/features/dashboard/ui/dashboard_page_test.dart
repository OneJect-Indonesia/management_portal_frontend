import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import 'package:frontend/features/dashboard/providers/dashboard_provider.dart';
import 'package:frontend/features/dashboard/ui/dashboard_page.dart';
import 'package:frontend/features/auth/models/user_model.dart';
import 'package:frontend/features/dashboard/models/dashboard_model.dart';

class MockAuthProvider extends Mock implements AuthProvider {}
class MockDashboardProvider extends Mock implements DashboardProvider {}

void main() {
  late MockAuthProvider mockAuthProvider;
  late MockDashboardProvider mockDashboardProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockDashboardProvider = MockDashboardProvider();

    final mockUser = UserModel(
      id: 1,
      nik: '123456',
      fullName: 'Test User',
      department: 'IT',
      role: 'Admin',
      token: 'mock_token',
    );

    when(() => mockAuthProvider.currentUser).thenReturn(mockUser);
    when(() => mockAuthProvider.isAuthenticated).thenReturn(true);
    
    when(() => mockDashboardProvider.isLoading).thenReturn(false);
    when(() => mockDashboardProvider.error).thenReturn(null);
    when(() => mockDashboardProvider.selectedCategory).thenReturn('Category 1');
    
    final mockData = DashboardData(
      categories: {
        'Category 1': [
          MenuItem(
            id: 1,
            menuName: 'System A',
            isActive: true,
            module: Module(
              id: 1,
              moduleName: 'System A',
              moduleDescription: 'Description A',
              category: 'Category 1',
            ),
            content: Content(
              type: 'web',
              title: 'System A',
              version: '1.0',
              repo: 'https://example.com/a',
            ),
          ),
        ],
      },
    );
    when(() => mockDashboardProvider.dashboardData).thenReturn(mockData);
    when(() => mockDashboardProvider.fetchData()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
          ChangeNotifierProvider<DashboardProvider>.value(value: mockDashboardProvider),
        ],
        child: const DashboardPage(),
      ),
    );
  }

  testWidgets('DashboardPage shows user name and honeycomb menu items', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('System A'), findsWidgets);

    // Check for logout button
    expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
  });

  testWidgets('DashboardPage shows loading indicator when data is being fetched', (WidgetTester tester) async {
    when(() => mockDashboardProvider.isLoading).thenReturn(true);
    
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('DashboardPage shows error message on failure', (WidgetTester tester) async {
    when(() => mockDashboardProvider.error).thenReturn('Network Error');
    
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Network Error'), findsOneWidget);
    expect(find.text('Retry Connection'), findsOneWidget);
  });
}
