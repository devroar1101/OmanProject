import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/section_master/model/section_master.dart';
import 'package:tenderboard/admin/section_master/model/section_master_repo.dart';
import 'package:tenderboard/admin/section_master/screens/add_section_master.dart';
import 'package:tenderboard/admin/section_master/screens/section_master_form.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

class SectionMasterScreen extends ConsumerStatefulWidget {
  const SectionMasterScreen({super.key});

  @override
  _SectionMasterScreenState createState() => _SectionMasterScreenState();
}

class _SectionMasterScreenState extends ConsumerState<SectionMasterScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch initial sections when the screen initializes
    ref.read(sectionMasterRepositoryProvider.notifier).fetchSections();
  }

  @override
  Widget build(BuildContext context) {
    final sections = ref.watch(sectionMasterRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Section Master'),
      ),
      body: Column(
        children: [
          const SectionMasterSearchForm(), // Search form widget
          if (sections.isEmpty)
            const Expanded(child: Center(child: Text('No sections found')))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const [
                    'Code',
                    'Name Arabic',
                    'Name English',
                    'Department',
                  ], // Headers for columns
                  data: const [
                    'code',
                    'sectionNameArabic',
                    'sectionNameEnglish',
                    'departmentId',
                  ], // Keys to extract data
                  details: SectionMaster.listToMap(sections), // Convert list to map
                  expandable: true, // Expandable table rows
                  onTap: (int index) {
                    final SectionMaster currentSection = sections
                        .firstWhere((section) => section.sectionId == index);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddSectionMaster(currentSection: currentSection,);
                      },
                    );
                  },
                  detailKey: 'sectionId', // Unique key for row selection
                ),
              ),
            ),
        ],
      ),
    );
  }
}
