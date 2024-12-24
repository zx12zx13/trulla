import 'package:flutter/material.dart';

import '../widget/navbar.dart';

class LoginPage extends StatelessWidget {
  final Color primaryColor = const Color(0xFF2196F3);
  final Color backgroundColor = const Color(0xFF1A1E2D);
  final Color surfaceColor = const Color(0xFF242938);
  final Color textColor = const Color(0xFFFFFFFF);
  final Color secondaryTextColor = const Color(0xFFB0BEC5);

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: textColor),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 40),
                Text(
                  'Selamat Datang\nKembali',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Masuk untuk melanjutkan',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 48),
                _buildTextField(
                  icon: Icons.person_outline,
                  label: 'Username',
                  hint: 'Masukkan username anda',
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  icon: Icons.lock_outline,
                  label: 'Password',
                  hint: 'Masukkan password',
                  isPassword: true,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Lupa Password?',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: textColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NavBarController()),
                    );
                  },
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: Divider(color: secondaryTextColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Atau masuk dengan',
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    ),
                    Expanded(child: Divider(color: secondaryTextColor)),
                  ],
                ),
                const SizedBox(height: 32),
                _buildGoogleButton(),
                const SizedBox(height: 32),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Belum punya akun? ',
                      style: TextStyle(color: secondaryTextColor),
                      children: [
                        TextSpan(
                          text: 'Daftar',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
    required IconData icon,
    required String label,
    required String hint,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryColor.withOpacity(0.2)),
          ),
          child: TextField(
            obscureText: isPassword,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: secondaryTextColor),
              suffixIcon: isPassword
                  ? Icon(Icons.visibility_off, color: secondaryTextColor)
                  : null,
              hintText: hint,
              hintStyle: TextStyle(color: secondaryTextColor),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
        label: Text(
          'Masuk dengan Google',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: surfaceColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: secondaryTextColor.withOpacity(0.2)),
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}
