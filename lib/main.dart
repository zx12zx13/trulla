import 'package:flutter/material.dart';
import 'widget/navbar.dart';
import 'pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trulla',
      theme: ThemeData(
        primaryColor: const Color(0xFF2196F3),
        scaffoldBackgroundColor: const Color(0xFF1A1E2D),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/home': (context) => const NavBarController(),
      },
    );
  }
}
