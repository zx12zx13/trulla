// signup_page.dart
// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'login_page.dart';
import 'notification_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFF4E6AF3);
  final Color backgroundColor = const Color(0xFF0A0E21);
  final Color surfaceColor = const Color(0xFF1D1F33);
  final Color accentColor = const Color(0xFF6C63FF);
  final Color textColor = const Color(0xFFFFFFFF);
  final Color secondaryTextColor = const Color(0xFFB0BEC5);

  bool _passwordVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showNotification(String message, bool isSuccess) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        width: MediaQuery.of(context).size.width,
        child: NotificationWidget(
          message: message,
          isSuccess: isSuccess,
          onClose: () {
            _overlayEntry?.remove();
            _overlayEntry = null;
          },
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showNotification('All fields must be filled', false);
      return false;
    }

    if (!_emailController.text.contains('@')) {
      _showNotification('Invalid email', false);
      return false;
    }

    if (_passwordController.text.length < 6) {
      _showNotification('Password at least 6 characters', false);
      return false;
    }

    return true;
  }

  void _handleSignUp() {
    if (_validateInputs()) {
      // Simulate API call with delay
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const CircularProgressIndicator(),
            ),
          );
        },
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context); // Close loading dialog

        // Simulate successful registration
        _showNotification('Registrasi berhasil! Silahkan login', true);

        // Navigate to welcome page after successful notification
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  backgroundColor,
                  backgroundColor.withOpacity(0.8),
                  accentColor.withOpacity(0.1),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBackButton(),
                        const SizedBox(height: 30),
                        Center(
                          child: _buildHeader(),
                        ),
                        const SizedBox(height: 50),
                        _buildSignUpForm(),
                      ],
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

  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: textColor, size: 20),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.apps_rounded, color: primaryColor, size: 28),
              ),
              const SizedBox(width: 15),
              Text(
                'Trulla',
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [primaryColor, accentColor],
          ).createShader(bounds),
          child: Text(
            'Create a New Account',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Register to Organize Your Schedule',
          style: TextStyle(
            color: secondaryTextColor,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      children: [
        _buildAnimatedTextField(
          icon: Icons.person_outline_rounded,
          hint: 'Username',
          delay: 200,
          controller: _nameController,
        ),
        const SizedBox(height: 20),
        _buildAnimatedTextField(
          icon: Icons.email_outlined,
          hint: 'Email',
          delay: 400,
          controller: _emailController,
        ),
        const SizedBox(height: 20),
        _buildAnimatedTextField(
          icon: Icons.lock_outline_rounded,
          hint: 'Password',
          delay: 600,
          controller: _passwordController,
          isPassword: true,
        ),
        const SizedBox(height: 32),
        _buildSignUpButton(),
        const SizedBox(height: 24),
        _buildTermsAndConditions(),
      ],
    );
  }

  Widget _buildAnimatedTextField({
    required IconData icon,
    required String hint,
    required int delay,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              obscureText: isPassword && !_passwordVisible,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
              decoration: InputDecoration(
                prefixIcon: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(icon, color: accentColor, size: 22),
                ),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: secondaryTextColor,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      )
                    : null,
                hintText: hint,
                hintStyle: TextStyle(
                  color: secondaryTextColor.withOpacity(0.7),
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [primaryColor, accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: textColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              onPressed: _handleSignUp,
              child: const Text(
                'Register',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTermsAndConditions() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Center(
            child: Text(
              'By signing up, you agree to\nOur Terms & Conditions and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }
}
