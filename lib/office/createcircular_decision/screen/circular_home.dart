import 'package:flutter/material.dart';
import 'package:tenderboard/common/themes/app_theme.dart';
import 'package:tenderboard/common/widgets/scanner.dart';
import 'package:tenderboard/office/createcircular_decision/screen/create_circular_decision_form.dart';

class CreateCircularAndDecision extends StatelessWidget {
  const CreateCircularAndDecision({super.key});

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
                      child:CircularDecisionForm(),
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
