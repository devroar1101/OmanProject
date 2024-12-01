import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_twain_scanner/dynamsoft_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tenderboard/common/widgets/document_viewer.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});
  @override
  _ScannerAppState createState() => _ScannerAppState();
}

class _ScannerAppState extends State<Scanner> {
  final DynamsoftService dynamsoftService = DynamsoftService();
  String host = dotenv.env['HOST_ADDRESS']!;

  List<Map<String, dynamic>> devices = [];
  List<String> scannerNames = [];
  String? _selectedScanner;
  List<Uint8List> imagePaths = [];
  int currentPage = 0;

  // Configuration settings for scanning
  bool ifFeederEnabled = false;
  bool ifDuplexEnabled = false;
  int resolution = 200;
  int colorMode = 2; // Default to 'Color'
  bool ifShowUI = false;

  @override
  void initState() {
    super.initState();
    _listScanners(); // Initialize scanner list on startup
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DocumentViewer(
        imagePaths: imagePaths,
        initialPage: 0,
        startScan: _startScan, // Pass the function to start scanning
        showScannerDialog: showAlertBox, // Pass the function to show the dialog
      ),
    );
  }

  // Alert Box with Scanner Control Panel
  void showAlertBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            // Ensure dialog reacts to state changes
            builder: (context, setDialogState) {
              return _buildScannerControlPanel(setDialogState);
            },
          ),
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
  Widget _buildScannerControlPanel(StateSetter setDialogState) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Scanner Selection Dropdown
            const Text('Select Scanner',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedScanner,
              items: scannerNames
                  .map((scanner) => DropdownMenuItem<String>(
                        value: scanner,
                        child: Text(scanner),
                      ))
                  .toList(),
              onChanged: (newValue) {
                setDialogState(() {
                  _selectedScanner = newValue;
                });
                setState(() {
                  _selectedScanner = newValue;
                });
              },
            ),
            const SizedBox(height: 10),

            // Color Configuration Dropdown
            const Text('Color Configuration',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<int>(
              value: colorMode,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Black & White')),
                DropdownMenuItem(value: 1, child: Text('Grayscale')),
                DropdownMenuItem(value: 2, child: Text('Color')),
              ],
              onChanged: (newValue) {
                setDialogState(() {
                  colorMode = newValue!;
                });
                setState(() {
                  colorMode = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),

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
                    setDialogState(() {
                      resolution = newValue!;
                    });
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
                    setDialogState(() {
                      ifDuplexEnabled = value;
                    });
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
                    setDialogState(() {
                      ifFeederEnabled = value;
                    });
                    setState(() {
                      ifFeederEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // UI Visibility Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Show UI',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Switch(
                  value: ifShowUI,
                  onChanged: (value) {
                    setDialogState(() {
                      ifShowUI = value;
                    });
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
      'license': dotenv.env['SCANNER_LICENSE'],
      'device': devices[index]['device'],
    };
    print('1111$colorMode,$resolution,$ifFeederEnabled,$ifDuplexEnabled');
    // Adding configuration
    parameters['config'] = {
      'IfShowUI': ifShowUI,
      'PixelType': colorMode, // 1: Black & White, 2: Grayscale, 3: Color
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

        setState(() {
          imagePaths.addAll(paths); // Append new images to the existing list
          currentPage = imagePaths.length - paths.length; // Show new scans
        });
      }
    } catch (e) {
      print('Error during scanning: $e');
    }
  }
}
