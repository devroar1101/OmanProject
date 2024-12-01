import 'package:flutter/material.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/department_master/model/department_repo.dart';
import 'package:tenderboard/admin/department_master/screens/deparment_form.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

class DepartmentMasterScreen extends StatefulWidget {
  const DepartmentMasterScreen({super.key});

  @override
  _DepartmentMasterScreenState createState() => _DepartmentMasterScreenState();
}

class _DepartmentMasterScreenState extends State<DepartmentMasterScreen> {
  final DepartmentMasterRepository _repository = DepartmentMasterRepository();
  final List<Department> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Department>>(
        future: _repository.fetchDepartments(),
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
              'DG',
            ];
            final dataKeys = [
              'departmentCode',
              'departmentNameArabic',
              'departmentNameEnglish',
              'dgNameEnglish',
            ];

            // Convert ListMasterItem list to map list with sno
            final details = Department.listToMap(items);

            // Pass the converted list to DisplayDetails
            return Column(
              children: [
                const DepartmentSearchForm(),
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
