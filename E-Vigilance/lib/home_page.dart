import 'package:flutter/material.dart';
import 'report_data.dart';
import 'evidence_page.dart';
import 'reports_page.dart';
import 'services/token_storage.dart';
import 'services/report_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? stats;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final token = TokenStorage.getToken();
    if (token == null) {
      // Not logged in, go back to welcome
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
      return;
    }

    final result = await ReportService.getUserStats(token: token);
    
    if (result['success'] == true) {
      setState(() {
        stats = result['stats'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color blue = Color(0xFF0074D9);
    const Color orange = Color(0xFFFF851B);

    final user = TokenStorage.getUser();
    final userName = user?['name'] ?? 'User';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // top decoration + avatar
            SizedBox(
              height: 90,
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
                    top: 16,
                    right: 32,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                  const Positioned(
                    top: 24,
                    right: 70,
                    child: _SmallSquare(color: orange),
                  ),
                  Positioned(
                    left: 24,
                    bottom: 10,
                    child: Text(
                      'Hello, $userName',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // stats boxes
            isLoading
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StatusCard(
                              title: 'Total',
                              value: '${stats?['total'] ?? 0}',
                              color: blue,
                            ),
                            _StatusCard(
                              title: 'Completed',
                              value: '${stats?['completed'] ?? 0}',
                              color: Colors.green,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StatusCard(
                              title: 'In-progress',
                              value: '${stats?['inProgress'] ?? 0}',
                              color: Colors.grey,
                            ),
                            _StatusCard(
                              title: 'Rejected',
                              value: '${stats?['rejected'] ?? 0}',
                              color: orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

            const Spacer(),

            // buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EvidencePage(reportData: ReportData()),
                          ),
                        );
                      },
                      child: const Text(
                        'Report Violation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: blue, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReportsPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'View Reports',
                        style: TextStyle(
                          color: blue,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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

class _StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatusCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.9),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
    return Container(width: 14, height: 14, color: color);
  }
}