import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

import 'package:tenderboard/common/widgets/load_letter_document.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';
import 'package:tenderboard/office/document_search/model/document_search_filter_repo.dart';
import 'package:tenderboard/office/document_search/model/document_search_repo.dart';

import 'package:tenderboard/office/letter/screens/letter_form.dart';
import 'package:tenderboard/office/letter_summary/screens/letter_routing.dart';

class DocumentSearchHome extends ConsumerStatefulWidget {
  const DocumentSearchHome({super.key});
  @override
  _StackWithSliderState createState() => _StackWithSliderState();
}

class _StackWithSliderState extends ConsumerState<DocumentSearchHome> {
  late int totalCount;

  String? selectedLetter;
  String _selectedTab = "Details";

  void selectLetter(String letterObjectId) {
    setState(() {
      selectedLetter = letterObjectId;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the visibility state
    final isSliderVisible = ref.watch(sliderVisibilityProvider);
    final listResponse = ref.watch(documentSearchProvider);
    final filter = ref.watch(documentSearchFilterProvider);
    totalCount = listResponse.totalCount ?? 0;

    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Pagination(
                          totalItems: totalCount,
                          initialPageSize: filter['pagination']['pageSize'],
                          onPageChange: (pagenumber, pagesize) {
                            updatePagination(ref,
                                pageNumber: pagenumber, pageSize: pagesize);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            selectedLetter = null;
                            ref
                                .read(sliderVisibilityProvider.notifier)
                                .toggleVisibility();
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 2,
                      child: DisplayDetails(
                        selected: selectedLetter,
                        detailKey: 'objectId',
                        headers: const [
                          'Subject',
                          'Reference #',
                          'Location',
                          'Direction',
                        ],
                        data: const [
                          'subject',
                          'referenceNumber',
                          'externallocation',
                          'direction',
                        ],
                        details: listResponse.data?.map((searchItem) {
                              return searchItem.toMap();
                            }).toList() ??
                            [],
                        onTap: (id) {
                          selectLetter(id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedLetter != null)
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildTab("Details"),
                            const SizedBox(
                              width: 5,
                            ),
                            _buildTab("Letter"),
                            const SizedBox(
                              width: 5,
                            ),
                            _buildTab("Routing"),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 12),
                            child: Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Container(
                                  color: Colors
                                      .grey[200], // Optional background color
                                  child: _buildHelperContent(selectedLetter!),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                )
            ],
          ),
          // Sliding DocumentSearchForm
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right: !isRtl
                ? isSliderVisible
                    ? 0
                    : -MediaQuery.of(context).size.width * 0.6
                : null,
            left: isRtl
                ? isSliderVisible
                    ? 0
                    : -MediaQuery.of(context).size.width * 0.6
                : null,
            top: 200,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Material(
              shadowColor: Colors.grey,
              borderRadius: BorderRadius.circular(12),
              elevation: 5,
              color: Colors.grey[200],
              child: LetterForm(screenName: "Search"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelperContent(String letterObjectId) {
    switch (_selectedTab) {
      case "Details":
        return LetterForm(
          screenName: 'LetterSummary',
          letterObjectId: letterObjectId,
          key: ValueKey(letterObjectId),
        );
      case "Routing":
        return RoutingHistory(
          objectId: letterObjectId,
          key: ValueKey(letterObjectId),
        );

      case "Letter":
        return LoadLetterDocument(
          objectId: letterObjectId,
          key: ValueKey(letterObjectId),
        );
      default:
        return const Center(child: Text("Invalid Tab"));
    }
  }

  Widget _buildTab(String label) {
    final isSelected = _selectedTab == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
