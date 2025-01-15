import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twain_scanner/dynamsoft_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tenderboard/common/widgets/document_viewer.dart';

// ignore: must_be_immutable
class Scanner extends StatefulWidget {
  Scanner({super.key, this.scanDocumnets});

  Function(List<String>)? scanDocumnets;
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
  bool scanning = false;

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

        startScan: _startScan, // Pass the function to start scanning
        showScannerDialog: showAlertBox,
        scanning: scanning, // Pass the function to show the dialog
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
    setState(() {
      scanning = true;
    });
    final selectedIndex = scannerNames.indexOf(_selectedScanner!);
    if (selectedIndex >= 0) {
      await _scanDocument(selectedIndex);
    }
  }

  Future<void> _scanDocument(int index) async {
    final Map<String, dynamic> parameters = {
      'license': dotenv.env['SCANNER_LICENSE'],
      'device': devices[index]['device'],
      'config': {
        'IfShowUI': ifShowUI,
        'PixelType': colorMode, // 1: Black & White, 2: Grayscale, 3: Color
        'Resolution': resolution,
        'IfFeederEnabled': ifFeederEnabled,
        'IfDuplexEnabled': ifDuplexEnabled,
      },
    };
    print(parameters);

    try {
      final String jobId =
          await dynamsoftService.scanDocument(host, parameters);

      if (jobId != '') {
        print(jobId);
        // Fetch image streams (Uint8List) from the scanner service
        List<Uint8List> imageStreams =
            await dynamsoftService.getImageStreams(host, jobId);

        // Update UI with the raw images
        setState(() {
          imagePaths
              .addAll(imageStreams); // Append raw image streams to the list
          currentPage = imagePaths.length - imageStreams.length;
          scanning = false;
        });

        if (widget.scanDocumnets != null) {
          List<String> base64Strings =
              await compute(_convertToBase64, imagePaths);
          widget.scanDocumnets!(base64Strings);
        }
      }
    } catch (e) {
      print('Error during scanning: $e');
    }
  }

// Background function to convert a list of images to Base64
  List<String> _convertToBase64(List<Uint8List> images) {
    return images.map((image) => base64Encode(image)).toList();
  }
}
