import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/office/letter/screens/letter_form.dart';
import 'package:tenderboard/office/letter_summary/model/letter_summary_repo.dart';
import 'package:tenderboard/office/letter_summary/model/letter_summary_result.dart';
import 'package:tenderboard/office/letter_summary/screens/letter_routing.dart';

class SummaryDetails extends ConsumerStatefulWidget {
  const SummaryDetails({super.key, required this.letterObjectId});
  final String letterObjectId;
  @override
  _SummaryTabsState createState() => _SummaryTabsState();
}

class _SummaryTabsState extends ConsumerState<SummaryDetails> {
  String selectedTab = "Index";

  late Future<LetterSummaryResult> _letterFuture;

  Widget _buildTab(String title) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _letterFuture = ref
        .read(letterSummaryRepositoryProvider)
        .fetchLetterSummary(widget.letterObjectId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LetterSummaryResult>(
      future: _letterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading letter'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data found'));
        }

        final letter = snapshot.data!;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
                vertical: MediaQuery.of(context).size.height * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tab buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTab("Index"),
                    _buildTab("Routing"),
                  ],
                ),
                const SizedBox(height: 20),

                // Content based on selected tab

                if (selectedTab == "Index")
                  LetterForm(
                      screenName: 'LetterSummary',
                      letterObjectId: widget.letterObjectId,
                      letter: letter),
                if (selectedTab == "Routing")
                  SizedBox(
                      height: 600,
                      child: RoutingHistory(objectId: widget.letterObjectId)),
              ],
            ),
          ),
        );
      },
    );
  }
}
