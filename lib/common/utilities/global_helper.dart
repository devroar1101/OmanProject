import 'package:flutter/material.dart';
import 'package:tenderboard/common/utilities/language_mannager.dart';

String getTranslation(String key) {
  return LocalizationManager().getTranslation(key);
}

Future<void> selectDate(BuildContext context, DateTime initialDate,
    Function(DateTime) onDatePicked) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2000), // Minimum selectable date
    lastDate: DateTime(2101), // Maximum selectable date
  );
  if (picked != null && picked != initialDate) {
    onDatePicked(picked);
  }
}
