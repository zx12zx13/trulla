// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trulla/providers/auth/edit_profil_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    EditProfilProvider provider = context.read<EditProfilProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.fetchProfil(context);
      nameController.text = provider.name;
      emailController.text = provider.email;
    });
  }

  void updateProfil() async {
    EditProfilProvider provider = context.read<EditProfilProvider>();
    await provider.updateProfil(
        name: nameController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        context: context,
        onSuccess: () {
          Navigator.pop(context);
        },
        onError: (message) {});
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4E6AF3);
    const backgroundColor = Color(0xFF1A1E2D);
    const surfaceColor = Color(0xFF242938);
    const accentColor = Color(0xFF6C63FF);

    return Consumer<EditProfilProvider>(
        builder: (context, provider, child) => Scaffold(
              backgroundColor: backgroundColor,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [primaryColor, accentColor],
                              ).createShader(bounds),
                              child: const Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: primaryColor.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward,
                                    color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [primaryColor, accentColor],
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: surfaceColor,
                                    child: Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [primaryColor, accentColor],
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: primaryColor,
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildTextField(
                                  'Name', Icons.person, nameController),
                              const SizedBox(height: 16),
                              _buildTextField(
                                  'Email', Icons.email, emailController,
                                  enabled: false),
                              const SizedBox(height: 16),
                              _buildTextField(
                                  'Password', Icons.lock, passwordController,
                                  isPassword: true),
                              const SizedBox(height: 16),
                              _buildTextField('Confirm Password',
                                  Icons.lock_outline, confirmPasswordController,
                                  isPassword: true),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [primaryColor, accentColor],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: updateProfil,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: provider.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller,
      {bool isPassword = false, bool enabled = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4E6AF3).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        enabled: enabled,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFF4E6AF3)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
