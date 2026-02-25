import 'dart:io';
import 'package:flutter/material.dart';
import 'services/token_storage.dart';
import 'services/report_service.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<dynamic> reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final token = TokenStorage.getToken();
    if (token == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
      return;
    }

    final result = await ReportService.getUserReports(token: token);
    
    if (result['success'] == true) {
      setState(() {
        reports = result['reports'] ?? [];
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reports.isEmpty
              ? const Center(
                  child: Text(
                    'No reports yet.\nCreate your first report!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: reports.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: const [
                          SizedBox(height: 8),
                          Text(
                            'Reports',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                        ],
                      );
                    }

                    final report = reports[index - 1];
                    return _ReportCard(report: report);
                  },
                ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final dynamic report;
  const _ReportCard({required this.report});

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
      return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatLocation(dynamic report) {
    // If we have coordinates, show them
    if (report['latitude'] != null && report['longitude'] != null) {
      final lat = report['latitude'].toStringAsFixed(4);
      final lng = report['longitude'].toStringAsFixed(4);
      return 'GPS: $lat, $lng';
    }
    // Otherwise show text location
    return report['location'] ?? 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#CM${report['id']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(report['status'] ?? 'In Progress'),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    report['status'] ?? 'In Progress',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 14),
            
            // Evidence Preview (Photo/Video)
            if (report['evidencePath'] != null)
              Container(
                height: 120,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: report['evidencePath'].toString().contains('.mp4') ||
                          report['evidencePath'].toString().contains('video')
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.play_circle_outline,
                                size: 50,
                                color: Color(0xFF0074D9),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Video Evidence',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Image.file(
                          File(report['evidencePath']),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.image, size: 40, color: Colors.grey),
                                  SizedBox(height: 4),
                                  Text('Photo Evidence', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
            
            // Complaint
            const _LabelText('Complaint'),
            Text(
              report['issueType'] ?? 'N/A',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            
            // Vehicle
            const _LabelText('Vehicle'),
            Text(
              '${report['vehicleType'] ?? 'N/A'} - ${report['vehicleNumber'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            
            // Date
            const _LabelText('Date'),
            Text(
              _formatDate(report['dateTime']),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            
            // Location
            const _LabelText('Location'),
            Text(
              _formatLocation(report),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            
            const SizedBox(height: 10),
            const Divider(thickness: 1),
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: open detailed report page
                },
                child: const Text(
                  'More info',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabelText extends StatelessWidget {
  final String text;
  const _LabelText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}