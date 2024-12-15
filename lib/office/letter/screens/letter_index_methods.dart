import 'package:flutter/material.dart';

void loadOptions(bool isLoading) {}

void _saveFormData(
    String reference,
    String year,
    String cabinet,
    String folder,
    String externalLocation,
    String sendTo,
    String receivedFrom,
    String priority,
    String classification,
    String summary,
    String letterSubject,
    context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          'Saved: $reference, $year, $cabinet, $folder, $externalLocation, $sendTo, $receivedFrom, $priority, $classification, $summary, $letterSubject')));
}
