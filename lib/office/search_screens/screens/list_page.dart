import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/office/letter_summary/screens/letter_routing.dart';
import 'package:tenderboard/office/search_screens/model/list_repo.dart';
import 'package:tenderboard/office/search_screens/screens/list_page_form.dart';
import 'package:tenderboard/office/letter_summary/screens/letter_summary.dart';

class ListPage extends ConsumerStatefulWidget {
  final String screenName;
  const ListPage({required this.screenName, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ListPageState();
  }
}

class _ListPageState extends ConsumerState<ListPage> {
  late int pageSize;
  late int pageNumber;
  late String? searchFor;
  late int totalCount;
  late int? status;

  @override
  void initState() {
    super.initState();
    initialise();
  }

  void initialise() {
    pageSize = 15;
    pageNumber = 1;
    searchFor = null;
    status = null;
    ref.read(inboxRepositoryProvider.notifier).fetchInbox(
          screenName: widget.screenName,
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
  }

  void search(String searchFor) {
    ref.read(inboxRepositoryProvider.notifier).fetchInbox(
        screenName: widget.screenName,
        pageNumber: pageNumber,
        pageSize: pageSize,
        searchFor: searchFor);
  }

  void updatePagenation(int pageNumber, int pageSize) {
    ref.read(inboxRepositoryProvider.notifier).fetchInbox(
        screenName: widget.screenName,
        pageNumber: pageNumber,
        pageSize: pageSize,
        searchFor: searchFor);
    setState(() {
      this.pageNumber = pageNumber;
      this.pageSize = pageSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    final listResponse = ref.watch(inboxRepositoryProvider);
    totalCount = listResponse.totalCount!;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListSearchForm(
            totalCount: totalCount,
            pageSize: pageSize,
            pagenumber: pageNumber,
            reset: initialise,
            search: search,
            updatepagenation: updatePagenation,
          ),
          Expanded(
            child: listResponse.data == null
                ? _buildShimmerEffect()
                : DisplayDetails(
                    headers: const [
                      'Reference Number',
                      'From',
                      'Subject',
                      'Location',
                    ],
                    detailKey: 'letterObjectId',
                    data: const [
                      'referenceNumber',
                      'fromUser',
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
                    onLongPress: (id) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SizedBox(
                              child: RoutingHistory(
                                objectId: id,
                              ),
                            ),
                          );
                        },
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
