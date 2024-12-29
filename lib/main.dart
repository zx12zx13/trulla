import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trulla/providers/auth/login_provider.dart';
import 'package:trulla/providers/auth/register_provider.dart';
import 'package:trulla/providers/navigation/project_provider.dart';
import 'widget/navbar.dart';
import 'pages/opening/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
        ChangeNotifierProvider(create: (context) => ProjectProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Trulla',
        theme: ThemeData(
          primaryColor: const Color(0xFF2196F3),
          scaffoldBackgroundColor: const Color(0xFF1A1E2D),
        ),
        home: FutureBuilder<bool>(
          future: _checkToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data == true) {
              return const NavBarController();
            } else {
              return WelcomePage();
            }
          },
        ),
        routes: {
          '/home': (context) => const NavBarController(),
        },
      ),
    );
  }
}
