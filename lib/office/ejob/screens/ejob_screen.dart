import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/scanner.dart'; // Assuming Scanner is imported correctly
import 'package:tenderboard/office/ejob/screens/ejob_form.dart';

class EjobScreen extends StatefulWidget {
  const EjobScreen({super.key});

  @override
  _EjobScreenState createState() => _EjobScreenState();
}

class _EjobScreenState extends State<EjobScreen> {
  final bool _isLoading = false;
  int _selectedTabIndex = 0; // Index for selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Left Side - EjobForm (50% width)
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height,
                        ),
                        child: const IntrinsicHeight(child: EjobForm()),
                      ),
                    ),
                  ),
                ),
                // Right Side - Tab View (50% width)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tab Buttons
                        Row(
                          children: [
                            _buildTabButton("Upload", 0),
                            _buildTabButton("Scan Document", 1),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Content Area Based on Selected Tab
                        Expanded(
                          child: _selectedTabIndex == 0
                              ? _buildUploadContent() // Upload Content
                              : const Scanner(), // Integrate Scanner widget here
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Build Tab Button
  Widget _buildTabButton(String title, int index) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedTabIndex == index
              ? Colors.blue
              : Colors.grey[300],
        ),
        onPressed: () => setState(() {
          _selectedTabIndex = index;
        }),
        child: Text(
          title,
          style: TextStyle(color: _selectedTabIndex == index ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  // Upload Content with Aligned Details
  Widget _buildUploadContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "File Upload",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // File upload logic
            },
            child: const Text('Upload File'),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Uploaded Details:",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 5, // Replace with actual uploaded files count
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("File $index", style: const TextStyle(fontSize: 16)),
                    Text("Details $index", style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
