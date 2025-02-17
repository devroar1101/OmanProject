import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';
import 'package:tenderboard/office/List_circular/model/circular_decision.dart';
import 'package:tenderboard/office/List_circular/model/details_repo.dart';
import 'package:tenderboard/office/List_circular/screens/circular_form.dart';
import 'package:tenderboard/office/createcircular_decision/screen/circular_home.dart';

class CircularListScreen extends ConsumerStatefulWidget {
  const CircularListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CircularScreen();
  }
}

class _CircularScreen extends ConsumerState<CircularListScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(circularDecisiondetailsRepositoryProvider.notifier)
        .fetchListCircularDecisions('1');
  }

  String searchSubject = "";
  String searchNumber = '';
  String searchDocumentType = '';
  String searchDate = '';
  int pageNumber = 1;
  int pageSize = 15;
  bool search = false;

  void onSearch(
      String subject, String? number,  String? date) {
    setState(() {
      searchSubject = subject;
      searchNumber = number!;
      // searchDocumentType = documentType!;
      searchDate = date!;
      pageNumber = 1;
      pageSize = 15;
      search = true;
    });
  }

  List<CircularDecisionSearch> _applyFiltersAndPagination(
      List<CircularDecisionSearch> circularDecisionList) {
    if (circularDecisionList.isEmpty) {
      return [];
    }

    List<CircularDecisionSearch> filteredList =
        circularDecisionList.where((singleValue) {
      final matchSubject = searchSubject.isEmpty ||
          (singleValue.subject?.toLowerCase() ?? '')
              .contains(searchSubject.toLowerCase());
      final matchNumber = searchNumber.isEmpty ||
          (singleValue.documentNumber?.toLowerCase() ?? '')
              .contains(searchNumber.toLowerCase());
      final matchDocumentType = searchDocumentType.isEmpty ||
          (singleValue.documentType?.toLowerCase() ?? '')
              .contains(searchDocumentType.toLowerCase());
      final matchDate = searchDate.isEmpty ||
          (singleValue.createdDate?.toLowerCase() ?? '')
              .contains(searchDate.toLowerCase());
      return matchSubject && matchNumber && matchDocumentType && matchDate;
    }).toList();
    // Apply pagination
    int startIndex = (pageNumber - 1) * pageSize;
    int endIndex = startIndex + pageSize;
    endIndex = endIndex > filteredList.length ? filteredList.length : endIndex;

    return filteredList.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    final circularDecisionList =
        ref.watch(circularDecisiondetailsRepositoryProvider);
    final filteredAndPaginatedList =
        _applyFiltersAndPagination(circularDecisionList);
    print('11212 $circularDecisionList');
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CircularForm(
              onSearch: onSearch,
            ),
          ),
          Pagination(
            totalItems: search
                ? filteredAndPaginatedList.where((singleValue) {
                    final matchSubject = searchSubject.isEmpty ||
                        (singleValue.subject?.toLowerCase() ?? '')
                            .contains(searchSubject.toLowerCase());
                    final matchNumber = searchNumber.isEmpty ||
                        (singleValue.documentNumber?.toLowerCase() ?? '')
                            .contains(searchNumber.toLowerCase());
                    final matchDocumentType = searchDocumentType.isEmpty ||
                        (singleValue.documentType?.toLowerCase() ?? '')
                            .contains(searchDocumentType.toLowerCase());
                    final matchDate = searchDate.isEmpty ||
                        (singleValue.createdDate?.toLowerCase() ?? '')
                            .contains(searchDate.toLowerCase());
                    return matchSubject &&
                        matchNumber &&
                        matchDocumentType &&
                        matchDate;
                  }).length
                : filteredAndPaginatedList.length,
            initialPageSize: pageSize,
            onPageChange: (pageNo, newPageSize) {
              setState(() {
                pageNumber = pageNo;
                pageSize = newPageSize;
              });
            },
          ),
          // The empty space
          Expanded(
              child: DisplayDetails(
            headers: const [
              'Subject',
              'Number',
              'Document Type',
              'Date',
            ],
            detailKey: 'objectId',
            data: const [
              'subject',
              'documentNumber',
              'documentType',
              'createdDate',
            ],
            details: filteredAndPaginatedList.map((circulatItem) {
              return circulatItem.toMap();
            }).toList(),
            expandable: true,
           
            onTap: (id){
               final CircularDecisionSearch currentdocument = filteredAndPaginatedList.firstWhere((single) => single.objectId == id );
               print(currentdocument.objectId);
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => CreateCircularAndDecision(currentDocument: currentdocument,), ));
            },
          )),
        ],
      ),
    );
  }
}
