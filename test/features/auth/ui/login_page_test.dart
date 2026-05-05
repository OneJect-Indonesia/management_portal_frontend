import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import 'package:frontend/features/auth/ui/login_page.dart';
import 'package:frontend/features/auth/ui/mobile/login_page_mobile.dart';
import 'package:frontend/features/auth/ui/web/login_page_web.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    // Default behaviors
    when(() => mockAuthProvider.isLoading).thenReturn(false);
    when(() => mockAuthProvider.isAuthenticated).thenReturn(false);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuthProvider,
        child: const LoginPage(),
      ),
    );
  }

  testWidgets('LoginPage shows mobile version on small screens', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(LoginPageMobile), findsOneWidget);
    expect(find.byType(LoginPageWeb), findsNothing);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('LoginPage shows web version on large screens', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(LoginPageWeb), findsOneWidget);
    expect(find.byType(LoginPageMobile), findsNothing);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('LoginPageMobile shows validation errors on empty fields', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Login to Portal'));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });
}
