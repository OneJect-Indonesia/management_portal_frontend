import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import 'package:frontend/core/theme/app_colors.dart';

class LoginPageWeb extends StatefulWidget {
  const LoginPageWeb({super.key});

  @override
  State<LoginPageWeb> createState() => _LoginPageWebState();
}

class _LoginPageWebState extends State<LoginPageWeb> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();

      final result = await authProvider.login(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Login successful!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              width: 400,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.error ?? 'Login failed'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              width: 400,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Dynamic Glowing Gradient Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F172A), // Dark slate
                  Color(0xFF1E293B), // Medium slate
                  Color(0xFF0F172A), // Dark slate
                ],
              ),
            ),
          ),

          // 2. Decorative Glowing Orbs
          Positioned(
            top: size.height * 0.1,
            left: size.width * 0.15,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.18),
              ),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.1,
            right: size.width * 0.15,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: 0.15),
              ),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // 3. Central Login Box
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1100, maxHeight: 720),
                margin: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Left side - Branding with frosted layout
                          Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.primary.withValues(alpha: 0.15),
                                    AppColors.accent.withValues(alpha: 0.05),
                                  ],
                                ),
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(60.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Brand horizontal logo
                                        Image.asset(
                                          'assets/images/Oneject-Horizontal.png',
                                          height: 70,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            // Fallback logo if asset is missing or failing to load
                                            return Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                'ONEJECT',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 2,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 48),
                                        const Text(
                                          'Application\nManagement Portal',
                                          style: TextStyle(
                                            fontSize: 42,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            height: 1.2,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Text(
                                          'Streamline your clinical workflows and application access through our unified secure gateway.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white.withValues(alpha: 0.7),
                                            height: 1.6,
                                          ),
                                        ),
                                        const SizedBox(height: 60),
                                        Row(
                                          children: [
                                            _buildInfoChip(
                                              Icons.security_rounded,
                                              'Secure',
                                            ),
                                            const SizedBox(width: 12),
                                            _buildInfoChip(Icons.speed_rounded, 'Fast'),
                                            const SizedBox(width: 12),
                                            _buildInfoChip(
                                              Icons.verified_user_rounded,
                                              'Reliable',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Right side - Glassmorphic Form
                          Expanded(
                            flex: 4,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(60.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Enter your credentials to access your dashboard.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 48),
                                    
                                    // Username / Email input field
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        labelText: 'Work Email',
                                        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                                        prefixIcon: Icon(Icons.email_outlined, color: Colors.white.withValues(alpha: 0.6)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: const BorderSide(color: AppColors.error),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: const BorderSide(color: AppColors.error, width: 2),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withValues(alpha: 0.04),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    
                                    // Password input field
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _isObscured,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                                        prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.white.withValues(alpha: 0.6)),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isObscured
                                                ? Icons.visibility_off_rounded
                                                : Icons.visibility_rounded,
                                            color: Colors.white.withValues(alpha: 0.6),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isObscured = !_isObscured;
                                            });
                                          },
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: const BorderSide(color: AppColors.error),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: const BorderSide(color: AppColors.error, width: 2),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withValues(alpha: 0.04),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 40),
                                    
                                    // Glassmorphic Login Button
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: isLoading ? null : _handleLogin,
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                AppColors.primary,
                                                AppColors.secondary,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.primary.withValues(alpha: 0.4),
                                                blurRadius: 15,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: isLoading
                                                ? const SizedBox(
                                                    height: 24,
                                                    width: 24,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const Text(
                                                    'Sign In',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 48),
                                    Center(
                                      child: Text(
                                        '© 2026 OneJect Indonesia. All rights reserved.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
