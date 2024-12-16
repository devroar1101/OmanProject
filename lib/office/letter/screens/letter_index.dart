import 'package:flutter/material.dart';
import 'package:tenderboard/common/widgets/scanner.dart';
import 'package:tenderboard/office/letter/screens/letter_form.dart';

class LetterIndex extends StatefulWidget {
  const LetterIndex({super.key});

  @override
  _LetterIndexState createState() => _LetterIndexState();
}

class _LetterIndexState extends State<LetterIndex> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : Row(
              children: [
                // Left Side - ScanIndexFormIndex widget (50% width)
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height,
                        ),
                        child: const IntrinsicHeight(
                          child: LetterForm(),
                        ),
                      ),
                    ),
                  ),
                ),
                // Right Side - Empty Space (50% width)
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child:
                        const Scanner(), // Optional: Set to match your design
                  ),
                ),
              ],
            ),
    );
  }
}
