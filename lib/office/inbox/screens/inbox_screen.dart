import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/office/inbox/model/inbox_repo.dart';
import 'package:tenderboard/office/inbox/screens/inbox_form.dart';
import 'package:tenderboard/office/scan_document_summary/screens/scan_document_summary_screen.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _InboxScreenState();
  }
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(inboxRepositoryProvider.notifier).fetchInbox(userId: 1);
  }

  @override
  Widget build(BuildContext context) {
    final inboxProvider = ref.watch(inboxRepositoryProvider);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: InboxSearchForm(),
          ),
          Expanded(
            child: inboxProvider.isEmpty
                ? _buildShimmerEffect()
                : DisplayDetails(
                    headers: const [
                      'Reference #',
                      'System Name',
                      'Subject',
                      'Location (Arabic)',
                      'Location (English)',
                    ],
                    detailKey: 'letterObjectId',
                    data: const [
                      'referenceNumber',
                      'systemName',
                      'subject',
                      'locationNameArabic',
                      'locationNameEnglish',
                    ],
                    details: inboxProvider.map((inboxItem) {
                      return inboxItem.toMap();
                    }).toList(),
                    expandable: true,
                    onTap: (int index) {
                      final letterObjectId =
                          inboxProvider[index].letterObjectId;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ScanDocumentSummaryScreen(letterObjectId!),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          );
        },
      ),
    );
  }
}
