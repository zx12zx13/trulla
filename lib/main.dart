import 'package:flutter/material.dart';
import 'login_page.dart';

void main() => runApp(TrullaApp());

class TrullaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trulla',
      theme: ThemeData.dark(),
      home: LoginPage(),
    );
  }
}
