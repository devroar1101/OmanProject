import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/office/letter_summary/screens/letter_routing.dart';
import 'package:tenderboard/office/letter_summary/screens/letter_summary.dart';
import 'package:tenderboard/office/search_screens/model/list_repo.dart';
import 'package:tenderboard/office/search_screens/screens/list_page_form.dart';

class ListPage extends ConsumerStatefulWidget {
  final String screenName;
  const ListPage({required this.screenName, Key? key}) : super(key: key);

  @override
  ConsumerState<ListPage> createState() => _ListPageState();
}

class _ListPageState extends ConsumerState<ListPage> {
  late int pageSize;
  late int pageNumber;
  String? searchFor;
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    pageSize = 15;
    pageNumber = 1;
    _loadFuture = _fetchData();
  }

  Future<void> _fetchData() {
    return ref.read(inboxRepositoryProvider.notifier).fetchInbox(
          screenName: widget.screenName,
          pageNumber: pageNumber,
          pageSize: pageSize,
          searchFor: searchFor,
        );
  }

  void _search(String query) {
    searchFor = query;
    setState(() {
      _loadFuture = _fetchData();
    });
  }

  void _updatePagination(int newPage, int newSize) {
    pageNumber = newPage;
    pageSize = newSize;
    setState(() {
      _loadFuture = _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final listResponse = ref.watch(inboxRepositoryProvider);

    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState != ConnectionState.done;

        return Column(
          children: [
            ListSearchForm(
              totalCount: listResponse.totalCount ?? 0,
              pageSize: pageSize,
              pagenumber: pageNumber,
              reset: () {
                searchFor = null;
                setState(() {
                  _loadFuture = _fetchData();
                });
              },
              search: _search,
              updatepagenation: _updatePagination,
            ),
            Expanded(
              child: isLoading || listResponse.data == null
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
                                child: RoutingHistory(objectId: id),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
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
