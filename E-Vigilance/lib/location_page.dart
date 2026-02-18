import 'package:flutter/material.dart';
import 'report_data.dart';
import 'additional_details_page.dart';

class LocationPage extends StatefulWidget {
  final ReportData reportData;
  const LocationPage({super.key, required this.reportData});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final TextEditingController _locationController = TextEditingController();
  bool useCurrentLocation = false;

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
                'Location Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Search Location'),
            const SizedBox(height: 8),
            Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const Text('Map / Location preview'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: useCurrentLocation,
                  onChanged: (v) =>
                      setState(() => useCurrentLocation = v ?? false),
                ),
                const Text('Use my current location'),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Or enter location manually',
                border: OutlineInputBorder(),
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
                    widget.reportData.location =
                        _locationController.text.isNotEmpty
                        ? _locationController.text
                        : (useCurrentLocation ? 'Current location' : null);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdditionalDetailsPage(
                          reportData: widget.reportData,
                        ),
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
