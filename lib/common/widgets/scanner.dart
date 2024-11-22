import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_twain_scanner/dynamsoft_service.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});
  @override
  _ScannerAppState createState() => _ScannerAppState();
}

class _ScannerAppState extends State<Scanner> {
  final DynamsoftService dynamsoftService = DynamsoftService();
  String host = 'http://127.0.0.1:18622';

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
  void initState() {
    super.initState();
    _listScanners(); // Initialize scanner list on startup
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Make the entire content scrollable
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      ListTile(
                        leading: IconButton(
                          onPressed: () {
                            showAlertBox(context);
                          },
                          icon: const Icon(Icons.menu),
                        ),
                        trailing: MaterialButton(
                          textColor: Colors.white,
                          color: Colors.green,
                          onPressed:
                              _selectedScanner != null ? _startScan : null,
                          child: const Text('Scan Document'),
                        ),
                        title: DropdownButton<String>(
                          value: _selectedScanner,
                          hint: const Text('Select Scanner'),
                          items: scannerNames.map((String scanner) {
                            return DropdownMenuItem<String>(
                              value: scanner,
                              child: Text(scanner),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedScanner = value;
                            });
                          },
                        ),
                      ),
                      // Image Gallery Stack
                      Stack(
                        children: [
                          _buildImageGallery(),
                          Positioned(child: _buildImagePagination())
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    height: 20), // Add spacing between the components
              ],
            ),
          ),
        ),
      );  
  }

  // Alert Box with Scanner Control Panel
  void showAlertBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: _buildScannerControlPanel(),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
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
                const Text('Resolution',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<int>(
                  value: resolution,
                  items: [150, 200, 300, 400]
                      .map((e) => DropdownMenuItem<int>(
                          value: e, child: Text('$e DPI')))
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
                const Text('Duplex Enabled',
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
                const Text('Feeder Enabled',
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
                const Text('Show UI',
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

  // Image Pagination Widget
  Widget _buildImagePagination() {
    return imagePaths.isEmpty
        ? Container()
        : Center(
            child: Text(
              '${currentPage + 1} / ${imagePaths.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
  }

  // Image Gallery
  Widget _buildImageGallery() {
    if (imagePaths.isEmpty) {
      return const Center(
          child: Icon(
        Icons.scanner,
        size: 100,
      ));
    }

    return Container(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.memory(
            imagePaths[currentPage],
            fit: BoxFit.cover,
            height: 600,
            width: 600,
          ),
          Positioned(
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: Colors.amber),
              onPressed: currentPage > 0
                  ? () {
                      setState(() {
                        currentPage--;
                      });
                    }
                  : null,
            ),
          ),
          Positioned(
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward,
                  size: 30, color: Colors.amber),
              onPressed: currentPage < imagePaths.length - 1
                  ? () {
                      setState(() {
                        currentPage++;
                      });
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  // Function to List Scanners
  Future<void> _listScanners() async {
    try {
      final scanners = await dynamsoftService.getDevices(
        host,
        ScannerType.TWAINSCANNER | ScannerType.TWAINX64SCANNER,
      );

      devices.clear();
      scannerNames.clear();

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
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  // Start scanning based on the selected device
  Future<void> _startScan() async {
    final selectedIndex = scannerNames.indexOf(_selectedScanner!);
    if (selectedIndex >= 0) {
      await _scanDocument(selectedIndex);
    }
  }

  Future<void> _scanDocument(int index) async {
    print("Starting scan for scanner: ${devices[index]['device']}");
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

      print("Scan job started with jobId: $jobId");
      if (jobId != '') {
        List<Uint8List> paths =
            await dynamsoftService.getImageStreams(host, jobId);
        await dynamsoftService.deleteJob(host, jobId);

        if (paths.isNotEmpty) {
          setState(() {
            imagePaths = paths; // Update image list
            currentPage = 0; // Reset pagination
          });
          print("Scan completed and images loaded");
        }
      }
    } catch (error) {
      print('An error occurred while scanning: $error');
    }
  }
}
