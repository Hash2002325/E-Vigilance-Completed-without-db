import 'package:flutter/material.dart';
import 'report_data.dart';
import 'vehicle_details_page.dart';

class EvidencePage extends StatelessWidget {
  final ReportData reportData;

  const EvidencePage({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0074D9);
    const orange = Color(0xFFFF851B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 80,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: CustomPaint(
                    size: const Size(150, 150),
                    painter: _CornerPainter(color: blue),
                  ),
                ),
                const Positioned(
                  top: 26,
                  right: 40,
                  child: _SmallSquare(color: orange),
                ),
              ],
            ),
          ),
          const Text(
            'Evidence',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Please describe any other details'),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  // TODO: image picker / camera
                  // reportData.evidencePath = 'path/to/file';
                },
                child: Container(
                  width: 220,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: blue),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add_a_photo,
                      size: 48,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VehicleDetailsPage(reportData: reportData),
                      ),
                    );
                  },
                  child: const Text('Next'),
                ),
              ],
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
