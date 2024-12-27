// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';

class MotivationalQuotes {
  static final List<String> quotes = [
    "Success is the result of preparation, hard work, and learning from failure.",
    "Don't be afraid of failure. Fear keeps us from trying.",
    "You can fail but you can't fail your kidneys",
    "Every small step brings us closer to our goal.",
    "The future belongs to those who believe in the beauty of their dreams.",
  ];

  static String getRandomQuote() {
    final random = Random();
    return quotes[random.nextInt(quotes.length)];
  }
}

class QuoteFooter extends StatelessWidget {
  const QuoteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF242938),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: Color(0xFF2196F3),
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            MotivationalQuotes.getRandomQuote(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
