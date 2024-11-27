import 'package:flutter/material.dart';
import 'package:tenderboard/common/utilities/global_helper.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter, // Position cards to top-center
          child: Container(
            margin: const EdgeInsets.all(
                16.0), // Margin to give space around the cards
            child: Wrap(
              spacing: 10, // Horizontal space between cards
              runSpacing: 10, // Vertical space between cards
              children: [
                _buildColorfulCard(getTranslation('Inbox'), '5'),
                _buildColorfulCard('Outbox', '3'),
                _buildColorfulCard('CC', '10'),
                _buildColorfulCard('Circular', '2'),
                _buildColorfulCard('Decision', '8'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorfulCard(String title, String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        width: 150, // Smaller width for compact cards
        height: 150, // Smaller height
        decoration: BoxDecoration(
          color:
              const Color(0xFFE8F5E9), // Pastel green background for all cards
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87, // Dark text for contrast
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.blueAccent, // Pastel blue for the value
                  fontSize: 24, // Increased number font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
