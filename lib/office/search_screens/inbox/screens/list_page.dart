import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/office/search_screens/inbox/model/list_repo.dart';
import 'package:tenderboard/office/search_screens/inbox/screens/list_page_form.dart';
import 'package:tenderboard/office/letter_summary/screens/letter_summary.dart';

class ListPage extends ConsumerStatefulWidget {
  const ListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ListPageState();
  }
}

class _ListPageState extends ConsumerState<ListPage> {
  @override
  void initState() {
    super.initState();
    ref.read(inboxRepositoryProvider.notifier).fetchInbox(screenName: 'Inbox');
  }

  @override
  Widget build(BuildContext context) {
    final listResponse = ref.watch(inboxRepositoryProvider);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: ListSearchForm(),
          ),
          Expanded(
            child: listResponse.data == null || listResponse.data!.isEmpty
                ? _buildShimmerEffect()
                : DisplayDetails(
                    headers: const [
                      'Reference Number',
                      'From',
                      'Subject',
                      'Location',
                    ],
                    detailKey: 'objectId',
                    data: const [
                      'referenceNumber',
                      'from',
                      'subject',
                      'locationNameArabic',
                    ],
                    details: listResponse.data!.map((inboxItem) {
                      return inboxItem.toMap();
                    }).toList(),
                    expandable: true,
                    onTap: (id) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LetterSummary(id!),
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
