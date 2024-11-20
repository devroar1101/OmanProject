import 'package:flutter/material.dart';
import 'package:tenderboard/office/scan_index/screens/scan_index_form.dart';

class ScanAndIndexScreen extends StatefulWidget {
  const ScanAndIndexScreen({super.key});

  @override
  _ScanAndIndexScreenState createState() => _ScanAndIndexScreenState();
}

class _ScanAndIndexScreenState extends State<ScanAndIndexScreen> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : Row(
              children: [
                // Left Side - ScanIndexFormScreen widget (50% width)
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height,
                        ),
                        child: const IntrinsicHeight(
                          child: ScanIndexHomeForm(),
                        ),
                      ),
                    ),
                  ),
                ),
                // Right Side - Empty Space (50% width)
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white, // Optional: Set to match your design
                  ),
                ),
              ],
            ),
    );
  }
}
