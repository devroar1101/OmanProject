import 'package:flutter/material.dart';
import 'package:tenderboard/common/themes/app_theme.dart';
import 'package:tenderboard/common/widgets/scanner.dart';
import 'package:tenderboard/office/letter/screens/letter_form.dart';

class LetterIndex extends StatefulWidget {
  const LetterIndex({super.key});

  @override
  _LetterIndexState createState() => _LetterIndexState();
}

class _LetterIndexState extends State<LetterIndex> {
  List<String> scanDocuments = [];

  void clear() {
    setState(() {});
  }

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
                      child: LetterForm(
                        screenName: 'LetterIndex',
                        scanDocumnets: scanDocuments,
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
            child: Scanner(
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
