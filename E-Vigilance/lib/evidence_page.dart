import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'report_data.dart';
import 'vehicle_details_page.dart';

class EvidencePage extends StatefulWidget {
  final ReportData reportData;

  const EvidencePage({super.key, required this.reportData});

  @override
  State<EvidencePage> createState() => _EvidencePageState();
}

class _EvidencePageState extends State<EvidencePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedMedia;
  bool _isVideo = false;

  // Take photo from camera
  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (photo != null) {
        setState(() {
          _selectedMedia = photo;
          _isVideo = false;
          widget.reportData.evidencePath = photo.path;
        });
      }
    } catch (e) {
      _showError('Failed to take photo: $e');
    }
  }

  // Record video from camera
  Future<void> _recordVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 2),
      );
      
      if (video != null) {
        setState(() {
          _selectedMedia = video;
          _isVideo = true;
          widget.reportData.evidencePath = video.path;
        });
      }
    } catch (e) {
      _showError('Failed to record video: $e');
    }
  }

  // Pick from gallery (shows photo/video option)
  Future<void> _pickFromGallery() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose Photo'),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Choose Video'),
              onTap: () async {
                Navigator.pop(context);
                await _pickVideo();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedMedia = image;
          _isVideo = false;
          widget.reportData.evidencePath = image.path;
        });
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  // Pick video from gallery
  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      
      if (video != null) {
        setState(() {
          _selectedMedia = video;
          _isVideo = true;
          widget.reportData.evidencePath = video.path;
        });
      }
    } catch (e) {
      _showError('Failed to pick video: $e');
    }
  }

  // Show error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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

          // Camera and Video buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Camera button
              GestureDetector(
                onTap: _takePhoto,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 40),
              // Video button
              GestureDetector(
                onTap: _recordVideo,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: blue, width: 3),
                  ),
                  child: Icon(
                    Icons.videocam,
                    size: 40,
                    color: blue,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Preview area or "Tap to add" box
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: _pickFromGallery,
                child: _selectedMedia == null
                    ? Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: blue, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 60,
                              color: orange,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap to add Photo/Video',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: blue, width: 2),
                        ),
                        child: Stack(
                          children: [
                            // Preview
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _isVideo
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.play_circle_outline,
                                            size: 80,
                                            color: blue,
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Video Selected',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Image.file(
                                      File(_selectedMedia!.path),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            // Remove button
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedMedia = null;
                                    _isVideo = false;
                                    widget.reportData.evidencePath = null;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                            VehicleDetailsPage(reportData: widget.reportData),
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