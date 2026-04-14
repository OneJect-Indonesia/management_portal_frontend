import 'package:flutter/material.dart';
import 'interface/login_page.dart';
import 'interface/dashboard_page.dart';
import 'core/session_service.dart';
import 'core/dashboard_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
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
  Widget? _homeWidget;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final user = await SessionService.getSession();
    if (user != null) {
      // Validasi token dengan endpoint /my-dashboard
      final dashboardService = DashboardService();
      final dashboardData = await dashboardService.getDashboardData(user.token);

      // Jika data berhasil diambil, maka sesi masih aktif (token belum expired).
      // Catatan: DashboardPage nantinya akan nge-fetch ulang dasboardData karena ada logic fetch di sana,
      // tapi secara UI ini juga berfungsi memastikan token terverifikasi di backend.
      if (dashboardData != null) {
        setState(() {
          _homeWidget = DashboardPage(user: user);
          _isLoading = false;
        });
        return;
      } else {
        // Token tidak valid/expired, hapus sesi di lokal
        await SessionService.clearSession();
      }
    }

    // Jika tidak ada user atau token expire
    setState(() {
      _homeWidget = const LoginPage();
      _isLoading = false;
    });
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
    return _homeWidget!;
  }
}
