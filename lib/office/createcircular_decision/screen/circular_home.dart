import 'package:flutter/material.dart';
import 'package:tenderboard/common/themes/app_theme.dart';
import 'package:tenderboard/common/widgets/load_letter_document.dart';
import 'package:tenderboard/common/widgets/scanner.dart';
import 'package:tenderboard/office/List_circular/model/circular_decision.dart';
import 'package:tenderboard/office/createcircular_decision/screen/create_circular_decision_form.dart';

class CreateCircularAndDecision extends StatefulWidget {
  const CreateCircularAndDecision({super.key, this.currentDocument});
  final CircularDecisionSearch? currentDocument;
  @override
  _CircularDecisionState createState() => _CircularDecisionState();
}

class _CircularDecisionState extends State<CreateCircularAndDecision> {
  List<String> scanDocuments = [];

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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularDecisionForm(
                        currentDocument: widget.currentDocument,
                        scanDocuments: scanDocuments,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Right Side - Empty Space (50% width)
          Expanded(
            flex: 1,
            child: widget.currentDocument != null ? LoadLetterDocument(objectId: widget.currentDocument!.objectId,) : Scanner(
              scanDocumnets: (scanDocuments) => setState(() {
                this.scanDocuments = scanDocuments;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
