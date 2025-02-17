import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/letter_subject/model/letter_subjecct.dart';
import 'package:tenderboard/admin/letter_subject/model/letter_subject_repo.dart';
import 'package:tenderboard/admin/letter_subject/screens/add_letter_subject.dart';
import 'package:tenderboard/admin/letter_subject/screens/letter_subject_form.dart';
import 'package:tenderboard/common/widgets/custom_alert_box.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';
import 'package:tenderboard/common/widgets/pagenation.dart';

class LetterSubjectMasterScreen extends ConsumerStatefulWidget {
  const LetterSubjectMasterScreen({super.key});

  @override
  _LetterSubjectMasterScreenState createState() =>
      _LetterSubjectMasterScreenState();
}

class _LetterSubjectMasterScreenState
    extends ConsumerState<LetterSubjectMasterScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch Letter Subjects during initialization
    ref
        .read(LetterSubjectMasterRepositoryProvider.notifier)
        .fetchLetterSubjects();
  }

  String searchTenderNumber = '';
  String searchSubject = '';
  int pageNumber = 1; // Default to the first page
  int pageSize = 15; // Default page size
  bool search = false;

  void onSearch(String tenderNumber, String letterSubject) {
    setState(() {
      searchTenderNumber = tenderNumber;
      searchSubject = letterSubject;
      search = true;
    });
  }

  List<LetterSubjecct> _applyFiltersAndPagination(
      List<LetterSubjecct> letterSubjects) {
    // Apply search filters
    List<LetterSubjecct> filteredList = letterSubjects.where((singleSubject) {
      final matchesArabic = searchSubject.isEmpty ||
          singleSubject.subject
              .toLowerCase()
              .contains(searchSubject.toLowerCase());
      final matchesEnglish = searchTenderNumber.isEmpty ||
          singleSubject.tenderNumber
              .toLowerCase()
              .contains(searchTenderNumber.toLowerCase());
      return matchesArabic && matchesEnglish;
    }).toList();

    // Apply pagination
    int startIndex = (pageNumber - 1) * pageSize;
    int endIndex = startIndex + pageSize;
    endIndex = endIndex > filteredList.length ? filteredList.length : endIndex;

    return filteredList.sublist(startIndex, endIndex);
  }

  void onDelete(int subjectId) {
    ref
        .watch(LetterSubjectMasterRepositoryProvider.notifier)
        .deleteSubject(subjectId: subjectId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Subject Deleted successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final letterSubjects = ref.watch(LetterSubjectMasterRepositoryProvider);
    final filteredAndPaginatedList = _applyFiltersAndPagination(letterSubjects);
    print('subject : $letterSubjects');

    final iconButtons = [
      {
        "button": Icons.edit,
        "function": (int id) {
          final LetterSubjecct currentSubject =
              letterSubjects.firstWhere((subject) => subject.id == id);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddLetterSubject(
                currentSubject: currentSubject,
              );
            },
          );
        },
      },
      {
        "button": Icons.delete,
        "function": (int id) {
          showDialog(
            context: context,
            builder: (context) => ConfirmationAlertBox(
              messageType: 3,
              message: 'Are you sure you want to delete this subject?',
              onConfirm: () {
                onDelete(id);
              },
              onCancel: () {
                Navigator.of(context).pop(context);
              },
            ),
          );
        }
      },
    ];

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: LetterSubjectSearchForm(
                  onSearch: onSearch,
                ),
              ),
              const SizedBox(width: 8.0),
              Pagination(
                totalItems: search
                    ? letterSubjects.where((singleSubject) {
                        final matchesArabic = searchSubject.isEmpty ||
                            singleSubject.subject
                                .toLowerCase()
                                .contains(searchSubject.toLowerCase());
                        final matchesEnglish = searchTenderNumber.isEmpty ||
                            singleSubject.tenderNumber
                                .toLowerCase()
                                .contains(searchTenderNumber.toLowerCase());
                        return matchesArabic && matchesEnglish;
                      }).length
                    : letterSubjects.length,
                initialPageSize: pageSize,
                onPageChange: (pageNo, newPageSize) {
                  setState(() {
                    pageNumber = pageNo;
                    pageSize = newPageSize;
                  });
                },
              ),
            ],
          ),
          if (letterSubjects.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const ['TenderNumber', 'Subject'],
                  data: const ['tenderNumber', 'subject'],
                  details: LetterSubjecct.listToMap(filteredAndPaginatedList),
                  expandable: true,
                  iconButtons: iconButtons,
                  onTap: (id, {objectId}) {},
                  detailKey: 'id',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
