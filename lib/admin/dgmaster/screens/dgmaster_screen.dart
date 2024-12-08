import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/model/dgmaster_repo.dart';
import 'package:tenderboard/admin/dgmaster/screens/add_dgmaster.dart';
import 'package:tenderboard/admin/dgmaster/screens/dgmaster_form.dart';
import 'package:tenderboard/common/widgets/displaydetails.dart';

class DgMasterScreen extends ConsumerStatefulWidget {
  const DgMasterScreen({super.key});

  @override
  _DgMasterScreenState createState() => _DgMasterScreenState();
}

class _DgMasterScreenState extends ConsumerState<DgMasterScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(dgMasterRepositoryProvider.notifier).fetchDgMasters();
  }

  @override
  Widget build(BuildContext context) {
    final dgMasters = ref.watch(dgMasterRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DG Master'),
      ),
      body: Column(
        children: [
          const DgMasterSearchForm(),
          if (dgMasters.isEmpty)
            const Center(child: Text('No items found'))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DisplayDetails(
                  headers: const ['Code', 'Name Arabic', 'Name English'],
                  data: const ['code', 'nameArabic', 'nameEnglish'],
                  details: DgMaster.listToMap(dgMasters),
                  expandable: true,
                  onTap: (int index) {
                    final DgMaster currentDgMaster = dgMasters
                        .firstWhere((dgMaster) => dgMaster.id == index);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddDGmasterScreen(
                          currentDGId: currentDgMaster.id,
                          editNameArabic: currentDgMaster.nameArabic,
                          editNameEnglish: currentDgMaster.nameEnglish,
                        );
                      },
                    );
                  },
                  detailKey: 'id',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
