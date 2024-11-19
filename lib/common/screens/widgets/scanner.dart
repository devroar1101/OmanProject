import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_twain_scanner/dynamsoft_service.dart';

class Scanner extends StatefulWidget {
  Scanner({super.key});
  @override
  _ScannerAppState createState() => _ScannerAppState();
}

class _ScannerAppState extends State<Scanner> {
  final DynamsoftService dynamsoftService = DynamsoftService();
  String host = 'http://127.0.0.1:18622'; // Ensure this host is correct

  List<Map<String, dynamic>> devices = [];
  List<String> scannerNames = [];
  String? _selectedScanner;
  List<Uint8List> imagePaths = [];
  int currentPage = 0;

  // Configuration settings for scanning
  bool ifFeederEnabled = false;
  bool ifDuplexEnabled = false;
  int resolution = 200;
  bool ifShowUI = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Modern Scanner App'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Scanner Control Panel
              _buildScannerControlPanel(),
              const SizedBox(height: 20),

              // Image Scanning Options (Scan button, etc.)
              _buildScanOptions(),
              const SizedBox(height: 20),

              // Image Pagination and Display
              _buildImagePagination(),
              const SizedBox(height: 10),
              _buildImageGallery(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Scanner Control Panel
  Widget _buildScannerControlPanel() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resolution Control
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Resolution',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<int>(
                  value: resolution,
                  items: [150, 200, 300, 400]
                      .map((e) => DropdownMenuItem<int>(
                            value: e,
                            child: Text('$e DPI'),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      resolution = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Duplex and Feeder Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duplex Enabled',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Switch(
                  value: ifDuplexEnabled,
                  onChanged: (value) {
                    setState(() {
                      ifDuplexEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Feeder Enabled',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Switch(
                  value: ifFeederEnabled,
                  onChanged: (value) {
                    setState(() {
                      ifFeederEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // UI visibility toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Show UI',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Switch(
                  value: ifShowUI,
                  onChanged: (value) {
                    setState(() {
                      ifShowUI = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Image Scanning Options (Scan button, etc.)
  Widget _buildScanOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MaterialButton(
          textColor: Colors.white,
          color: Colors.blueAccent,
          onPressed: _listScanners,
          child: const Text('List Scanners'),
        ),
        MaterialButton(
          textColor: Colors.white,
          color: Colors.green,
          onPressed: _selectedScanner != null ? _startScan : null,
          child: const Text('Scan Document'),
        ),
      ],
    );
  }

  // Widget for Image Pagination and Display
  Widget _buildImagePagination() {
    return imagePaths.isEmpty
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: currentPage > 0
                    ? () {
                        setState(() {
                          currentPage--;
                        });
                      }
                    : null,
              ),
              Text(
                '${currentPage + 1} / ${imagePaths.length}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: currentPage < imagePaths.length - 1
                    ? () {
                        setState(() {
                          currentPage++;
                        });
                      }
                    : null,
              ),
            ],
          );
  }

  // Widget to display scanned images
  Widget _buildImageGallery() {
    if (imagePaths.isEmpty) {
      return Center(
          child: Image.asset(
              'images/default.png')); // Placeholder for unscanned state
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.memory(
                imagePaths[currentPage],
                fit: BoxFit.cover,
                height: 600,
                width: 600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to List Scanners
  Future<void> _listScanners() async {
    try {
      print("Listing scanners..."); // Debug log
      final scanners = await dynamsoftService.getDevices(
        host,
        ScannerType.TWAINSCANNER | ScannerType.TWAINX64SCANNER,
      );

      devices.clear();
      scannerNames.clear();

      // Add scanners and avoid duplicates in scannerNames
      for (var scanner in scanners) {
        if (!scannerNames.contains(scanner['name'])) {
          devices.add(scanner);
          scannerNames.add(scanner['name']);
        }
      }

      setState(() {
        if (scannerNames.isNotEmpty) {
          _selectedScanner = scannerNames[0];
        }
      });
      print("Scanners found: $scannerNames"); // Debug log
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  // Function to Start Document Scan
  Future<void> _startScan() async {
    print("Scan Document button pressed..."); // Debug log
    if (_selectedScanner != null) {
      int index = scannerNames.indexOf(_selectedScanner!);
      await _scanDocument(index);
    }
  }

  // Function to Scan Document
  Future<void> _scanDocument(int index) async {
    print(
        "Starting scan for scanner: ${devices[index]['device']}"); // Debug log
    final Map<String, dynamic> parameters = {
      'license':
          't01898AUAAFI2dqdd6qhAtJwiVbIp3yqHm5pca2Zjq8ifagRJqUBodcZouee2X5hR39JwyO7iYhwFJ6EhrEisEZjbDoEDHbbdfjnVwGn1nYb6TjZw6pITeEzDOJ92+MblAGXgOQG2XocVYAnMueyAoVtyowfIA8wBzMuBHnC6iuPmC/sCKf/+c6CjUw2cVt9ZFkgdJxs4dcmZCqSPCO+02vdcICxvzgaQB9gpwOUhOxQI9oA8wA5AIKIF0wcsczF3',
      'device': devices[index]['device'],
    };

    parameters['config'] = {
      'IfShowUI': ifShowUI,
      'PixelType': 2,
      'Resolution': resolution,
      'IfFeederEnabled': ifFeederEnabled,
      'IfDuplexEnabled': ifDuplexEnabled,
    };

    try {
      final String jobId =
          await dynamsoftService.scanDocument(host, parameters);

      print("Scan job started with jobId: $jobId"); // Debug log
      if (jobId != '') {
        List<Uint8List> paths =
            await dynamsoftService.getImageStreams(host, jobId);
        await dynamsoftService.deleteJob(host, jobId);

        if (paths.isNotEmpty) {
          setState(() {
            imagePaths = paths; // Update image list
            currentPage = 0; // Reset pagination
          });
          print("Scan completed and images loaded"); // Debug log
        }
      }
    } catch (error) {
      print('An error occurred while scanning: $error');
    }
  }
}
