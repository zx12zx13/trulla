import 'dart:math';
import 'package:flutter/material.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  final Color primaryColor = const Color(0xFF4E6AF3);
  final Color backgroundColor = const Color(0xFF0A0E21);
  final Color surfaceColor = const Color(0xFF1D1F33);
  final Color accentColor = const Color(0xFF6C63FF);
  final Color textColor = const Color(0xFFFFFFFF);

  final List<TagItem> tags = [
    const TagItem(
      'Belanja',
      Color(0xFFFF6B6B),
      left: 40,
      top: 180,
      rotate: -0.2,
      width: 160,
      height: 45,
      isAnimated: true,
    ),
    const TagItem(
      'Ulang Tahun',
      Color(0xFF4ECDC4),
      right: 30,
      top: 190,
      rotate: 0.3,
      width: 160,
      height: 45,
      isAnimated: true,
    ),
    const TagItem(
      'Meeting',
      Color(0xFFFFBE0B),
      left: 110,
      top: 240,
      width: 160,
      height: 45,
      isAnimated: true,
    ),
    const TagItem(
      'Daftar Tugas',
      Color(0xFFFF006E),
      right: 70,
      top: 290,
      width: 160,
      height: 45,
      isAnimated: true,
    ),
    const TagItem(
      'Liburan',
      Color(0xFF8338EC),
      left: 60,
      top: 340,
      width: 160,
      height: 45,
      isAnimated: true,
    ),
  ];

  WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
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
                        child: Icon(Icons.apps_rounded,
                            color: primaryColor, size: 28),
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
                const SizedBox(height: 320),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [primaryColor, accentColor],
                  ).createShader(bounds),
                  child: Text(
                    'Dengan Trulla',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Atur Tugas dan Kegiatanmu\ndengan Mudah',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: textColor.withOpacity(0.9),
                    height: 1.5,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 70),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 8,
                      shadowColor: primaryColor.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.login_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          'Masuk',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...tags.map((tag) => AnimatedTagWrapper(tag)),
        ],
      ),
    );
  }
}

class AnimatedTagWrapper extends StatefulWidget {
  final TagItem tag;

  const AnimatedTagWrapper(this.tag, {Key? key}) : super(key: key);

  @override
  State<AnimatedTagWrapper> createState() => _AnimatedTagWrapperState();
}

class _AnimatedTagWrapperState extends State<AnimatedTagWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _moveController;
  late Animation<Offset> _moveAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _moveController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _moveController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() => _isAnimating = false);
      }
    });
  }

  void _initializeAnimation() {
    final random = Random();
    final dx = (random.nextDouble() - 0.5) * 100;
    final dy = (random.nextDouble() - 0.5) * 100;

    _moveAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(dx, dy),
    ).animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeInOutBack,
    ));
  }

  void _handleTap() {
    if (!_isAnimating) {
      setState(() => _isAnimating = true);
      _initializeAnimation();
      _moveController.forward();
    }
  }

  @override
  void dispose() {
    _moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.tag.left,
      right: widget.tag.right,
      top: widget.tag.top,
      child: GestureDetector(
        onTapDown: (_) => _handleTap(),
        child: AnimatedBuilder(
          animation: _moveController,
          builder: (context, child) {
            return Transform.translate(
              offset: _isAnimating ? _moveAnimation.value : Offset.zero,
              child: Transform.rotate(
                angle: widget.tag.rotate,
                child: widget.tag,
              ),
            );
          },
        ),
      ),
    );
  }
}

class TagItem extends StatefulWidget {
  final String text;
  final Color color;
  final double? left;
  final double? right;
  final double? top;
  final double rotate;
  final double? width;
  final double? height;
  final bool isAnimated;

  const TagItem(
    this.text,
    this.color, {
    this.left,
    this.right,
    this.top,
    this.rotate = 0.0,
    this.width,
    this.height,
    this.isAnimated = false,
    Key? key,
  }) : super(key: key);

  @override
  State<TagItem> createState() => _TagItemState();
}

class _TagItemState extends State<TagItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isAnimated) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isAnimated ? _scaleAnimation.value : 1.0,
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.9),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
