import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/department_master/model/department.dart';
import 'package:tenderboard/admin/department_master/model/department_repo.dart';
import 'package:tenderboard/admin/department_master/screens/add_department.dart';
import 'package:tenderboard/admin/department_master/screens/deparment_form.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

class DepartmentMasterScreen extends ConsumerStatefulWidget {
  const DepartmentMasterScreen({super.key});

  @override
  _DepartmentMasterScreenState createState() => _DepartmentMasterScreenState();
}

class _DepartmentMasterScreenState extends ConsumerState<DepartmentMasterScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(departmentMasterRepositoryProvider.notifier).fetchDepartments();
  }

  @override
  Widget build(BuildContext context) {
    final departments = ref.watch(departmentMasterRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Master'),
      ),
      body: Column(
        children: [
          const DepartmentSearchForm(), // Search form widget
          if (departments.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const [
                    'Code',
                    'Name Arabic',
                    'Name English',
                    'DG Name',
                  ], // Headers for columns
                  data: const [
                    'code',
                    'departmentNameArabic',
                    'departmentNameEnglish',
                    'dgId',
                  ], // Keys to extract data
                  details: Department.listToMap(departments), // Convert list to map
                  expandable: true, // Expandable table rows
                  onTap: (int index) {
                    final Department currentDepartment = departments
                        .firstWhere((department) => department.id == index);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return  AddDepartmentMaster(currentDepartment: currentDepartment,);
                      },
                    );
                  },
                  detailKey: 'id', // Unique key for row selection
                ),
              ),
            ),
        ],
      ),
    );
  }
}
