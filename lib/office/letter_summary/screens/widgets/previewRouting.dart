import 'package:flutter/material.dart';
import 'package:tenderboard/office/letter/model/letter_action.dart';

class PreviewRouting extends StatelessWidget {
  final List<LetterAction> routings;

  const PreviewRouting({required this.routings, super.key});

  @override
  Widget build(BuildContext context) {
    print(routings);
    return SizedBox(
      child: Expanded(
        child: ListView.builder(
          itemCount: routings.length,
          itemBuilder: (context, index) {
            final routing = routings[index];
            return ListTile(
              title: Text(routing.actionId
                  .toString()), // Adjust to your `LetterAction` fields
            );
          },
        ),
      ),
    );
  }
}
