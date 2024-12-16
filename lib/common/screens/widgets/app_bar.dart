import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenderboard/admin/department_master/screens/add_department.dart';
import 'package:tenderboard/admin/dgmaster/screens/add_dgmaster.dart';
import 'package:tenderboard/admin/external_locations_Master/screens/add_external_location.dart';
import 'package:tenderboard/admin/letter_subject/screens/add_letter_subject.dart';
import 'package:tenderboard/admin/listmaster/screens/add_listmaster.dart';
import 'package:tenderboard/admin/listmasteritem/screens/add_listmasteritem.dart';
import 'package:tenderboard/admin/section_master/screens/add_section_master.dart';
import 'package:tenderboard/admin/user_master/screens/add_user_master.dart';
import 'package:tenderboard/common/screens/login.dart';
import 'package:tenderboard/common/utilities/auth_provider.dart'; // Import the screen

class CustomAppBar {
  /// A method to create and return a custom AppBar widget.
  static PreferredSizeWidget build({
    required BuildContext context, // Pass BuildContext here
    required String side,
    required String screenName,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(0, 3), // Offset in x and y direction
            ),
          ],
        ),
        child: side == 'Admin'
            ? AppBar(
                automaticallyImplyLeading: false, // Removes the pop-back icon
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/gstb_logo.png',
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.dashboard),
                    onPressed: () {
                      debugPrint('Dashboard clicked');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Show AddListmasterScreen as a modal
                      _showModal(context: context, screenName: screenName);
                    },
                  ),
                ],
              )
            : AppBar(
                automaticallyImplyLeading: false, // Removes the pop-back icon
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/gstb_logo.png',
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.dashboard),
                    onPressed: () {
                      debugPrint('Dashboard clicked');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.inbox),
                    onPressed: () {
                      debugPrint('Inbox clicked');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.outbox),
                    onPressed: () {
                      debugPrint('Outbox clicked');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      debugPrint('Search clicked');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      debugPrint('Profile clicked');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      // Access AuthNotifier using context
                      final authNotifier = ProviderScope.containerOf(context)
                          .read(authProvider.notifier);

                      // Call logout method
                      await authNotifier.logout();

                      // Navigate back to the login screen
                      Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }

  /// Show a modal dialog based on the screen name.
  static void _showModal({
    required BuildContext context,
    required String screenName,
  }) {
    if (screenName == 'ListMaster') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddListmasterScreen();
        },
      );
    } else if (screenName == 'DG') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDGmasterScreen();
        },
      );
    } else if (screenName == 'Department') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDepartmentMaster();
        },
      );
    } else if (screenName == 'Section') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AddSectionMaster();
        },
      );
    } else if (screenName == 'SubjectMaster') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddLetterSubject();
        },
      );
    } else if (screenName == 'User') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AddUserMasterScreen();
        },
      );
    } else if (screenName == 'ListMasterItem') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddListMasterItemScreen(
            currentListMasterId: 1,
          );
        },
      );
    } else if (screenName == 'ExternalLocation') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddExternalLocation();
        },
      );
    } else {
      debugPrint('Unhandled screenName: $screenName');
    }
  }
}
