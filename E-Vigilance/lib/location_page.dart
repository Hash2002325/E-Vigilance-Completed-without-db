import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  bool isLoadingLocation = false;
  String? currentLocationText;

  // Get current GPS location
  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError('Location services are disabled. Please enable them.');
        setState(() {
          isLoadingLocation = false;
          useCurrentLocation = false;
        });
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError('Location permission denied');
          setState(() {
            isLoadingLocation = false;
            useCurrentLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError('Location permissions are permanently denied');
        setState(() {
          isLoadingLocation = false;
          useCurrentLocation = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Save to reportData
      widget.reportData.latitude = position.latitude;
      widget.reportData.longitude = position.longitude;
      widget.reportData.location = 'Current location';

      setState(() {
        currentLocationText = 'Lat: ${position.latitude.toStringAsFixed(6)}, '
            'Lng: ${position.longitude.toStringAsFixed(6)}';
        isLoadingLocation = false;
      });

      _showSuccess('Location captured successfully!');
    } catch (e) {
      _showError('Failed to get location: $e');
      setState(() {
        isLoadingLocation = false;
        useCurrentLocation = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

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
            
            // Map/Location preview area
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: currentLocationText != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 50,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentLocationText!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : const Text(
                      'Map / Location preview',
                      style: TextStyle(color: Colors.grey),
                    ),
            ),
            
            const SizedBox(height: 16),
            
            // Use current location checkbox
            Row(
              children: [
                Checkbox(
                  value: useCurrentLocation,
                  onChanged: (v) async {
                    setState(() => useCurrentLocation = v ?? false);
                    if (v == true) {
                      await _getCurrentLocation();
                    } else {
                      setState(() {
                        currentLocationText = null;
                        widget.reportData.latitude = null;
                        widget.reportData.longitude = null;
                        widget.reportData.location = null;
                      });
                    }
                  },
                ),
                const Text('Use my current location'),
                if (isLoadingLocation)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Manual location input
            TextField(
              controller: _locationController,
              enabled: !useCurrentLocation,
              decoration: const InputDecoration(
                labelText: 'Or enter location manually',
                border: OutlineInputBorder(),
              ),
            ),
            
            const Spacer(),
            
            // Navigation buttons
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
                    // Save manual location if entered
                    if (!useCurrentLocation && _locationController.text.isNotEmpty) {
                      widget.reportData.location = _locationController.text;
                      widget.reportData.latitude = null;
                      widget.reportData.longitude = null;
                    }

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