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
import 'package:tenderboard/common/themes/app_theme.dart';
import 'package:tenderboard/common/utilities/auth_provider.dart';
import 'package:tenderboard/office/ejob/screens/ejob_screen.dart';
import 'package:tenderboard/office/letter/screens/letter_index.dart'; // Import the screen

/// Utility function to convert camel case or Pascal case to space-separated words
String formatTitle(String title) {
  return title.replaceAllMapped(
    RegExp(r'([a-z])([A-Z])'),
    (Match match) => '${match.group(1)} ${match.group(2)}',
  );
}

class CustomAppBar {
  /// A method to create and return a custom AppBar widget.
  static PreferredSizeWidget build({
    required BuildContext context, // Pass BuildContext here
    required String side,
    required String screenName,
    required String buttonTitle,
  }) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: const [
                Color.fromARGB(255, 10, 31, 61),
                Color.fromARGB(133, 10, 31, 61)
              ],
              begin: isRtl ? Alignment.bottomLeft : Alignment.topRight,
              end: isRtl ? Alignment.topRight : Alignment.bottomLeft),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(0, 2), // Offset in x and y direction
            ),
          ],
        ),
        child: side == 'Admin'
            ? AppBar(
                automaticallyImplyLeading: false, // Removes the pop-back icon
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/gstb_logo.png',
                        height: 40,
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    TextButton(
                      onPressed: () {
                        debugPrint('Button clicked');
                      },
                      child: Card(
                        color: const Color.fromARGB(238, 238, 238,
                            255), // Background color for the card
                        elevation: 2.0, // Elevation for shadow effect
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Rounded corners
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            formatTitle(buttonTitle), // Apply formatting
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, // Make the text bold
                              color:
                                  Color.fromARGB(255, 20, 20, 20), // Text color
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  // IconButton(
                  //   icon: const Icon(Icons.dashboard),
                  //   onPressed: () {
                  //     debugPrint('Dashboard clicked');
                  //   },
                  // ),
                  IconButton(
                    icon: const Icon(Icons.add, color: AppTheme.iconColor),
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
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/gstb_logo.png',
                        height: 40,
                        color: Colors.white,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    TextButton(
                      onPressed: () {
                        debugPrint('Button clicked');
                      },
                      child: Card(
                        color: const Color.fromARGB(255, 206, 204,
                            204), // Background color for the card
                        elevation: 2.0, // Elevation for shadow effect
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Rounded corners
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            formatTitle(buttonTitle.isNotEmpty
                                ? buttonTitle
                                : 'Dashboard'), // Apply formatting
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, // Make the text bold
                              color:
                                  Color.fromARGB(255, 20, 20, 20), // Text color
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.person_outline_rounded,
                      color: AppTheme.iconColor,
                    ),
                    onPressed: () {
                      debugPrint('Profile clicked');
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.scanner_outlined,
                      color: AppTheme.iconColor,
                    ),
                    tooltip: 'Scan',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const LetterIndex()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.note_add_outlined,
                      color: AppTheme.iconColor,
                    ),
                    tooltip: 'Ejob',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const EjobScreen()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: AppTheme.iconColor,
                    ),
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
