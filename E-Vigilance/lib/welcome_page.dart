import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color blue = Color(0xFF0074D9);
    const Color orange = Color(0xFFFF851B);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // top decoration
            SizedBox(
              height: 80,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: CustomPaint(
                      size: const Size(160, 160),
                      painter: _CornerPainter(color: blue),
                    ),
                  ),
                  const Positioned(
                    top: 24,
                    right: 32,
                    child: _SmallSquare(color: orange),
                  ),
                ],
              ),
            ),
            // logo + text
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // APP ICON FROM assets/images/e_vigilance_logo.png
                  Image.asset(
                    'assets/images/e_vigilance_logo.png',
                    width: 140,
                    height: 140,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'E‑Vigilance',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Civic Responsibility & Transparency',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _OutlinedRoundButton(
                    text: 'Sign In',
                    borderColor: blue,
                    textColor: blue,
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),
                  const SizedBox(width: 24),
                  _OutlinedRoundButton(
                    text: 'Sign Up',
                    borderColor: orange,
                    textColor: orange,
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                  ),
                ],
              ),
            ),
            // bottom decoration
            SizedBox(
              height: 80,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Transform.rotate(
                      angle: 3.14159,
                      child: CustomPaint(
                        size: const Size(160, 160),
                        painter: _CornerPainter(color: orange),
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 24,
                    left: 40,
                    child: _SmallSquare(color: blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlinedRoundButton extends StatelessWidget {
  final String text;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _OutlinedRoundButton({
    required this.text,
    required this.borderColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  const _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SmallSquare extends StatelessWidget {
  final Color color;
  const _SmallSquare({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(width: 16, height: 16, color: color);
  }
}
