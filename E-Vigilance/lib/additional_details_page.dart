import 'package:flutter/material.dart';
import 'report_data.dart';
import 'services/token_storage.dart';
import 'services/report_service.dart';

class AdditionalDetailsPage extends StatefulWidget {
  final ReportData reportData;
  const AdditionalDetailsPage({super.key, required this.reportData});

  @override
  State<AdditionalDetailsPage> createState() => _AdditionalDetailsPageState();
}

class _AdditionalDetailsPageState extends State<AdditionalDetailsPage> { 
  final TextEditingController _detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0074D9);

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Additional Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Please describe any other details'),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _detailsController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Optional – write a short note if needed.',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: blue),
                  onPressed: () async {
  widget.reportData.additionalDetails = _detailsController.text;

  // Get token
  final token = TokenStorage.getToken();
  if (token == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please login again')),
    );
    return;
  }

  // Prepare report data
  final reportData = {
    'vehicleType': widget.reportData.vehicleType,
    'vehicleNumber': widget.reportData.vehicleNumber,
    'vehicleModel': widget.reportData.vehicleModel,
    'dateTime': widget.reportData.dateTime?.toIso8601String(),
    'issueType': widget.reportData.issueType,
    'location': widget.reportData.location,
    'additionalDetails': widget.reportData.additionalDetails,
  };

  // Show loading
  if (!mounted) return;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  // Send to backend
  final result = await ReportService.createReport(
    token: token,
    reportData: reportData,
  );

  // Hide loading
  if (!mounted) return;
  Navigator.pop(context);

  // Check result
  if (result['success'] == true) {
    // Success - return to home
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  } else {
    // Error
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? 'Failed to submit report')),
    );
  }
},
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
