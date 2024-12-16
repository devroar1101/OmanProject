import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/scanner.dart';
import 'package:tenderboard/office/scan_document_summary/model/scan_document_summary.dart';
import 'package:tenderboard/office/scan_document_summary/model/scan_document_summary_repo.dart';
import 'package:tenderboard/office/scan_document_summary/screens/widgets/summary_assign.dart';
import 'package:tenderboard/office/scan_document_summary/screens/widgets/summary_close.dart';
import 'package:tenderboard/office/scan_document_summary/screens/widgets/summary_followUp.dart';
import 'package:tenderboard/office/scan_document_summary/screens/widgets/summary_reply.dart';
import 'package:tenderboard/office/scan_document_summary/screens/widgets/summary_suspent.dart';

class ScanDocumentSummaryScreen extends StatefulWidget {
  final String scanDocumentObjectId;
  const ScanDocumentSummaryScreen(this.scanDocumentObjectId, {super.key});

  @override
  _ScanDocumentSummaryScreenState createState() =>
      _ScanDocumentSummaryScreenState();
}

class _ScanDocumentSummaryScreenState extends State<ScanDocumentSummaryScreen> {
  final ScanSummaryRepository _repository = ScanSummaryRepository();
  ScanDocumentSummary? _singleScanIndexItem;
  bool _isLoading = false;
  String _selectedTab = "Details";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchSingleScanIndexData() async {
    try {
      ScanDocumentSummary? item = await _repository.fetchSingleScanSummaryItem(
        scanDocumentObjectId: widget.scanDocumentObjectId,
      );
      setState(() {
        _singleScanIndexItem = item;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching single scan index item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              // width: MediaQuery.of(context).size.width * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Details";
                    }),
                    child: const Text("Details"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Routing";
                    }),
                    child: const Text("Routing"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Attachment";
                    }),
                    child: const Text("Attachment"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Assign Job";
                    }),
                    child: const Text("Assign Job"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Follo_UP Job";
                    }),
                    child: const Text("Follo_UP Job"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Reply Job";
                    }),
                    child: const Text("Reply Job"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Suspent Job";
                    }),
                    child: const Text("Suspent Job"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedTab = "Close Job";
                    }),
                    child: const Text("Close Job"),
                  ),
                ],
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _singleScanIndexItem != null
              ? const Center(child: Text('No data found for the given ID'))
              : Row(
                  children: [
                    // Left Side - Conditional Content
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height,
                            ),
                            child: IntrinsicHeight(
                              child: _buildContent(),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Right Side - Empty Space
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey[200], // Optional background color
                        child: const Scanner(), // Your scanner widget here
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTab) {
      case "Details":
        return const Center(child: Text("Routing Content Placeholder"));
      case "Routing":
        return const Center(child: Text("Routing Content Placeholder"));
      case "Attachment":
        return const Center(child: Text("Attachment Content Placeholder"));
      case "Assign Job":
        return const JobAssignForm();
      case "Follo_UP Job":
        return FollowUpJobsForm(); // Display JobAssignForm widget here
      case "Reply Job":
        return const ReplyJobForm(); // Display JobAssignForm widget here
      case "Suspent Job":
        return const SuspendJobForm(); // Display JobAssignForm widget here
      case "Close Job":
        return const CloseJobForm(); // Display JobAssignForm widget here
      default:
        return const Center(child: Text("Invalid Tab"));
    }
  }
}
