import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/letter_subject/model/letter_subjecct.dart';
import 'package:tenderboard/admin/letter_subject/model/letter_subject_repo.dart';
import 'package:tenderboard/admin/letter_subject/screens/add_letter_subject.dart';
import 'package:tenderboard/admin/letter_subject/screens/letter_subject_form.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

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

  @override
  Widget build(BuildContext context) {
    final letterSubjects = ref.watch(LetterSubjectMasterRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Letter Subject Master'),
      ),
      body: Column(
        children: [
          const LetterSubjectSearchForm(),
          if (letterSubjects.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const ['Tender Number', 'Subject'],
                  data: const ['tenderNumber', 'subject'],
                  details: LetterSubjecct.listToMap(letterSubjects),
                  expandable: true,
                  onTap: (int index) {
                    final LetterSubjecct currentSubject = letterSubjects
                        .firstWhere((subject) => subject.subjectId == index);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddLetterSubject(
                          currentSubject: currentSubject,
                        
                          );
                      },
                    );
                  },
                  detailKey: 'subjectId',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
