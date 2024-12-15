import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required int typeId,
    required int durationInSeconds,
  }) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    // Define styles based on typeId
    final Map<int, Map<String, dynamic>> typeStyles = {
      1: {
        "color": Colors.green,
        "icon": Icons.check_circle_outline,
      }, // Success
      2: {
        "color": Colors.orange,
        "icon": Icons.warning_amber_outlined,
      }, // Warning
      3: {
        "color": Colors.red,
        "icon": Icons.error_outline,
      }, // Error
    };

    final type = typeStyles[typeId] ??
        {
          "color": Colors.blue,
          "icon": Icons.info_outline,
        };

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: Duration(seconds: durationInSeconds),
      margin: EdgeInsetsDirectional.only(
        bottom: 20,
        start: isRtl ? 1000.0 : 20.0,
        end: isRtl ? 20.0 : 1000.0,
      ),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 280), // Pocket-sized width
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: type["color"],
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                type["icon"],
                color: type["color"],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
