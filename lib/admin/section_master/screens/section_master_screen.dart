import 'package:flutter/material.dart';
import 'package:tenderboard/admin/section_master/model/section_master.dart';
import 'package:tenderboard/admin/section_master/model/section_master_repo.dart';
import 'package:tenderboard/admin/section_master/screens/section_master_form.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

class SectionMasterScreen extends StatefulWidget {
  const SectionMasterScreen({super.key});

  @override
  _SectionMasterScreenState createState() => _SectionMasterScreenState();
}

class _SectionMasterScreenState extends State<SectionMasterScreen> {
  final SectionMasterRepository _repository = SectionMasterRepository();
  final List<SectionMaster> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<SectionMaster>>(
        future: _repository.fetchSections(),
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
              'code',
              'Name Arabic',
              'Name English',
              'Department',
            ];
            final dataKeys = [
              'sectionCode',
              'sectionNameArabic',
              'sectionNameEnglish',
              'departmentNameEnglish',
            ];

            // Convert ListMasterItem list to map list with sno
            final details = SectionMaster.listToMap(items);

            // Pass the converted list to DisplayDetails
            return Column(
              children: [
                const SectionMasterSearchForm(),
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
