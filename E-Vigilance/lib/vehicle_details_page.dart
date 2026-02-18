import 'package:flutter/material.dart';
import 'report_data.dart';
import 'date_time_page.dart';

class VehicleDetailsPage extends StatefulWidget {
  final ReportData reportData;
  const VehicleDetailsPage({super.key, required this.reportData});

  @override
  State<VehicleDetailsPage> createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  String? _selectedType;

  final List<String> vehicleTypes = [
    'Car',
    'Van',
    'Motorcycle',
    'Three-wheeler',
    'Truck',
    'Bus',
    'Public transport',
    'Vehicle (unspecified)',
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
                'Vehicle Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Vehicle type'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              hint: const Text('Select or search'),
              items: vehicleTypes
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedType = value),
            ),
            const SizedBox(height: 16),
            const Text('Vehicle registration number'),
            TextField(controller: _numberController),
            const SizedBox(height: 16),
            const Text('Vehicle model (optional)'),
            TextField(controller: _modelController),
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
                    widget.reportData.vehicleType = _selectedType;
                    widget.reportData.vehicleNumber = _numberController.text;
                    widget.reportData.vehicleModel = _modelController.text;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DateTimePage(reportData: widget.reportData),
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
