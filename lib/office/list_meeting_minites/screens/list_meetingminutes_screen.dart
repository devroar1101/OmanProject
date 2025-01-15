import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';
import 'package:tenderboard/office/List_circular/model/circular_decision.dart';
import 'package:tenderboard/office/List_circular/model/details_repo.dart';
import 'package:tenderboard/office/list_meeting_minites/screens/list_meetingminutes_form.dart';

class MeetingMinutesScreen extends ConsumerStatefulWidget {
  const MeetingMinutesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MeetingMinutesScreenState();
  }
}

class _MeetingMinutesScreenState extends ConsumerState<MeetingMinutesScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(circularDecisiondetailsRepositoryProvider.notifier)
        .fetchListCircularDecisions('2');
  }

  String searchSubject = "";
  String searchMeetingNumber = '';
  String searchPriority = '';
  String searchClassification = '';
  String searchDate = '';
  int pageNumber = 1;
  int pageSize = 15;
  bool search = false;

  void onSearch(
      String subject, String meetingNumber, String priority, String classification, String date) {
    setState(() {
      searchSubject = subject;
      searchMeetingNumber = meetingNumber;
      searchPriority = priority;
      searchClassification = classification;
      searchDate = date;
      pageNumber = 1;
      pageSize = 15;
      search = true;
    });
  }

  List<CircularDecisionSearch> _applyFiltersAndPagination(
      List<CircularDecisionSearch> meetingMinutesList) {
    if (meetingMinutesList.isEmpty) {
      return [];
    }

    List<CircularDecisionSearch> filteredList =
        meetingMinutesList.where((singleValue) {
      final matchSubject = searchSubject.isEmpty ||
          (singleValue.subject?.toLowerCase() ?? '')
              .contains(searchSubject.toLowerCase());
      final matchMeetingNumber = searchMeetingNumber.isEmpty ||
          (singleValue.meetingNumber?.toLowerCase() ?? '')
              .contains(searchMeetingNumber.toLowerCase());
      final matchPriority = searchPriority.isEmpty ||
          (singleValue.priority?.toLowerCase() ?? '')
              .contains(searchPriority.toLowerCase());
      final matchClassification = searchClassification.isEmpty ||
          (singleValue.classificationId?.toLowerCase() ?? '')
              .contains(searchClassification.toLowerCase());
      final matchDate = searchDate.isEmpty ||
          (singleValue.createdDate?.toLowerCase() ?? '')
              .contains(searchDate.toLowerCase());
      return matchSubject &&
          matchMeetingNumber &&
          matchPriority &&
          matchClassification &&
          matchDate;
    }).toList();

    // Apply pagination
    int startIndex = (pageNumber - 1) * pageSize;
    int endIndex = startIndex + pageSize;
    endIndex = endIndex > filteredList.length ? filteredList.length : endIndex;

    return filteredList.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    final meetingMinutesList = ref.watch(circularDecisiondetailsRepositoryProvider);
    final filteredAndPaginatedList =
        _applyFiltersAndPagination(meetingMinutesList);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: MeetingMinutesSearchForm(
              onSearch: onSearch,
            ),
          ),
          Pagination(
            totalItems: search
                ? filteredAndPaginatedList.where((singleValue) {
                    final matchSubject = searchSubject.isEmpty ||
                        (singleValue.subject?.toLowerCase() ?? '')
                            .contains(searchSubject.toLowerCase());
                    final matchMeetingNumber = searchMeetingNumber.isEmpty ||
                        (singleValue.meetingNumber?.toLowerCase() ?? '')
                            .contains(searchMeetingNumber.toLowerCase());
                    final matchPriority = searchPriority.isEmpty ||
                        (singleValue.priority?.toLowerCase() ?? '')
                            .contains(searchPriority.toLowerCase());
                    final matchClassification = searchClassification.isEmpty ||
                        (singleValue.classificationId?.toLowerCase() ?? '')
                            .contains(searchClassification.toLowerCase());
                    final matchDate = searchDate.isEmpty ||
                        (singleValue.createdDate?.toLowerCase() ?? '')
                            .contains(searchDate.toLowerCase());
                    return matchSubject &&
                        matchMeetingNumber &&
                        matchPriority &&
                        matchClassification &&
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
          Expanded(
              child: DisplayDetails(
            headers: const [
              'Subject',
              'Meeting Number',
              'Priority',
              'Classification',
              'Date',
            ],
            detailKey: 'objectId',
            data: const [
              'subject',
              'meetingNumber',
              'priority',
              'classification',
              'createdDate',
            ],
            details: meetingMinutesList.map((meetingItem) {
              return meetingItem.toMap();
            }).toList(),
            expandable: true,
          )),
        ],
      ),
    );
  }
}
