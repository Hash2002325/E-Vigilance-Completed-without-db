import 'dart:io';
import 'package:flutter/material.dart';

class ReportDetailPage extends StatelessWidget {
  final dynamic report;

  const ReportDetailPage({super.key, required this.report});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'In Progress':
      default:
        return const Color(0xFF0074D9);
    }
  }

  String _formatDate(String? dateTime) {
    if (dateTime == null) return 'N/A';
    try {
      final dt = DateTime.parse(dateTime);
      return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatLocation(dynamic report) {
    if (report['latitude'] != null && report['longitude'] != null) {
      final lat = report['latitude'].toStringAsFixed(6);
      final lng = report['longitude'].toStringAsFixed(6);
      return 'GPS: $lat, $lng';
    }
    return report['location'] ?? 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0074D9);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Report #CM${report['id']}'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: _getStatusColor(report['status'] ?? 'In Progress'),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  report['status'] ?? 'In Progress',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Evidence Photo/Video (Full Size)
            if (report['evidencePath'] != null)
              Container(
                height: 250,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade200,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: report['evidencePath'].toString().contains('.mp4') ||
                          report['evidencePath'].toString().contains('video')
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_circle_outline,
                                size: 80,
                                color: blue,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Video Evidence',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tap to play',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Image.file(
                          File(report['evidencePath']),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.image, size: 60, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text('Photo Evidence'),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),

            // Report Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    icon: Icons.report_problem,
                    label: 'Complaint',
                    value: report['issueType'] ?? 'N/A',
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.directions_car,
                    label: 'Vehicle Type',
                    value: report['vehicleType'] ?? 'N/A',
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.confirmation_number,
                    label: 'Vehicle Number',
                    value: report['vehicleNumber'] ?? 'N/A',
                  ),
                  if (report['vehicleModel'] != null &&
                      report['vehicleModel'].toString().isNotEmpty) ...[
                    const Divider(height: 24),
                    _DetailRow(
                      icon: Icons.car_rental,
                      label: 'Vehicle Model',
                      value: report['vehicleModel'],
                    ),
                  ],
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.calendar_today,
                    label: 'Date & Time',
                    value: _formatDate(report['dateTime']),
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    icon: Icons.location_on,
                    label: 'Location',
                    value: _formatLocation(report),
                  ),
                  if (report['additionalDetails'] != null &&
                      report['additionalDetails'].toString().isNotEmpty) ...[
                    const Divider(height: 24),
                    _DetailRow(
                      icon: Icons.notes,
                      label: 'Additional Details',
                      value: report['additionalDetails'],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Submitted Date
            Center(
              child: Text(
                'Submitted on ${_formatDate(report['createdAt'])}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 24,
          color: const Color(0xFF0074D9),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}