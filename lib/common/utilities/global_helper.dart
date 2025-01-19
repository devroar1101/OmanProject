import 'dart:math';

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

// Generate a random color for the avatar
Color getRandomColor() {
  final random = Random();
  return Color.fromRGBO(
      random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
}

// Generate a random token (for demo purposes)
String _generateRandomToken() {
  final random = Random();
  const characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(
      32, (index) => characters[random.nextInt(characters.length)]).join();
}
