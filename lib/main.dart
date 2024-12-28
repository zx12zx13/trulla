import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trulla/providers/auth/login_provider.dart';
import 'package:trulla/providers/auth/register_provider.dart';
import 'widget/navbar.dart';
import 'pages/opening/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
