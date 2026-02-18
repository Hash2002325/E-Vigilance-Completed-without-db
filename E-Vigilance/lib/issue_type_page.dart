import 'package:flutter/material.dart';
import 'report_data.dart';
import 'location_page.dart';

class IssueTypePage extends StatefulWidget {
  final ReportData reportData;
  const IssueTypePage({super.key, required this.reportData});

  @override
  State<IssueTypePage> createState() => _IssueTypePageState();
}

class _IssueTypePageState extends State<IssueTypePage> {
  String? _selectedIssue;

  final issues = const [
    'A vehicle was moving dangerously',
    'A vehicle was parked illegally',
    'A driver disobeyed a traffic signal or road sign',
    'A vehicle appeared to be in poor condition',
  ];

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
                'Type of Issue',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Text('What kind of issue did you observe on the road?'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedIssue,
              hint: const Text('Select or search'),
              items: issues
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedIssue = value),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: blue),
                  onPressed: () {
                    widget.reportData.issueType = _selectedIssue;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LocationPage(reportData: widget.reportData),
                      ),
                    );
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
