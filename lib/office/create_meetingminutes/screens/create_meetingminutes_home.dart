import 'package:flutter/material.dart';
import 'package:tenderboard/common/themes/app_theme.dart';
import 'package:tenderboard/common/widgets/scanner.dart';
import 'package:tenderboard/office/create_meetingminutes/screens/create_meetingminutes_form.dart';

class CreateMeetingMinutesScreen extends StatelessWidget {
  const CreateMeetingMinutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Side - ScanIndexFormIndex widget (50% width)
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Container(
                    color: AppTheme.cardColor,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child:MeetingMinutesForm(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Right Side - Empty Space (50% width)
          Expanded(
            flex: 1,
            child: Scanner(
              
            ),
          ),
        ],
      ),
    );
  }
}