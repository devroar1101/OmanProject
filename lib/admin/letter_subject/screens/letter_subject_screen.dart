import 'package:flutter/material.dart';
import 'package:tenderboard/admin/letter_subject/model/letter_subjecct.dart';
import 'package:tenderboard/admin/letter_subject/model/letter_subject_repo.dart';
import 'package:tenderboard/admin/letter_subject/screens/letter_subject_form.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

class LetterSubjectMasterScreen extends StatefulWidget {
  const LetterSubjectMasterScreen({super.key});

  @override
  _LetterSubjectMasterScreenState createState() => _LetterSubjectMasterScreenState();
}

class _LetterSubjectMasterScreenState extends State<LetterSubjectMasterScreen> {
  final LetterSubjectMasterRepository _repository = LetterSubjectMasterRepository();
  final List<LetterSubjecct> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<LetterSubjecct>>(
        future: _repository.fetchLetterSubjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found'));
          } else {
            final items = snapshot.data!;

            // Define headers and data keys
            final headers = [
              'Tender Number',
              'Subject',
            ];
            final dataKeys = [
              'tenderNumber',
              'subjectNameEnglish',
            ];

            // Convert ListMasterItem list to map list with sno
            final details = LetterSubjecct.listToMap(items);

            // Pass the converted list to DisplayDetails
            return Column(
              children: [
                const LetterSubjectSearchForm(),
                Expanded(
                  child: Stack(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DisplayDetails(
                            detailKey: 'objectId',
                            headers: headers,
                            data: dataKeys,
                            details: details, // Pass the list of maps
                            expandable: true, // Set false to expand by default
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
