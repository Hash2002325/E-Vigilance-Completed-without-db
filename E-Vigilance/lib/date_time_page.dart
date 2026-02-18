import 'package:flutter/material.dart';
import 'report_data.dart';
import 'issue_type_page.dart';

class DateTimePage extends StatefulWidget {
  final ReportData reportData;
  const DateTimePage({super.key, required this.reportData});

  @override
  State<DateTimePage> createState() => _DateTimePageState();
}

class _DateTimePageState extends State<DateTimePage> {
  DateTime selected = DateTime.now();

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
                'Date & Time',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Enter date'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selected,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    selected = DateTime(
                      picked.year,
                      picked.month,
                      picked.day,
                      selected.hour,
                      selected.minute,
                    );
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                child: Text(
                  '${selected.day}/${selected.month}/${selected.year}',
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Enter time'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final t = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(selected),
                );
                if (t != null) {
                  setState(() {
                    selected = DateTime(
                      selected.year,
                      selected.month,
                      selected.day,
                      t.hour,
                      t.minute,
                    );
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                child: Text(TimeOfDay.fromDateTime(selected).format(context)),
              ),
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
                    widget.reportData.dateTime = selected;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            IssueTypePage(reportData: widget.reportData),
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
