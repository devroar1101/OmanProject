import 'package:flutter/material.dart';

class ConfirmationAlertBox extends StatelessWidget {
  final int messageType; // 1: alert, 2: warning, 3: confirmation
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationAlertBox({
    super.key,
    required this.messageType,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    IconData iconData;
    String title;

    switch (messageType) {
      case 1:
        iconColor = Colors.red;
        iconData = Icons.error;
        title = "Alert";
        break;
      case 2:
        iconColor = Colors.orange;
        iconData = Icons.warning;
        title = "Warning";
        break;
      case 3:
        iconColor = Colors.blue;
        iconData = Icons.help_outline;
        title = "Confirmation";
        break;
      default:
        iconColor = Colors.grey;
        iconData = Icons.info;
        title = "Info";
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Row(
        children: [
          Icon(iconData, color: iconColor),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(color: iconColor),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: iconColor,
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
