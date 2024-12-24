import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register.dart';

class WelcomePage extends StatelessWidget {
  final Color primaryColor = const Color(0xFF2196F3);
  final Color backgroundColor = const Color(0xFF1A1E2D);
  final Color surfaceColor = const Color(0xFF242938);
  final Color textColor = const Color(0xFFFFFFFF);

  final List<TagItem> tags = [
    const TagItem(
      'Belanja',
      Color(0xFFFF9800),
      left: 40,
      top: 135,
      rotate: -0.3,
      width: 150,
      height: 40,
    ),
    const TagItem(
      'Ulang Tahun',
      Color(0xFF4CAF50),
      right: 100,
      top: 145,
      rotate: 0.4,
      width: 150,
      height: 40,
    ),
    const TagItem(
      'Meeting',
      Color(0xFFFFC107),
      left: 130,
      top: 180,
      width: 150,
      height: 40,
    ),
    const TagItem(
      'Daftar Tugas',
      Color(0xFFFF5252),
      right: 90,
      top: 240,
      width: 150,
      height: 40,
    ),
    const TagItem(
      'Liburan',
      Color(0xFF2196F3),
      left: 80,
      top: 290,
      width: 150,
      height: 40,
    ),
  ];

  WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.apps_rounded, color: primaryColor, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Trulla',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 280),
                Text(
                  'Dengan Trulla',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Atur Tugas dan Kegiatanmu\ndengan Mudah',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    onPressed: () {Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login_rounded, color: Colors.black, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Masuk',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      side: BorderSide(color: Colors.white, width: 2),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    onPressed: () {Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.app_registration, color: Colors.white, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Daftar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
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
          ...tags.map((tag) => Positioned(
                left: tag.left,
                right: tag.right,
                top: tag.top,
                child: Transform.rotate(
                  angle: tag.rotate,
                  child: tag,
                ),
              )),
        ],
      ),
    );
  }
}

class TagItem extends StatelessWidget {
  final String text;
  final Color color;
  final double? left;
  final double? right;
  final double? top;
  final double rotate;
  final double? width;
  final double? height;

  const TagItem(
    this.text,
    this.color, {
    this.left,
    this.right,
    this.top,
    this.rotate = 0.0,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width != null && width! > 0 ? width : null,
      height: height != null && height! > 0 ? height : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
