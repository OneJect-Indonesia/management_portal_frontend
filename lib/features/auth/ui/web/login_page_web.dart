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
  bool _isButtonHovered = false;

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
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // ── 1. Background gradient ─────────────────────────────────
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1, -1),
                  end: Alignment(1, 1),
                  colors: [
                    Color(0xFF3F8F81),
                    Color(0xFF4DA8CF),
                    Color(0xFFE0F2FE),
                    Color(0xFF4DA8CF),
                    Color(0xFF3F8F81),
                  ],
                  stops: [0.08, 0.20, 0.80, 0.92, 1.0],
                ),
              ),
            ),

            // ── 2. Decorative ambient orbs ────────────────────────────
            Positioned(
              top: -size.height * 0.05,
              left: -size.width * 0.05,
              child: _buildOrb(320, const Color(0xFF3F8F81), 0.18, 100),
            ),
            Positioned(
              bottom: -size.height * 0.05,
              right: -size.width * 0.05,
              child: _buildOrb(360, const Color(0xFF4DA8CF), 0.14, 100),
            ),
            Positioned(
              top: size.height * 0.3,
              left: size.width * 0.4,
              child: _buildOrb(200, Colors.white, 0.10, 60),
            ),

            // ── 3. Central Glass Card ─────────────────────────────────
            Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 740,
                  maxHeight: 400,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 40,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3F8F81).withValues(alpha: 0.25),
                      blurRadius: 48,
                      offset: const Offset(0, 24),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.30),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          // ── Left: Branding ───────────────────────────
                          Expanded(flex: 5, child: _BrandingPanel()),

                          // ── Divider ──────────────────────────────────
                          Container(
                            width: 1,
                            height: double.infinity,
                            color: Colors.white.withValues(alpha: 0.20),
                          ),

                          // ── Right: Form ──────────────────────────────
                          Expanded(
                            flex: 4,
                            child: _FormPanel(
                              formKey: _formKey,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              isObscured: _isObscured,
                              isButtonHovered: _isButtonHovered,
                              isLoading: isLoading,
                              onToggleObscure: () {
                                setState(() => _isObscured = !_isObscured);
                              },
                              onButtonHover: (v) {
                                setState(() => _isButtonHovered = v);
                              },
                              onLogin: _handleLogin,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrb(double size, Color color, double alpha, double blurSigma) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: alpha),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

// ── Branding Panel (Left) ─────────────────────────────────────────────────────
class _BrandingPanel extends StatelessWidget {
  const _BrandingPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3F8F81).withValues(alpha: 0.12),
            const Color(0xFF4DA8CF).withValues(alpha: 0.06),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Inner decorative ring — purely aesthetic
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 40,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 50,
                ),
              ),
            ),
          ),
          // Logo + caption centered
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/Oneject-Vertical.png',
                    height: 130,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        alignment: Alignment.center,
                        child: Text(
                          'ONEJECT',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(
                              0xFF0B3D4A,
                            ).withValues(alpha: 0.6),
                            letterSpacing: 4,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Caption — smaller than the logo
                  Text(
                    'Application Management Portal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0B3D4A).withValues(alpha: 0.65),
                      letterSpacing: 0.4,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Form Panel (Right) ────────────────────────────────────────────────────────
class _FormPanel extends StatelessWidget {
  const _FormPanel({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isObscured,
    required this.isButtonHovered,
    required this.isLoading,
    required this.onToggleObscure,
    required this.onButtonHover,
    required this.onLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isObscured;
  final bool isButtonHovered;
  final bool isLoading;
  final VoidCallback onToggleObscure;
  final void Function(bool) onButtonHover;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Heading
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B3D4A),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Enter your credentials to continue.',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF164E63).withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: 28),

                // Email field
                _buildTextField(
                  controller: emailController,
                  label: 'Work Email',
                  icon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    final emailRegex = RegExp(
                      r'^[\w.+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!emailRegex.hasMatch(v.trim())) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Password field
                _buildTextField(
                  controller: passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline_rounded,
                  obscure: isObscured,
                  suffix: IconButton(
                    icon: Icon(
                      isObscured
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: 18,
                      color: const Color(0xFF164E63).withValues(alpha: 0.6),
                    ),
                    onPressed: onToggleObscure,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Sign In button
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => onButtonHover(true),
                  onExit: (_) => onButtonHover(false),
                  child: GestureDetector(
                    onTap: isLoading ? null : onLogin,
                    child: AnimatedScale(
                      scale: isButtonHovered ? 1.03 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeInOut,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3F8F81), Color(0xFF4DA8CF)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3F8F81).withValues(
                                alpha: isButtonHovered ? 0.55 : 0.28,
                              ),
                              blurRadius: isButtonHovered ? 22 : 10,
                              offset: Offset(0, isButtonHovered ? 8 : 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    const borderColor = Color(0xFF164E63);
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: borderColor.withValues(alpha: 0.18)),
    );
    final focusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14, color: Color(0xFF0B3D4A)),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 13,
          color: borderColor.withValues(alpha: 0.65),
        ),
        floatingLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        prefixIcon: Icon(
          icon,
          size: 18,
          color: borderColor.withValues(alpha: 0.6),
        ),
        suffixIcon: suffix,
        enabledBorder: inputBorder,
        focusedBorder: focusBorder,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.50),
      ),
      validator: validator,
    );
  }
}
